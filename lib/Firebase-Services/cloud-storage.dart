import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart' as auth;
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/filePicker.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Vault-Recryption/listOfFilesInfo.dart';

class FirestoreFileStorage{
    FirebaseStorage database = FirebaseStorage.instance;
    static Future<ListOfFileInfo> getAttachmentList({String collection, String dbName}) async {
      List<String> fileNames = [];
      int totalFileSizeInBytes = 0;
      await FirebaseStorage.instance
      .ref()    
      .child(auth.userUid).child(Collection.vault).child(collection).child(dbName)
      .listAll()
      .then((ref) async {
        for(var item in ref.items){
        totalFileSizeInBytes += (await item.getMetadata()).size;
        String result = (item.fullPath.split('/').last);
        int len = result.length-1;
        var decrypted = await decrypt(String.fromCharCodes(result.substring(1,len).split(',').toList().map(int.parse).toList()));
        fileNames.add(decrypted);
        }
      });
      ListOfFileInfo attachments = ListOfFileInfo(listOfFiles: fileNames,totalSizeInBytes: totalFileSizeInBytes);
      return attachments;
      }
    //using this to test stream in attachments page let it work
    static Stream<List<String>> streamAttachmentList({String collection, String dbName}){
      List<String> fileNames;
      print('stream is called');
       return Stream.periodic(Duration(seconds: 1),(_){
      FirebaseStorage.instance
      .ref()    
      .child(auth.userUid).child(Collection.vault).child(collection).child(dbName)
      .list()
      .then((ref) async {
        fileNames = List<String>();
        for(var item in ref.items){
        String result = (item.fullPath.split('/').last);
        int len = result.length-1;
        var decrypted = await decrypt(String.fromCharCodes(result.substring(1,len).split(',').toList().map(int.parse).toList()));
        fileNames.add(decrypted);
        }
      });
      return fileNames;});
      }

    static Future deleteDirectoryFirestore(String collection,String dbName) async {
    try{
        auth.storage   
        .ref()    
        .child(auth.userUid).child(Collection.vault).child('$collection').child('$dbName').listAll()
        .then((files) {
          for(var file in files.items){
            file.delete();
          }
          return 'Completed';
        });    
    }catch(e){
      print(e);
    }   
      }

    static Future<void> uploadFileToFirestore({String dbName,BuildContext context,String collection,List<File> filesToUpload = const[],List<String> checkIfExist = const[],UploadFileToFirestore commandFrom = UploadFileToFirestore.fromOther}) async {
        List<File> attachments;
        taskCanceled = false;
        UploadTask uploadTask;
        if(filesToUpload.isEmpty && commandFrom == UploadFileToFirestore.fromAttachment){
        attachments = [];
        await progressDialog(buildContext: context,message: 'Please Wait...',command: ProgressDialogVisiblity.show);
        attachments.addAll(await filePicker());
        progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
        }else{
          attachments = filesToUpload;
        }

        if (attachments.isNotEmpty) {
        showTaskDialog(context, attachments.length,TaskDialog.upload);
        int currentIndex = 1;
        for (File file in attachments) {
          print(file.path.split('/').last);
          print(checkIfExist);
          if(taskCanceled){
            uploadTask.cancel();
            break;
          }
        Provider.of<AttachmentDownload>(context, listen: false).updateIndex(currentIndex);
        if(!checkIfExist.contains(file.path.split('/').last)){
        await encrypt(file.path.split('/').last).then((filePath) async {
        List<int> fullPath = filePath.toString().codeUnits;
        Reference storageReference = auth.storage 
            .ref()
            .child(auth.userUid)
            .child(Collection.vault)
            .child(collection)
            .child(dbName)
            .child('$fullPath');
        Map<FileEncrypt, dynamic> encryptedFile = await fileEncrypt(file);
        uploadTask = storageReference.putFile(encryptedFile[FileEncrypt.file]);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) =>
        Provider.of<AttachmentDownload>(context,listen: false).update((snapshot.bytesTransferred) /(snapshot.totalBytes)), 
        onError: (Object e) {
          print(e); // FirebaseException
        });
        await uploadTask;
        await File(encryptedFile[FileEncrypt.filePath]).delete();
         });}else{
           //update already existing file
        await encrypt(file.path.split('/').last).then((filePath) async {
        List<int> fullPath = filePath.toString().codeUnits;
        Reference storageReference = auth.storage 
            .ref()
            .child(auth.userUid)
            .child(Collection.vault)
            .child(collection)
            .child(dbName)
            .child('$fullPath');
        //delete before update
        await storageReference.delete();
        Map<FileEncrypt, dynamic> encryptedFile = await fileEncrypt(file);
        uploadTask = storageReference.putFile(encryptedFile[FileEncrypt.file]);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) =>
        Provider.of<AttachmentDownload>(context,listen: false).update((snapshot.bytesTransferred) /(snapshot.totalBytes)), 
        onError: (Object e) {
          print(e); // FirebaseException
        });
        await uploadTask;
        await File(encryptedFile[FileEncrypt.filePath]).delete();
         });
         }
          currentIndex++;
        }
        Navigator.of(context).pop();
      }
    }

    static downloadFilesFromFirestore({@required String dbName,@required BuildContext context,@required String collection,@required dynamic attachmentNames,@required String documentName}) async {
    print(taskCanceled);
    taskCanceled = false;
    List<String> filenames = List<String>();
    DownloadTask download;
    (attachmentNames.runtimeType != String)
    ? filenames.addAll(attachmentNames)
    : filenames.add(attachmentNames);
    
    int currentIndex = 1;
    int filesLength = filenames
        .where((element) =>
            (!fileExists(collection: collection, documentName: documentName, fileName: element)))
        .toList()
        .length;
    showTaskDialog(context,filesLength,TaskDialog.download);
    for (int i = 0; i < filenames.length; i++) {
      if (taskCanceled){
        await download.cancel();
        break;}
      String filePath = filenames[i];
      List<int> dbPath = (await encrypt(filenames[i])).toString().codeUnits;
      if (!fileExists(collection: collection,documentName: documentName, fileName: filenames[i])) {
        Provider.of<AttachmentDownload>(context, listen: false).updateIndex(currentIndex);
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(auth.userUid)
            .child(Collection.vault)
            .child(collection)
            .child(dbName)
            .child('$dbPath');

        final Directory systemTempDir = Directory.systemTemp;
        final File tempFile = File('${systemTempDir.path}/Decrypted');
        if (tempFile.existsSync()) {await tempFile.delete();}
        await tempFile.create();
        download = ref.writeToFile(tempFile);
        download.snapshotEvents.listen((TaskSnapshot snapshot) =>
          Provider.of<AttachmentDownload>(context, listen: false).update((snapshot.bytesTransferred / snapshot.totalBytes)));
        await download.then((value) async {
          await fileDecrypt(tempFile, filePath, collection, documentName);
        });
        await tempFile.delete();
        currentIndex++;
      } else {
        print('$filePath already exists');
        continue;
      }
    }
    Navigator.of(context).pop();
    }
  }