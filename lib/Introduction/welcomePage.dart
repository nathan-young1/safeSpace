import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/SafeSpace.png',
          height: 150.h,
          width: 200.w,
          fit: BoxFit.contain
        ),
        SizedBox(height: 20.h),
        Text('Safe Space',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: RFontSize.large
          )),
        SizedBox(height: 5.h),
        Text('Your Password Manager',
        style: TextStyle(
          fontSize: RFontSize.normal
          ))
      ],
    );
  }
}