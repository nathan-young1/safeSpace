import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';

class InstantSyncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 40.r,
          color: Colors.transparent,
          child: Image.asset(
            'assets/images/introductionPictures/instantSync.png',
            height: 350.h,
            width: 230.w,
            fit: BoxFit.fill
          ),
        ),
        SizedBox(height: 25.h),
        Text('Device Synchronization',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: RFontSize.large
          )),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w,10.h,20.w,0),
          child: Text('Data is instantly synced across all your authorized devices.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: RFontSize.normal
            )),
        )
      ],
    );
  }
}