import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/userEncryptionTools.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/textStyle.dart';
//import 'package:velocity_x/velocity_x.dart';

authenticateVaultKeyBeforeReEncryption({required BuildContext context}){
  final _authBeforeReEncryptionKey = GlobalKey<FormState>();
  TextEditingController enterVaultKey = TextEditingController();
  bool obscureText = true;
  GestureDetector backButton = GestureDetector(
                   onTap:()=> Navigator.of(context).pop(),
                   child: Text('Back',
                   style: TextStyle(
                   fontSize: RFontSize.medium,
                   fontWeight: FontWeight.bold,
                   )));
  Container continueButton = Container(
      height: 40.h,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        color: mainColor,
        child: Text('Continue',
        style: TextStyle(fontSize: RFontSize.medium,color: Colors.white)),
        onPressed: (){
          if(_authBeforeReEncryptionKey.currentState!.validate()){
          //first remove the alert dialog before going to another page
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('ChangeMasterPassword',arguments: enterVaultKey.text);}
        },
      ),
    );
  showDialog(
    builder: (context) => AlertDialog(
      title: Text('Please enter your vault key to continue:',
         style: TextStyle(fontSize: RFontSize.large,fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
     content: Padding(
       padding: EdgeInsets.all(8.r),
       child: StatefulBuilder(
         builder: (context,_setState) =>Form(
           key: _authBeforeReEncryptionKey,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
             Container(
               width: 350.w,
               child: TextFormField(
                 controller: enterVaultKey,
                 style: authTextField,
                 autofocus: true,
                 obscureText: obscureText,
                 validator: (text){
                   if(text!.isEmpty){
                     return 'Vault Key is required';
                   }else if(increasePasswordLengthTo32(text) == UserEncryptionTools.passwordToEncryptEncryptionKey){
                     return null;
                   }else{
                   return 'Invaild Vault Key';
                   }
                 },
                 onFieldSubmitted: (_){
                   if(_authBeforeReEncryptionKey.currentState!.validate()){
                    //first remove the alert dialog before going to another page
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('ChangeMasterPassword',arguments: enterVaultKey.text);}
                 },
                 decoration: InputDecoration(
                   isDense: true,
                   filled: true,
                   errorStyle: TextStyle(fontSize: RFontSize.normal),
                   labelText: 'Vault Key',
                   labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black54),
                   prefixIcon: IconButton(
                     icon: Icon(
                     (obscureText)
                     ?Icons.lock
                     :Icons.lock_open,
                     size: 28.r,
                     color: Colors.black54),
                     onPressed: ()=> _setState(()=>obscureText =! obscureText),
                   )
                 ),
               ))
           ],),
         ),
       ),
     ),
     actions: [ 
      Padding(
        padding: EdgeInsets.all(10.r),
        child: Row(children: [
        backButton,
        SizedBox(width: 20.w),
        continueButton
        ],),
      )
     ],
 ), context: context,
    barrierDismissible: false,
  );
}

authenticateVaultKeyBeforeUserDelete({required BuildContext context}){
  final _authBeforeUserDelete = GlobalKey<FormState>();
  TextEditingController enterVaultKey = TextEditingController();
  bool obscureText = true;
  GestureDetector backButton = GestureDetector(
                   onTap:()=> Navigator.of(context).pop(),
                   child: Text('Back',
                   style: TextStyle(
                   fontSize: RFontSize.medium,
                   fontWeight: FontWeight.bold,
                   )));
  Container continueButton = Container(
      height: 40.h,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        color: mainColor,
        child: Text('Continue',
        style: TextStyle(fontSize: RFontSize.medium,color: Colors.white)),
        onPressed: () async {
          if(_authBeforeUserDelete.currentState!.validate()){
                     Navigator.of(context).pop();
                    progressDialog(buildContext: context,message: 'Deleting User...',command: ProgressDialogVisiblity.show);
                    try {
                    await auth.signInWithEmailAndPassword(email: email!,password: await hashVaultKey(password: enterVaultKey.text,emailAddress: email!)).then((_) async {
                    await user!.delete().then((_){
                    progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
                    signOut(context);
                      });
                      });
                    } on Exception catch (e) {
                      print(e);
                      Navigator.of(context).pop();
                      showFlushBar(context,'An error occurred',Icons.error);
                    }
                    }
        },
      ),
    );
  showDialog(
    builder: (context) => AlertDialog(
      title: Text('Please enter your vault key to continue:',
         style: TextStyle(fontSize: RFontSize.large,fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
     content: Padding(
       padding: EdgeInsets.all(8.r),
       child: StatefulBuilder(
         builder: (context,_setState) =>Form(
           key: _authBeforeUserDelete,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
             Container(
               width: 350.w,
               child: TextFormField(
                 controller: enterVaultKey,
                 style: authTextField,
                 autofocus: true,
                 obscureText: obscureText,
                 validator: (text){
                   if(text!.isEmpty){
                     return 'Vault Key is required';
                   }else if(increasePasswordLengthTo32(text) == UserEncryptionTools.passwordToEncryptEncryptionKey){
                     return null;
                   }else{
                   return 'Invaild Vault Key';
                   }
                 },
                 onFieldSubmitted: (_) async {
                   if(_authBeforeUserDelete.currentState!.validate()){
                     Navigator.of(context).pop();
                    progressDialog(buildContext: context,message: 'Deleting User...',command: ProgressDialogVisiblity.show);
                    try {
                      await auth.signInWithEmailAndPassword(email: email!,password: await hashVaultKey(password: enterVaultKey.text,emailAddress: email!)).then((_) async {
                      await user!.delete().then((_){
                    progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
                    signOut(context);
                      });
                      });
                    } on Exception catch (e) {
                      progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
                      showFlushBar(context,'An error occurred',Icons.error);
                    }
                    }
                 },
                 decoration: InputDecoration(
                   isDense: true,
                   filled: true,
                   errorStyle: TextStyle(fontSize: RFontSize.normal),
                   labelText: 'Vault Key',
                   labelStyle: TextStyle(fontSize: RFontSize.normal,color: Colors.black54),
                   prefixIcon: IconButton(
                     icon: Icon(
                     (obscureText)
                     ?Icons.lock
                     :Icons.lock_open,
                     size: 28.r,
                     color: Colors.black54),
                     onPressed: ()=> _setState(()=>obscureText =! obscureText),
                   )
                 ),
               ))
           ],),
         ),
       ),
     ),
     actions: [ 
      Padding(
        padding: EdgeInsets.all(10.r),
        child: Row(children: [
        backButton,
        SizedBox(width: 20.w),
        continueButton
        ],),
      )
     ],
 ), context: context,
    barrierDismissible: false,
  );
}