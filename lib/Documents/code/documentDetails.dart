import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';

String image = 'assets/images/document.png';

Future<Document> decryptDocumentStream(Map<String, dynamic> documentsJson,databaseName) async {
  Document decrypted = Document(
    nameOfDocument: await decrypt(documentsJson['Name Of Document']),
    note: await decrypt(documentsJson['Note']),
    dbName: databaseName,
    timeStamp: documentsJson['Time Stamp']
  );
  return decrypted;
}


class Document {
  final String nameOfDocument;
  final String note;
  final String dbName;
  final String timeStamp;
  Document(
      {this.nameOfDocument,
      this.note,
      this.dbName,
      this.timeStamp}
      );

  static Future<void> deleteDocument({String dbName,BuildContext context}) async {
  await progressDialog(buildContext:context, message:'Deleting...', command: ProgressDialogVisiblity.show);
  await FirestoreFileStorage.deleteDirectoryFirestore(Collection.documents,dbName);
  await FirebaseFirestore.instance
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.documents)
      .doc(dbName)
      .delete();
  await progressDialog(buildContext:context,command: ProgressDialogVisiblity.hide);
}

  static Future<void> uploadDocument({nameOfDocument, note,BuildContext context,filesToUpload}) async {
    Navigator.of(context).pop();
    await progressDialog(buildContext: context, message:'Adding Document....', command: ProgressDialogVisiblity.show);
    final String uniqueId = '${DateTime.now().microsecondsSinceEpoch}';
    Map map = Map<String, dynamic>();
    map['Name Of Document'] = await encrypt(nameOfDocument);
    map['Note'] = await encrypt(note);
    map['Time Stamp'] = DateTime.now().toIso8601String();
    String customDbName = uniqueId;
    await FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.documents)
        .doc(customDbName)
        .set(map);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    await FirestoreFileStorage.uploadFileToFirestore(collection: Collection.documents,dbName: customDbName,filesToUpload: filesToUpload,context: context);
  }
  
  static Future<void> updateDocument({BuildContext context,nameOfDocument,note,dbName}) async {
    await progressDialog(buildContext: context,message: 'Updating Data...',command: ProgressDialogVisiblity.show);
    Map updated = Map<String, dynamic>();
    updated['Name Of Document'] = await encrypt(nameOfDocument);
    updated['Note'] = await encrypt(note);
    await FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.documents)
        .doc(dbName)
        .update(updated);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    Navigator.of(context).pop();
  }
  }
