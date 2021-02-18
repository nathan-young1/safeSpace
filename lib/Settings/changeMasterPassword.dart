import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Vault-Recryption/mainReEncryptionFunction.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class ChangeMasterPassword extends StatefulWidget {
  @override
  _ChangeMasterPasswordState createState() => _ChangeMasterPasswordState();
}

class _ChangeMasterPasswordState extends State<ChangeMasterPassword> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController formerPassword = TextEditingController();
  final reEncryptionFormKey = GlobalKey<FormState>();
  @override
    void dispose() {
      super.dispose();
      currentPassword.dispose();
      newPassword.dispose();
    }
  @override
  Widget build(BuildContext context) {
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
          title: Text(
          (!Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email').existsSync())
          ?'Change Vault Key'
          :'Continue ReEncryption',
          style: Theme.of(context).appBarTheme.textTheme.headline1)),
        body: (internetConnection)
        ?Padding(
          padding: const EdgeInsets.only(top: 30),
          child: (!Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email').existsSync())
          ?Form(
            key: reEncryptionFormKey,
            child: Column(children: [
              Container(
                width: 250,
                child: TextField(
                  controller: currentPassword,
                  decoration: textInputDecoration.copyWith(labelText: 'New Vault Key')),
              ),
              SizedBox(height: 6),
              Container(
                width: 250,
                child: TextField(
                  controller: newPassword,
                  decoration: textInputDecoration.copyWith(labelText: 'Retype Vault Key')),
              ),
                RaisedButton.icon(
                  onPressed: ()=>vaultReEncryption(masterKey: ModalRoute.of(context).settings.arguments,newPassword: newPassword.text,context: context),
                  label: Text('ReEncrypt Vault'),
                  icon: Icon(Icons.lock_clock),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info,size: 25,color: Colors.grey),
                        SizedBox(width: 8),
                        Flexible(child: Text('Do not interupt while changing Password',style: TextStyle(fontSize: 15),))
                      ],
                    ),
            ]),
          ):Column(children: [
            Container(
              width: 250,
              child: TextField(
                controller: formerPassword,
                decoration: textInputDecoration.copyWith(labelText: 'Former Vault Key')),
            ),
            SizedBox(height: 6),
            Container(
              width: 250,
              child: TextField(
                controller: newPassword,
                decoration: textInputDecoration.copyWith(labelText: 'Current Vault Key')),
            ),
              RaisedButton.icon(onPressed: () =>
                //make the masterkey the former password so it can decrypt the data to continue reEncryption
                vaultReEncryption(masterKey: formerPassword.text,newPassword: newPassword.text,context: context,mode: VaultReEncryptionMode.Resume),
                label: Text('Continue ReEncryption'),
                icon: Icon(Icons.lock_clock),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info,size: 25,color: Colors.grey),
                      SizedBox(width: 8),
                      Flexible(child: Text('Do not interupt while changing Password',style: TextStyle(fontSize: 15),))
                    ],
                  ),
          ]),
        ):NoInternetConnection(),
    );
  }
  } 