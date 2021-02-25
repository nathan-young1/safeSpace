import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';

class VaultKeyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
          child: Image.asset('assets/images/introductionPictures/vaultKey.png',
          height: 200.h,
          width: 300.w,
          color: secondaryColor,
          fit: BoxFit.contain),
          shaderCallback: (Rect bounds){
            return LinearGradient(
              colors: [mainColor,secondaryColor])
            .createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
        ),
        SizedBox(height: 30.h),
        Text('Vault Key',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: RFontSize.large
          )),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w,10.h,20.w,0),
          child: Text('Your Vault key (Master Password) is used to authenticate you, and encrypt your data. Store it securely.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: RFontSize.normal
            )),
        )
      ],
    );
  }
}