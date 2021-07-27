import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

//Todo check the tap to add text and make reencryption percent responsive
showReEncryptionPercent(BuildContext context) {
    AlertDialog downloadProgress = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        content: StatefulBuilder(
          builder: (context,StateSetter setState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              child: CircularPercentIndicator(
              radius: 70.r,
              lineWidth: 5.r,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.teal,
            )),
            SizedBox(height: 6.h),
            Text('ReEncrypting Vault',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.medium))
          ]);}
        ),);
    showDialog(builder: (context) => downloadProgress, context: context, barrierDismissible: false);
}