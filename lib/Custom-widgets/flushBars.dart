import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Styles/fontSize.dart';

showCopiedFlushBar(context) {
  Flushbar(
    maxWidth: 180.r,
    borderRadius: 15.r,
    margin: EdgeInsets.all(15.r),
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: Duration(seconds: 1),
    isDismissible: false,
    messageText: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: secondaryColor,
            size: 27.r
          ),
          SizedBox(width: 6.w),
          Text('Copied',
              style: TextStyle(
                  color: mainColor, fontSize:RFontSize.normal)),
        ],
      ),
    ),
    barBlur: 20,
  )..show(context);
}


showAttachmentFlushBar(context, message) {
  Flushbar(
    maxWidth: 300,
    borderRadius: 15,
    margin: EdgeInsets.all(30.0),
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: Duration(seconds: 1),
    backgroundColor: Colors.white,
    isDismissible: false,
    messageText: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.attach_file,
            color: secondaryColor,
          ),
          SizedBox(width: 6),
          Text(message,
              style: TextStyle(
                  color: mainColor, fontSize: RFontSize.normal)),
        ],
      ),
    ),
    barBlur: 20,
  )..show(context);
}

showFileAlreadyExistFlushBar(context,String fileName) async {
  progressDialog(buildContext: context,message: '$fileName already exists ',command: ProgressDialogVisiblity.show,fileAlreadyExists: true);
  await Future.delayed(Duration(seconds: 1),((){}));
  progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
}

showFlushBar(context, message, icon) {
    Flushbar(
      maxWidth: 800.w,
      borderRadius: 15.r,
      margin: EdgeInsets.all(30.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 1),
      isDismissible: false,
      messageText: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon( icon,color: secondaryColor, size: 18.w),
            SizedBox(width: 6.w),
            Text( message,
              style: TextStyle(
                color: mainColor,
                fontSize: RFontSize.normal
              ),
            ),
          ],
        ),
      ),
      barBlur: 20,
    )..show(context);
  }
//enum to show copied in password dart ui file
enum PasswordCopiedType{Username,Password}
  passwordFlushBar({BuildContext context,PasswordCopiedType type}){
    Flushbar(
      maxWidth: 230.r,
      borderRadius: 15.r,
      margin: EdgeInsets.all(15.r),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 1),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (type == PasswordCopiedType.Password)
          ?Icon(Icons.lock,color: secondaryColor, size: 27.r)
          :Icon(Icons.person,color: secondaryColor, size: 27.r),
          Text((type == PasswordCopiedType.Password)
          ?'Password Copied'
          :'Username Copied',
          style: TextStyle(fontSize: RFontSize.normal,color: mainColor)),
        ],
      ),
      barBlur: 20,
    )..show(context);
  }