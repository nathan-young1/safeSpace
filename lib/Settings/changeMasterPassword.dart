import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Custom-widgets/passwordStrengthIndicator.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
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
  double passwordStrength = 0.0;
  Color passwordStrengthColor = Colors.transparent;

  bool _validateVaultKey(String value) {
    String pattern =  r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{8,}$';
    RegExp regExp = new RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(value);
  }
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
          leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
          title: Text('Vault ReEncryption',
          style: Theme.of(context).appBarTheme.textTheme.headline1)),
        body: (internetConnection)
        ?Padding(
          padding: const EdgeInsets.only(top: 30),
          child: (!Directory('${GetDirectories.pathToVaultFolder}/CheckList/$email').existsSync())
          ?Form(
            key: reEncryptionFormKey,
            child: Column(children: [
              Container(
                width: 270.w,
                child: TextFormField(
                  controller: currentPassword,
                  style: authTextField,
                  validator: (vaultKey){
                    if(vaultKey.isEmpty){
                      return 'Vault key is required';
                    }
                    else if(passwordStrength != 100){
                     return 'Vault key is weak';
                    }
                    return null;
                  },
                  onChanged: (value){
                  setState(() {
                    double strength = estimatePasswordStrength(value);
                    if (value.length == 0) {
                      passwordStrengthColor = Colors.transparent;
                      passwordStrength = 0.0;
                    } else if (strength <= 0.4 && strength > 0) {
                      passwordStrengthColor = Colors.red;
                      passwordStrength = 40.0;
                    } else if (strength <= 0.7 && strength > 0.4) {
                      passwordStrengthColor = Colors.yellow;
                      passwordStrength = 70.0;
                    } else if (strength <= 1 && strength > 0.7 && _validateVaultKey(value)) {
                      passwordStrengthColor = Colors.teal;
                      passwordStrength = 100.0;
                    }
                  });
                },
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    labelText: 'New Vault Key',
                    errorStyle: TextStyle(fontSize: RFontSize.normal),
                    labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black),
                    suffixIcon: PasswordStrengthIndicator(passwordStrength: passwordStrength, passwordStrengthColor: passwordStrengthColor))),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 270.w,
                child: TextFormField(
                  controller: newPassword,
                  style: authTextField,
                  validator: (retypedVaultKey){
                    if(retypedVaultKey.isEmpty || retypedVaultKey != currentPassword.text){
                      return 'Vault key do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    errorStyle: TextStyle(fontSize: RFontSize.normal),
                    labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black),
                    labelText: 'Retype Vault Key')),
              ),
              SizedBox(height: 25.h),
                Container(
                  height: 40.h,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    color: mainColor,
                    onPressed: ()=> (reEncryptionFormKey.currentState.validate())?vaultReEncryption(masterKey: ModalRoute.of(context).settings.arguments,newPassword: newPassword.text,context: context):null,
                    label: Text('ReEncrypt Vault',style: TextStyle(fontSize: RFontSize.normal,color: Colors.white)),
                    icon: Icon(Icons.lock_clock),),
                ),
                SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info,size: 28.r,color: secondaryColor),
                          SizedBox(width: 8.w),
                          Flexible(child: Text('This is a sensitive operation only proceed on a stable internet connection and do not interupt.',style: TextStyle(fontSize: RFontSize.normal),))
                        ],
                      ),
                  ),
            ]),
          ):ContinueReEncryption(formerPassword: formerPassword, newPassword: newPassword),
        ):NoInternetConnection(),
    );
  }
  }

class ContinueReEncryption extends StatelessWidget {
  const ContinueReEncryption({
    Key key,
    @required this.formerPassword,
    @required this.newPassword,
  }) : super(key: key);

  final TextEditingController formerPassword;
  final TextEditingController newPassword;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 270.w,
        child: TextField(
          style: authTextField,
          controller: formerPassword,
          decoration: InputDecoration(
              filled: true,
              isDense: true,
              errorStyle: TextStyle(fontSize: RFontSize.normal),
              labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black),
              labelText: 'Former Vault Key',
              suffixIcon: Tooltip(
                message: 'The Vault Key used to start encryption',
                child: Icon(MdiIcons.information,size: 26.r),
              ))),
      ),
      SizedBox(height: 10.h),
      Container(
        width: 270.w,
        child: TextField(
          controller: newPassword,
          style: authTextField,
          decoration: InputDecoration(
              filled: true,
              isDense: true,
              errorStyle: TextStyle(fontSize: RFontSize.normal),
              labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black),
              labelText: 'Current Vault Key',
              suffixIcon: Tooltip(
                message: 'The Current Vault Key',
                child: Icon(MdiIcons.information,size: 26.r),
              ))),
      ),
        SizedBox(height: 25.h),
        Container(
          height: 40.h,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            color: secondaryColor,
            onPressed: () =>
            //make the masterkey the former password so it can decrypt the data to continue reEncryption
            vaultReEncryption(masterKey: formerPassword.text,newPassword: newPassword.text,context: context,mode: VaultReEncryptionMode.Resume),
            label: Text('Continue ReEncryption',
            style: TextStyle(fontSize: RFontSize.normal,color: Colors.white)),
            icon: Icon(Icons.pause,size: 25.r),),
        ),
          SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info,size: 28.r,color: secondaryColor),
                    SizedBox(width: 8.w),
                    Flexible(child: Text('This is a sensitive operation only proceed on a stable internet connection and do not interupt.',style: TextStyle(fontSize: RFontSize.normal),))
                  ],
                ),
            ),
    ]);
  }
} 