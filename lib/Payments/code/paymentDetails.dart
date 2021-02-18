import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/visuals.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';

Future<Payments> decryptPaymentStream(Map<String, dynamic> paymentsJson,databaseName) async {
  
  Payments decrypted = Payments(
    name: await decrypt(paymentsJson['Name']),
    nameOnCard: await decrypt(paymentsJson['Name On Card']),
    typeOfCard: await decrypt(paymentsJson['Type Of Card']),
    numberOnCard: await decrypt(paymentsJson['Number On Card']),
    securityCode: await decrypt(paymentsJson['Security Code']),
    expirationDate: await decrypt(paymentsJson['Expiration Date']),
    dbName: databaseName,
    image: await getVisuals((await decrypt(paymentsJson['Image Url'])).toString().toLowerCase()),
    timeStamp: paymentsJson['Time Stamp']
  );
  return decrypted;
}

class Payments {
  final String name;
  final String nameOnCard;
  final String typeOfCard;
  final String numberOnCard;
  final String securityCode;
  final String expirationDate;
  final String dbName;
  final String image;
  final String timeStamp;
  Payments(
      {this.expirationDate,
      this.dbName,
      this.name,
      this.nameOnCard,
      this.numberOnCard,
      this.securityCode,
      this.timeStamp,
      this.typeOfCard,
      this.image}
      );


  static Future<void> deletePayment({String dbName,BuildContext context}) async {
  await progressDialog(buildContext: context,message: 'Deleting...',command: ProgressDialogVisiblity.show);
  await FirestoreFileStorage.deleteDirectoryFirestore(Collection.payments,dbName);
  await FirebaseFirestore.instance
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.payments)
      .doc(dbName)
      .delete();
  await progressDialog(buildContext: context, command:ProgressDialogVisiblity.hide);
  }

  static Future<void> uploadPayment({name, nameOnCard, numberOnCard, securityCode, typeOfCard,expirationDate,BuildContext context,List<File> filesToUpload}) async {
    Navigator.of(context).pop();
    await progressDialog(buildContext: context, message:'Adding Payment....', command: ProgressDialogVisiblity.show);
    final String uniqueId = '${DateTime.now().microsecondsSinceEpoch}';
    Map map = Map<String, dynamic>();
    map['Name'] = await encrypt(name);
    map['Name On Card'] = await encrypt(nameOnCard);
    map['Type Of Card'] = await encrypt(typeOfCard);
    map['Number On Card'] = await encrypt(numberOnCard);
    map['Security Code'] = await encrypt(securityCode);
    map['Expiration Date'] = await encrypt(expirationDate);
    map['Image Url'] = await encrypt(typeOfCard);
    map['Time Stamp'] = DateTime.now().toIso8601String();
    String customDbName = uniqueId;
    await FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.payments)
        .add(data: map, customDbName: customDbName);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    await FirestoreFileStorage.uploadFileToFirestore(collection: Collection.payments,context: context,filesToUpload: filesToUpload,dbName: customDbName);
  }
  
  static Future<void> updatePayment({name, nameOnCard, numberOnCard, securityCode, typeOfCard,expirationDate,BuildContext context, dbName}) async {
    await progressDialog(buildContext: context, message:'Updating Data....', command: ProgressDialogVisiblity.show);
    FocusScope.of(context).unfocus();
    Map updated = Map<String, dynamic>();
    updated['Name'] = await encrypt(name);
    updated['Name On Card'] = await encrypt(nameOnCard);
    updated['Type Of Card'] = await encrypt(typeOfCard);
    updated['Number On Card'] = await encrypt(numberOnCard);
    updated['Security Code'] = await encrypt(securityCode);
    updated['Expiration Date'] = await encrypt(expirationDate);
    await FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.payments)
        .doc(dbName)
        .update(updated);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    Navigator.of(context).pop();
  }
}
