import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/userEncryptionTools.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Passwords/ui/password.dart';

String? name;
String? email;
String? userUid;
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User? user;

// ignore: missing_return
Future<Authentication?> registerWithEmailAndPassword(String password,BuildContext context) async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  try {
  await googleSignIn.signOut();
  //await user creation
  user = (await auth.createUserWithEmailAndPassword(email: googleSignInAccount!.email, password: await hashVaultKey(password: password,emailAddress: googleSignInAccount.email))).user;
 //await sign in to set the user custom claims
  await Future.delayed(Duration(seconds: 5),() async =>await user!.reload());
  email = googleSignInAccount.email;
  name = googleSignInAccount.email.substring(0,googleSignInAccount.email.indexOf('@'));
  userUid = user!.uid;
  await UserEncryptionTools.setEncryptionKeyForNewUser(userPassword: password);
  return Authentication.Successful;
  } on FirebaseAuthException catch (e) {
  showFlushBar(context,e.code,Icons.error);
    switch(e.code){
      case 'weak-password':
      Navigator.of(context).pop();
      return Authentication.WeakPassword;
      case 'email-already-in-use':
      Navigator.of(context).pop();
      return Authentication.EmailExists;
    }
} catch (e) {
  Navigator.of(context).pop();
  showFlushBar(context,e,Icons.error);
  return Authentication.Error;
}
}


// ignore: missing_return
Future<Authentication?> signInWithEmailAndPasswordInLogin(String emailAddress,String password,[BuildContext? context]) async {
  try{
  user = (await auth.signInWithEmailAndPassword(email: emailAddress, password: await hashVaultKey(password: password,emailAddress: emailAddress))).user;
    email = emailAddress;
    name = emailAddress.substring(0,emailAddress.indexOf('@'));
   userUid = user!.uid;
   await UserEncryptionTools.initialize(userPassword: password);
  return Authentication.Successful;
  } on FirebaseAuthException catch (e) {
    print(e);
  showFlushBar(context,e.code,Icons.error);
    switch (e.code) {
      case 'user-not-found':
      return Authentication.InvalidDetail;
      case 'wrong-password':
      return Authentication.WrongPassword;
    }
}catch(e){
  print(e.toString());
  showFlushBar(context,"An error occurred",Icons.error);
  return Authentication.Error;
}
}

signOut(BuildContext context) async{
  getStorageLeft!.cancel();
  await auth.signOut();
  UserEncryptionTools.clear();
  Navigator.pushReplacementNamed(context, 'Login');
  Provider.of<Dashboard>(context,listen: false).change(Password());
}

String increasePasswordLengthTo32(String passwordToIncreaseLength){
  String key = passwordToIncreaseLength;
  String encryptionKey = '';
  int count = 0;
  for (int i = 1; i <= 32; i++){
    encryptionKey += key[count];
    if (count < key.length - 1){
    count++;
    }else{
      count = 0;
    }
  }
  return encryptionKey;
}

hashVaultKey({required String emailAddress,required String password}){
  int length = password.length~/2;
  String firstPart = password.substring(0,length);
  String secondPart = password.substring(length);
  var bytes = utf8.encode('$firstPart$emailAddress$secondPart'); // data being hashed

  var digest = sha512.convert(bytes);
  return digest.toString();
}