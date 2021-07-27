import 'package:flutter/material.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/userEncryptionTools.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';

vaultReEncryption({required String newPassword,required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    progressDialog(buildContext: context,message: 'ReEncrypting Vault',command: ProgressDialogVisiblity.show);
    UserEncryptionTools.reEncryptUserEncryptionKeyForOnlineStorage(newPassword: newPassword);
   
  try{
    //stop the getting of storage token during reEncryption
    getStorageLeft!.cancel();

    await auth.signInWithEmailAndPassword(email: email!,password: await hashVaultKey(password: UserEncryptionTools.passwordToEncryptEncryptionKey,emailAddress: email!)).then((_) async {
    await auth.currentUser!.updatePassword(await hashVaultKey(password: newPassword,emailAddress: email!));
    });
    await auth.signInWithEmailAndPassword(email: email!,password: await hashVaultKey(password: newPassword,emailAddress: email!)).then((_) async {

    progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    Navigator.pop(context);
    signOut(context);

    });

    }catch(e){
      Navigator.pop(context);
      showFlushBar(context,'An Error Occured',Icons.dangerous);
    }
    }