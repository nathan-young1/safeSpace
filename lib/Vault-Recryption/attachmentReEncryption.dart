import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Payments/code/paymentDetails.dart';
import 'package:safeSpace/Vault-Recryption/aesReEncrypt.dart';
import 'package:safeSpace/Vault-Recryption/listOfFilesInfo.dart';
import 'reEncryptionPercent.dart';

    
Future paymentAttachmentReEncrypt(List<Payments> payments,BuildContext context) async {
  List<File> paymentCheckList = [];
  //the size of all the files 
  int totalNumberOfBytesHere = 0;
  bool pausedReEncryption = _doesDirectoryExist(collection: Collection.payments);
  if(!pausedReEncryption){
  payments.forEach((payment) => _createATextFile(collection: Collection.payments,dbName: payment.dbName));
  }
  //add to list of Files for easy access only if directory exists
  List<File> allList = [];
  if(_doesDirectoryExist(collection: Collection.payments)){
  allList = await _listAllFilesInDir(collection: Collection.payments);
  }
  paymentCheckList = allList;
  if(!pausedReEncryption){
  for(File checkList in List<File>.from(paymentCheckList)){
  String dbName = _getDbNameFromFile(checkList);
  //get list of attachment for each payment
  ListOfFileInfo attachmentInfo = await FirestoreFileStorage.getAttachmentList(collection: Collection.payments,dbName: dbName);
  List<String> attachmentList = attachmentInfo.listOfFiles;
  totalNumberOfBytesHere += attachmentInfo.totalSizeInBytes;
  //call the function to write all attachment names to the list text file
  if(attachmentList.length != 0){
  await _writeAttachmentListToCheckListFile(attachmentList: attachmentList,checkList: checkList);
  }else{
    await File('${GetDirectories.pathToVaultFolder}/CheckList/$email/${Collection.payments}/$dbName.txt').delete(recursive: true);
    paymentCheckList.remove(checkList);
  }
  }
  }
  Provider.of<ReEncryptionPercent>(context,listen: false).totalNumberOfBytes(totalNumberOfBytesHere);
   //the actual reEncryption process
   for(File list in paymentCheckList){
     //get database name from file path
     String dbName = _getDbNameFromFile(list);
     List<String> checkList = list.readAsLinesSync();
     //for each attachment in that document reEncrypt it
    for(String attachmentPath in List<String>.from(checkList)){
      try{
      List<int> currentDbPath = (await encrypt(attachmentPath,Cyptography.ReEncryption)).toString().codeUnits;
      List<int> newDbPath = (await reEncryptData(plainText: attachmentPath)).toString().codeUnits;
      File tempFile = await _downloadAndWriteToTemp(collection: Collection.payments,dbName: dbName,currentDbPath: '$currentDbPath');
      File fileToReEncrypt = await fileDecrypt(tempFile, attachmentPath, Collection.payments, dbName,mode: Cyptography.ReEncryption);
      await _uploadReEncryptedFileToFirebase(collection: Collection.payments,dbName: dbName,currentDbPath: '$currentDbPath',fileToReEncrypt: fileToReEncrypt,newDbPath: '$newDbPath',context: context);
      //delete the temporary file
      await tempFile.delete();
      //remove this file name from the checklist
      checkList.remove(attachmentPath);
      print('$checkList the checkList');
      //delete old checklist
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      //create updated check list
      //write updated check list to file
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} updated checkList');
      }catch(e){
        print(e);
      checkList.remove(attachmentPath);
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} exception checkList');
        continue;
      }
     }
   }
    await _deleteDirectory(collection: Collection.payments);
}

Future passportAttachmentReEncrypt(List<Passports> passports,BuildContext context) async {
  List<File> passportsCheckList = [];
  int totalNumberOfBytesHere = 0;
  bool pausedReEncryption = _doesDirectoryExist(collection: Collection.passports);
  if(!pausedReEncryption){
  passports.forEach((passport) => _createATextFile(collection: Collection.passports,dbName: passport.dbName));
  }

  List<File> allList = [];
  if(_doesDirectoryExist(collection: Collection.passports)){
  allList = await _listAllFilesInDir(collection: Collection.passports);
  }
  passportsCheckList = allList;
  if(!pausedReEncryption){
  for(File checkList in List<File>.from(passportsCheckList)){
  String dbName = _getDbNameFromFile(checkList);
  ListOfFileInfo attachmentInfo = await FirestoreFileStorage.getAttachmentList(collection: Collection.passports,dbName: dbName);
  List<String> attachmentList = attachmentInfo.listOfFiles;
  totalNumberOfBytesHere += attachmentInfo.totalSizeInBytes;
  if(attachmentList.length != 0){
  await _writeAttachmentListToCheckListFile(attachmentList: attachmentList,checkList: checkList);
  }else{
  await File('${GetDirectories.pathToVaultFolder}/CheckList/$email/${Collection.passports}/$dbName.txt').delete(recursive: true);
  passportsCheckList.remove(checkList);
  }
  }
  }
    Provider.of<ReEncryptionPercent>(context,listen: false).totalNumberOfBytes(totalNumberOfBytesHere);
   for(File list in passportsCheckList){
     String dbName = _getDbNameFromFile(list);
     List<String> checkList = list.readAsLinesSync();
    for(String attachmentPath in List<String>.from(checkList)){
      try{
      List<int> currentDbPath = (await encrypt(attachmentPath,Cyptography.ReEncryption)).toString().codeUnits;
      List<int> newDbPath = (await reEncryptData(plainText: attachmentPath)).toString().codeUnits;
      File tempFile = await _downloadAndWriteToTemp(collection: Collection.passports,dbName: dbName,currentDbPath: '$currentDbPath');
      File fileToReEncrypt = await fileDecrypt(tempFile, attachmentPath, Collection.passports, dbName,mode: Cyptography.ReEncryption);
      await _uploadReEncryptedFileToFirebase(collection: Collection.passports,dbName: dbName,currentDbPath: '$currentDbPath',fileToReEncrypt: fileToReEncrypt,newDbPath: '$newDbPath',context: context);
      await tempFile.delete();
      checkList.remove(attachmentPath);
      print('$checkList the checkList');
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} updated checkList');
      }catch(e){
      checkList.remove(attachmentPath);
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} exception checkList');
        continue;
      }
     }
   }

   await _deleteDirectory(collection: Collection.passports);
}

Future documentAttachmentReEncrypt(List<Document> documents,BuildContext context) async {
  List<File> documentsCheckList = [];
  int totalNumberOfBytesHere = 0;
  bool pausedReEncryption = _doesDirectoryExist(collection: Collection.documents);
  if(!pausedReEncryption){
  documents.forEach((document) => _createATextFile(collection: Collection.documents,dbName: document.dbName));
  }

  List<File> allList = [];
  if(_doesDirectoryExist(collection: Collection.documents)){
  allList = await _listAllFilesInDir(collection: Collection.documents);
  }
  documentsCheckList = allList;
  if(!pausedReEncryption){
  for(File checkList in List<File>.from(documentsCheckList)){
  String dbName = _getDbNameFromFile(checkList);
  ListOfFileInfo attachmentInfo = await FirestoreFileStorage.getAttachmentList(collection: Collection.documents,dbName: dbName);
  List<String> attachmentList = attachmentInfo.listOfFiles;
  totalNumberOfBytesHere += attachmentInfo.totalSizeInBytes;
  if(attachmentList.length != 0){
  await _writeAttachmentListToCheckListFile(attachmentList: attachmentList,checkList: checkList);
  }else{
    await File('${GetDirectories.pathToVaultFolder}/CheckList/$email/${Collection.documents}/$dbName.txt').delete(recursive: true);
    documentsCheckList.remove(checkList);
  }
  }
  }
    Provider.of<ReEncryptionPercent>(context,listen: false).totalNumberOfBytes(totalNumberOfBytesHere);
   for(File list in documentsCheckList){
     String dbName = _getDbNameFromFile(list);
     List<String> checkList = list.readAsLinesSync();
    for(String attachmentPath in List<String>.from(checkList)){
      try{
      List<int> currentDbPath = (await encrypt(attachmentPath,Cyptography.ReEncryption)).toString().codeUnits;
      List<int> newDbPath = (await reEncryptData(plainText: attachmentPath)).toString().codeUnits;
      print('$dbName $currentDbPath');
      File tempFile = await _downloadAndWriteToTemp(collection: Collection.documents,dbName: dbName,currentDbPath: '$currentDbPath');
      File fileToReEncrypt = await fileDecrypt(tempFile, attachmentPath, Collection.documents, dbName,mode: Cyptography.ReEncryption);
      await _uploadReEncryptedFileToFirebase(collection: Collection.documents,dbName: dbName,currentDbPath: '$currentDbPath',fileToReEncrypt: fileToReEncrypt,newDbPath: '$newDbPath',context: context);
      await tempFile.delete();
      checkList.remove(attachmentPath);
      print('$checkList the checkList');
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} updated checkList');
      }catch(e){
      checkList.remove(attachmentPath);
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} exception checkList');
        continue;
      }
     }
   }

   await _deleteDirectory(collection: Collection.documents);
}

Future certificateAttachmentReEncrypt(List<Certificates> certificates,BuildContext context) async {
  List<File> certificatesCheckList = [];
  int totalNumberOfBytesHere = 0;
  bool pausedReEncryption = _doesDirectoryExist(collection: Collection.certificates);
  if(!pausedReEncryption){
  certificates.forEach((certificate) => _createATextFile(collection: Collection.certificates,dbName: certificate.dbName));
  }

  List<File> allList = [];
  if(_doesDirectoryExist(collection: Collection.certificates)){
  allList = await _listAllFilesInDir(collection: Collection.certificates);
  }
  certificatesCheckList = allList;
  if(!pausedReEncryption){
  for(File checkList in List<File>.from(certificatesCheckList)){
  String dbName = _getDbNameFromFile(checkList);
  ListOfFileInfo attachmentInfo = await FirestoreFileStorage.getAttachmentList(collection: Collection.certificates,dbName: dbName);
  List<String> attachmentList = attachmentInfo.listOfFiles;
  totalNumberOfBytesHere += attachmentInfo.totalSizeInBytes;
  if(attachmentList.length != 0){
  await _writeAttachmentListToCheckListFile(attachmentList: attachmentList,checkList: checkList);
  }else{
    await File('${GetDirectories.pathToVaultFolder}/CheckList/$email/${Collection.certificates}/$dbName.txt').delete(recursive: true);
    certificatesCheckList.remove(checkList);
  }
  }
  }
  print('i am the total number of bytes $totalNumberOfBytesHere');
    Provider.of<ReEncryptionPercent>(context,listen: false).totalNumberOfBytes(totalNumberOfBytesHere);
   for(File list in certificatesCheckList){
     String dbName = _getDbNameFromFile(list);
     List<String> checkList = list.readAsLinesSync();
    for(String attachmentPath in List<String>.from(checkList)){
      try{
      List<int> currentDbPath = (await encrypt(attachmentPath,Cyptography.ReEncryption)).toString().codeUnits;
      List<int> newDbPath = (await reEncryptData(plainText: attachmentPath)).toString().codeUnits;
      File tempFile = await _downloadAndWriteToTemp(collection: Collection.certificates,dbName: dbName,currentDbPath: '$currentDbPath');
      File fileToReEncrypt = await fileDecrypt(tempFile, attachmentPath, Collection.certificates, dbName,mode: Cyptography.ReEncryption);
      await _uploadReEncryptedFileToFirebase(collection: Collection.certificates,dbName: dbName,currentDbPath: '$currentDbPath',fileToReEncrypt: fileToReEncrypt,newDbPath: '$newDbPath',context: context);
      await tempFile.delete();
      checkList.remove(attachmentPath);
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} updated checkList');
      }catch(e){
      checkList.remove(attachmentPath);
      list.writeAsStringSync('',mode: FileMode.writeOnly);
      for(String notChecked in checkList){list.writeAsStringSync('$notChecked\n',mode: FileMode.writeOnlyAppend);}
      print('${await list.readAsLines()} exception checkList');
        continue;
      }
     }
   }

   await _deleteDirectory(collection: Collection.certificates);
}

_writeAttachmentListToCheckListFile({@required List<String> attachmentList,@required File checkList}) async {
  attachmentList.forEach((path){ 
    return checkList.writeAsStringSync('$path\n',mode: FileMode.writeOnlyAppend);
    });
    return checkList;
}

Future<File> _downloadAndWriteToTemp({@required String collection,@required String dbName,@required String currentDbPath}) async {
 Reference ref = FirebaseStorage.instance
            .ref()
            .child(userUid)
            .child(Collection.vault)
            .child(collection)
            .child(dbName)
            .child(currentDbPath);

final File tempFile = File('${GetDirectories.systemTempDir.path}/Decrypted ${DateTime.now().millisecondsSinceEpoch}');
if (tempFile.existsSync()) {tempFile.deleteSync();}
await tempFile.create();
await ref.writeToFile(tempFile); 
return tempFile;
}

_uploadReEncryptedFileToFirebase({@required String collection,@required String dbName,@required String newDbPath,@required File fileToReEncrypt,@required String currentDbPath,@required BuildContext context}) async {
  UploadTask uploadTask;
  Reference storageReference = FirebaseStorage.instance
          .ref()
          .child(userUid)
          .child(Collection.vault)
          .child(collection)
          .child(dbName)
          .child(newDbPath);
  Map<FileEncrypt, dynamic> encrypted = await fileEncrypt(fileToReEncrypt,mode: Cyptography.ReEncryption);
  uploadTask = storageReference.putFile(encrypted[FileEncrypt.file]);
  //Because bytesTransferred is joining all the total byte transferred so will show me the size of byte uploaded currently
  int trackProgress = 0;
  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //The size of byte currently uploaded
  int currentSizeUploaded = (snapshot.bytesTransferred - trackProgress);
  Provider.of<ReEncryptionPercent>(context,listen: false).updateNumberOfBytesDownloaded((currentSizeUploaded));
  trackProgress = snapshot.bytesTransferred;
  },
  onError: (Object e) => print(e));

  await uploadTask.then((_) async {
      await FirebaseStorage.instance
          .ref()
          .child(userUid)
          .child(Collection.vault)
          .child(collection)
          .child(dbName)
          .child(currentDbPath)
          .delete();
  });
  await File(encrypted[FileEncrypt.filePath]).delete();
}
_getDbNameFromFile(File file){
  String dbName = file.path.split('/').last.split('.').first;
  return dbName;
}

_createATextFile({@required String collection,@required String dbName}) => File('${GetDirectories.pathToVaultFolder}/CheckList/$email/$collection/$dbName.txt').createSync(recursive: true);
_doesDirectoryExist({@required String collection}) => Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email/$collection').existsSync();
_listAllFilesInDir({@required String collection}) async => await (Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email/$collection').list()).where((item)=>  item is File).map((item)=> item as File).toList();

_deleteDirectory({@required String collection}){
  if(Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email/$collection').existsSync()){
     Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email/$collection').deleteSync(recursive: true);
  }
}