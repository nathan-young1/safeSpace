import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

progressDialog({@required BuildContext buildContext, String message = '', @required ProgressDialogVisiblity command}) {
  final ProgressDialog dialog = ProgressDialog(buildContext, isDismissible: false);
  dialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Transform.scale(
      scale: 0.7,
      child: CircularProgressIndicator(backgroundColor: mainColor)),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(color: mainColor, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: popupStyle);
      switch (command) {
        case ProgressDialogVisiblity.show:
          dialog.show();
          break;
        case ProgressDialogVisiblity.hide:
          dialog.hide();
          break;
      }
}