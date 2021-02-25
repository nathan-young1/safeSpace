import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Introduction/encryptedVaultPage.dart';
import 'package:safeSpace/Introduction/instantlySync.dart';
import 'package:safeSpace/Introduction/mineSecurePasswordPage.dart';
import 'package:safeSpace/Introduction/vaultKeyPage.dart';
import 'package:safeSpace/Introduction/welcomePage.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class IntroPageHolder extends StatefulWidget {
  @override
  _IntroPageHolderState createState() => _IntroPageHolderState();
}

class _IntroPageHolderState extends State<IntroPageHolder> {
  //after all pages have shown set is first time to false
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight+10.h,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,30.r,30.w,0),
            child: Text('Skip',style: TextStyle(fontSize: RFontSize.medium,color: secondaryColor),),
          )
        ]),
        persistentFooterButtons: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Next',style: TextStyle(fontSize: RFontSize.medium),),
        )],
        body: PageView(
          children: [
            WelcomePage(),
            VaultKeyPage(),
            InstantSyncPage(),
            MinePasswordPage(),
            EncryptedVaultPage(),
          ],
          ),
      ),
    );
  }
}