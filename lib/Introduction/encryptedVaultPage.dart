import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';

class EncryptedVaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          child:  Image.asset(
          'assets/images/introductionPictures/encryptedVault.png',
          height: 200.h,
          width: 250.w,
          color: mainColor,
          fit: BoxFit.contain
        ),
        shaderCallback: (Rect bounds){
          return LinearGradient(
            colors: [mainColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        .createShader(bounds);
        },
        blendMode: BlendMode.srcATop),
        Text('Data Encryption',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: RFontSize.large
          )),
        Padding(
         padding: EdgeInsets.fromLTRB(20.w,10.h,20.w,0),
          child: Text('Your vault is encrypted using AES (Advanced Encryption Standard) 256 bits.',
          textAlign: TextAlign.justify,
          style: TextStyle(
          fontSize: RFontSize.normal
          )),
        )
      ],
    );
  }
}