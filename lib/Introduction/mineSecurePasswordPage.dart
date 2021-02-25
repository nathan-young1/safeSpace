import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';

class MinePasswordPage extends StatefulWidget {
  @override
  _MinePasswordPageState createState() => _MinePasswordPageState();
}

class _MinePasswordPageState extends State<MinePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 40,
          color: Colors.transparent,
          child: Image.asset(
            'assets/images/introductionPictures/mineSecurePasswords.jpg',
            height: 350.h,
            width: 230.w,
            fit: BoxFit.fill
          ),
        ),
        SizedBox(height: 25.h),
        Text('Password Miner',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: RFontSize.large
          )),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w,10.h,20.w,0),
          child: Text('Create secure passwords for your different accounts in seconds.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: RFontSize.normal
            )),
        )
      ],
    );
  }
}