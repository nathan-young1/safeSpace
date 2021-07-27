import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';

 String image = 'assets/images/certificate.png';
  
Future<Certificates> decryptCertificateStream(Map<String, dynamic> certificatesJson,databaseName) async {
  Certificates decrypted = Certificates(
  name: await decrypt(certificatesJson['Name']),
  typeOfCertificate: await decrypt(certificatesJson['Type Of Certificate']),
  college: await decrypt(certificatesJson['College']),
  yearOfGraduation: await decrypt(certificatesJson['Year Of Graduation']),
  dbName: databaseName,
  timeStamp: certificatesJson['Time Stamp']
  );
    return decrypted;
  }
  

  class Certificates{
  final String name;
  final String typeOfCertificate;
  final String college;
  final String yearOfGraduation;
  final String dbName;
  final String timeStamp;

  Certificates(
  {required this.college,
  required this.dbName,
  required this.name,
  required this.timeStamp,
  required this.typeOfCertificate,
  required this.yearOfGraduation});

  static Future<void> uploadCertificate({required String name,required String typeOfCertificate,required String yearOfGraduation,required String college,required BuildContext buildContext,required List<File> filesToUpload}) async {
    Navigator.of(buildContext).pop();
    await progressDialog(buildContext: buildContext , message:'Adding Certificate....',command: ProgressDialogVisiblity.show);
    final String uniqueId = '${DateTime.now().microsecondsSinceEpoch}';
    Map<String, dynamic> map = Map<String, dynamic>();
    map['Name'] = await encrypt(name);
    map['Type Of Certificate'] = await encrypt(typeOfCertificate);
    map['College'] = await encrypt(college);
    map['Year Of Graduation'] = await encrypt(yearOfGraduation);
    map['Time Stamp'] = DateTime.now().toIso8601String();
    String customDbName = uniqueId;
    await FirebaseFirestore.instance
        .collection(userUid!)
        .doc(Collection.vault)
        .collection(Collection.certificates)
        .doc(customDbName)
        .set(map);
    await progressDialog(buildContext: buildContext ,command: ProgressDialogVisiblity.hide);
    await FirestoreFileStorage.uploadFileToFirestore(
    collection: Collection.certificates,
    filesToUpload: filesToUpload,
    context: buildContext,
    dbName: customDbName);
  }

  static Future<void> updateCertificate({name,typeOfCertificate,college,yearOfGraduation,required BuildContext context,dbName}) async {
    await progressDialog(buildContext: context , message:'Updating Data...',command:ProgressDialogVisiblity.show);
    Map<String, dynamic> updated = Map<String, dynamic>();
    updated['Name'] = await encrypt(name);
    updated['Type Of Certificate'] = await encrypt(typeOfCertificate);
    updated['College'] = await encrypt(college);
    updated['Year Of Graduation'] = await encrypt(yearOfGraduation);
    await FirebaseFirestore.instance
        .collection(userUid!)
      .doc(Collection.vault)
        .collection(Collection.certificates)
        .doc(dbName)
        .update(updated);
    await progressDialog(buildContext: context, command:ProgressDialogVisiblity.show);
    Navigator.pop(context);
  }

  static Future<void> deleteCertificate({required String dbName,required BuildContext context}) async {
    await progressDialog(buildContext: context,message :'Deleting...',command: ProgressDialogVisiblity.show);
    await FirestoreFileStorage.deleteDirectoryFirestore(Collection.certificates,dbName);
    
    await FirebaseFirestore.instance
    .collection(userUid!)
      .doc(Collection.vault)
    .collection(Collection.certificates).doc(dbName)
    .delete();
    await progressDialog(buildContext: context, command:ProgressDialogVisiblity.hide);
  }
  }