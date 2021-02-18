import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/encrypt.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/visuals.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';

Future<Passwords> decryptPasswordStream(Map<String, dynamic> passwordJson,databaseName) async {
  Passwords decrypted = Passwords(
    title: await decrypt(passwordJson['Title']),
    username: await decrypt(passwordJson['Username']),
    password: await decrypt(passwordJson['Password']),
    networkUrl: await decrypt(passwordJson['Networkurl']),
    color: Color(int.parse(passwordJson['Color'])),
    image: await getVisuals((await decrypt(passwordJson['Title'])).toString().toLowerCase()),
    timeStamp: passwordJson['Time Stamp'],
    dbName: databaseName
  );
  return decrypted;
}


class Passwords {
  final String title;
  final String username;
  final String password;
  final String networkUrl;
  final String dbName;
  final Color color;
  final String image;
  final String timeStamp;
  
  Passwords(
      {this.title,
      this.color,
      this.dbName,
      this.networkUrl,
      this.password,
      this.username,
      this.image,
      this.timeStamp});

  static Future<void> deletePassword({String dbName,BuildContext context}) async {
  await progressDialog(buildContext:context, message:'Deleting...', command: ProgressDialogVisiblity.show);
  await FirebaseFirestore.instance
      .collection(userUid)
      .doc(Collection.vault)
      .collection(Collection.passwords)
      .doc(dbName)
      .delete();
  await progressDialog(buildContext:context,command: ProgressDialogVisiblity.hide);
}

  static Future<void> uploadPassword({title, networkUrl, username, password, color,BuildContext context}) async {
    await progressDialog(buildContext: context, message:'Adding Password....', command: ProgressDialogVisiblity.show);
    final String uniqueId = '${DateTime.now().microsecondsSinceEpoch}';
    Map map = Map<String, dynamic>();
    map['Title'] = await encrypt(title);
    map['Username'] = await encrypt(username);
    map['Password'] = await encrypt(password);
    map['Networkurl'] = await encrypt(networkUrl);
    map['Color'] = color;
    map['Time Stamp'] = DateTime.now().toIso8601String();

    String customDbName = uniqueId;
    await FirebaseFirestore.instance
        .collection(userUid)
        .doc(Collection.vault)
        .collection(Collection.passwords)
        .add(data: map, customDbName: customDbName);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
  }


  static Future<void> updatePassword({username, password,BuildContext context,dbName}) async {
    await progressDialog(buildContext: context,message: 'Updating Data...',command: ProgressDialogVisiblity.show);
    Map map = Map<String, String>();
    map['Username'] = await encrypt(username);
    map['Password'] = await encrypt(password);
    await FirebaseFirestore.instance
        .collection(userUid)
        .doc(Collection.vault)
        .collection(Collection.passwords)
        .doc(dbName)
        .update(map);
    await progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    Navigator.of(context).pop();
  }
  }
