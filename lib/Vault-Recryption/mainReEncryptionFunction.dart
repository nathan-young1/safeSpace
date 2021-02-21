import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Passwords/code/passwordDetails.dart';
import 'package:safeSpace/Payments/code/paymentDetails.dart';
import 'package:safeSpace/Vault-Recryption/attachmentReEncryption.dart';
import 'package:safeSpace/Vault-Recryption/dataReEncryptionFunction.dart';
import 'reEncryptionPercent.dart';

vaultReEncryption({String masterKey,String newPassword,BuildContext context,VaultReEncryptionMode mode = VaultReEncryptionMode.Normal}) async {
    FocusScope.of(context).unfocus();
    progressDialog(buildContext: context,message: 'ReEncrypting Vault',command: ProgressDialogVisiblity.show);
    Provider.of<ReEncryptionPercent>(context,listen: false).intialize();
    if(mode == VaultReEncryptionMode.Normal){
    //assert that the key the user type is correct 
    try {
      assert(createEncryptionKey(masterKey) == masterkey);
    } on Exception catch (e) {
      showFlushBar(context,'Invalid Vault Key',Icons.dangerous);
    }
    VaultReEncryption.initalize(updatedVaultKey: newPassword,oldVaultKey: masterkey);
    }
    List<Passwords> passwords = await _getPasswordsFromFirestore();
    List<Payments> payments = await _getPaymentsFromFirestore();
    List<Passports> passports = await _getPassportsFromFirestore();
    List<Document> documents = await _getdocumentsFromFirestore();
    List<Certificates> certificates = await _getCertificatesFromFirestore();
    if(mode == VaultReEncryptionMode.Resume){
      //check if it is owner that is resuming the reEncryption
      try {
        assert(createEncryptionKey(newPassword) == masterkey);
      } on Exception catch (e) {
        showFlushBar(context,'Invalid Vault Key',Icons.dangerous);
      }
      VaultReEncryption.initalize(updatedVaultKey: newPassword,oldVaultKey: masterKey);
    }
  try{
    //stop the getting of storage token during reEncryption
    getStorageLeft.cancel();
    if(mode == VaultReEncryptionMode.Normal){

    await auth.signInWithEmailAndPassword(email: email,password: await hashVaultKey(password: masterKey,emailAddress: email)).then((_) async {
    await auth.currentUser.updatePassword(await hashVaultKey(password: newPassword,emailAddress: email));
    });
    await Future.wait([reEncryptPassword(passwords),reEncryptPayment(payments),reEncryptPassport(passports),reEncryptDocument(documents),reEncryptCertificate(certificates)]);
    }
    await auth.signInWithEmailAndPassword(email: email,password: await hashVaultKey(password: newPassword,emailAddress: email)).then((_) async {

    progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    await Permission.storage.request();
    //show the percentage by the number of files downloaded
    showReEncryptionPercent(context);
    await Future.wait([paymentAttachmentReEncrypt(payments,context),passportAttachmentReEncrypt(passports,context),documentAttachmentReEncrypt(documents,context),certificateAttachmentReEncrypt(certificates,context)])
    .then((_){ 
    Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email').deleteSync(recursive: true);
    Navigator.pop(context);
    signOut(context);
    });

    });

    }catch(e){
    print(e);
    Navigator.pop(context);
    signOut(context);
    showFlushBar(context,'An Error Occured',Icons.dangerous);
    }
    }


class VaultReEncryption{
  static String newVaultKey;
  static String masterKey;
  static initalize({String updatedVaultKey,String oldVaultKey}){
    newVaultKey = createEncryptionKey(updatedVaultKey);
    masterKey = createEncryptionKey(oldVaultKey);
  }
}

_getPasswordsFromFirestore(){
  return FirebaseFirestore.instance
        .collection(userUid)
        .doc(Collection.vault)
        .collection(Collection.passwords)
        .get()
        .then((snapshot) async {
          List<Passwords> decrypted = List<Passwords>();
          for(var password in snapshot.docs){
            dynamic stream = await decryptPasswordStream(password.data(),password.id);
            decrypted.add(stream);
          }
          return decrypted;
          });
}

_getPassportsFromFirestore(){
  return FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.passports)
        .get()
        .then((snapshot) async {
          List<Passports> decrypted = List<Passports>();
          for(var passport in snapshot.docs){
            dynamic stream = await decryptPassportStream(passport.data(),passport.id);
            decrypted.add(stream);
          }
          return decrypted;
          });
}
_getPaymentsFromFirestore(){
  return FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.payments)
        .get()
        .then((snapshot) async {
          List<Payments> decrypted = List<Payments>();
          for(var payment in snapshot.docs){
            dynamic stream = await decryptPaymentStream(payment.data(),payment.id);
            decrypted.add(stream);
          }
          return decrypted;
          });
}

_getdocumentsFromFirestore(){
  return FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.documents)
        .get()
        .then((snapshot) async {
          List<Document> decrypted = List<Document>();
          for(var document in snapshot.docs){
            dynamic stream = await decryptDocumentStream(document.data(),document.id);
            decrypted.add(stream);
          }
          return decrypted;
          });
}

_getCertificatesFromFirestore(){
  return FirebaseFirestore.instance
        .collection(userUid)
      .doc(Collection.vault)
        .collection(Collection.certificates)
        .get()
        .then((snapshot) async {
          List<Certificates> decrypted = List<Certificates>();
          for(var certificate in snapshot.docs){
            dynamic stream = await decryptCertificateStream(certificate.data(),certificate.id);
            decrypted.add(stream);
          }
          return decrypted;
          });
}
