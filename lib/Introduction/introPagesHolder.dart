import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Introduction/encryptedVaultPage.dart';
import 'package:safeSpace/Introduction/instantlySync.dart';
import 'package:safeSpace/Introduction/mineSecurePasswordPage.dart';
import 'package:safeSpace/Introduction/vaultKeyPage.dart';
import 'package:safeSpace/Introduction/welcomePage.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPageHolder extends StatefulWidget {
  @override
  _IntroPageHolderState createState() => _IntroPageHolderState();
}

class _IntroPageHolderState extends State<IntroPageHolder> {
  //after all pages have shown set is first time to false
  PageController introPageController = PageController(initialPage: 0);
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(size: 30),
          toolbarHeight: 65.h,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,20.h,25.w,0),
            child: MaterialButton(
              minWidth: 80.w,
              color: secondaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isUserFirstTime',false);
            Navigator.pushReplacementNamed(context,'SignUp');
              },
              child: Text((pageIndex!=4)?'Skip':'Get Started',style: TextStyle(fontSize: RFontSize.medium,color: Colors.white))),
          )
        ]),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 50.h),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [  
                 pageIndicator(isActive: pageIndex==0,index: 0),
                 pageIndicator(isActive: pageIndex==1,index: 1),
                 pageIndicator(isActive: pageIndex==2,index: 2),
                 pageIndicator(isActive: pageIndex==3,index: 3),
                 pageIndicator(isActive: pageIndex==4,lastIndicator: true,index: 4),
                  ]),
        ),
        body: PageView(
          controller: introPageController,
          onPageChanged: (int currentIndex)=> setState(()=> pageIndex=currentIndex),
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

  Widget pageIndicator({bool isActive,bool lastIndicator = false,int index}) {

    return Padding(
      padding: EdgeInsets.only(right: (!lastIndicator)?10:0),
      child: GestureDetector(
        onTap: () => introPageController.animateToPage(
          index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut
        ),
        child: Container(
           height: 30.h,
           width: 20.w,
           decoration: BoxDecoration(
             color: (isActive)?mainColor:Colors.grey,
             shape: BoxShape.circle)),
      ),
    );
}
}
