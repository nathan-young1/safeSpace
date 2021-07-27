import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';

Future<Passports> decryptPassportStream(Map<String, dynamic> passportsJson,databaseName) async {
    Passports decrypted = Passports(
      name: await decrypt(passportsJson['Name']),
      nationality: await decrypt(passportsJson['Nationality']),
      gender: await decrypt(passportsJson['Gender']),
      country: await decrypt(passportsJson['Country']),
      idNumber: await decrypt(passportsJson['Id Number']),
      typeOfPassport: await decrypt(passportsJson['Type Of Passport']),
      passportNumber: await decrypt(passportsJson['Passport Number']),
      issuedDate: await decrypt(passportsJson['Issued Date']),
      expireDate: await decrypt(passportsJson['Expiration Date']),
      birthDate: await decrypt(passportsJson['Date Of Birth']),
      issuedAuthority: await decrypt(passportsJson['Issued Authority']),
      timeStamp: passportsJson['Time Stamp'],
      dbName: databaseName
    );
    return decrypted;
    }


  class Passports{
  final String name;
  final String nationality;
  final String gender;
  final String country;
  final String idNumber;
  final String typeOfPassport;
  final String passportNumber;
  final String issuedDate;
  final String expireDate;
  final String birthDate;
  final String issuedAuthority;
  final String timeStamp;
  final String dbName;

  Passports({
  this.name,
  this.nationality,
  this.gender,
  this.country,
  this.idNumber,
  this.typeOfPassport,
  this.passportNumber,
  this.issuedDate,
  this.expireDate,
  this.birthDate,
  this.issuedAuthority,
  this.timeStamp,
  this.dbName});

  static Future<void> deletePassport({String dbName,BuildContext context}) async {
    await progressDialog(buildContext: context,message :'Deleting...',command: ProgressDialogVisiblity.show);
    await FirestoreFileStorage.deleteDirectoryFirestore(Collection.passports,dbName);
    await FirebaseFirestore.instance
    .collection(userUid)
      .doc(Collection.vault) 
    .collection(Collection.passports).doc(dbName)
    .delete();
    await progressDialog(buildContext: context, command:ProgressDialogVisiblity.hide);
  }

  static Future<void> uploadPassport({BuildContext context,name,nationality,gender,country,idNumber,typeOfPassport,passportNumber,issuedDate,
    expireDate,birthDate,issuedAuthority,List<File> filesToUpload}) async {
    Navigator.of(context).pop();
    await progressDialog(buildContext: context, message:'Adding Passport....', command: ProgressDialogVisiblity.show);
    final String uniqueId = '${DateTime.now().microsecondsSinceEpoch}';
    Map map = Map<String, dynamic>();
    map['Name'] = await encrypt(name);
    map['Nationality'] = await encrypt(nationality);
    map['Gender'] = await encrypt(gender);
    map['Country'] = await encrypt(country);
    map['Id Number'] = await encrypt(idNumber);
    map['Type Of Passport'] = await encrypt(typeOfPassport);
    map['Passport Number'] = await encrypt(passportNumber);
    map['Issued Date'] = await encrypt(issuedDate);
    map['Expiration Date'] = await encrypt(expireDate);
    map['Date Of Birth'] = await encrypt(birthDate);
    map['Issued Authority'] = await encrypt(issuedAuthority);
    map['Time Stamp'] = DateTime.now().toIso8601String();
    String customDbName = uniqueId;
    await FirebaseFirestore.instance
        .collection(userUid)
        .doc(Collection.vault)
        .collection(Collection.passports)
        .doc(customDbName)
        .set(map);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    await FirestoreFileStorage.uploadFileToFirestore(collection: Collection.passports,context: context,filesToUpload: filesToUpload,dbName: customDbName);
  }

  static Future<void> updatePassport({BuildContext context, name,nationality,gender,country,idNumber,typeOfPassport,
  passportNumber,issuedDate,expireDate,birthDate,issuedAuthority,dbName}) async {
    FocusScope.of(context).unfocus();
    await progressDialog(buildContext: context,message: 'Updating Data...',command: ProgressDialogVisiblity.show);
    Map updated = Map<String, dynamic>();
    updated['Name'] = await encrypt(name);
    updated['Nationality'] = await encrypt(nationality);
    updated['Gender'] = await encrypt(gender);
    updated['Country'] = await encrypt(country);
    updated['Id Number'] = await encrypt(idNumber);
    updated['Type Of Passport'] = await encrypt(typeOfPassport);
    updated['Passport Number'] = await encrypt(passportNumber);
    updated['Issued Date'] = await encrypt(issuedDate);
    updated['Expiration Date'] = await encrypt(expireDate);
    updated['Date Of Birth'] = await encrypt(birthDate);
    updated['Issued Authority'] = await encrypt(issuedAuthority);
    await FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.passports)
        .doc(dbName)
        .update(updated);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    Navigator.of(context).pop();
  }
  }
  