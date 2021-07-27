import 'dart:async';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Authentication/ui/login.dart';
import 'package:safeSpace/Certificates/ui/certificate.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Documents/ui/documents.dart';
import 'package:safeSpace/Passports/ui/passport.dart';
import 'package:safeSpace/Passwords/ui/password.dart';
import 'package:safeSpace/Payments/ui/payment.dart';
import 'package:safeSpace/Settings/settings.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:safeSpace/Subscription/ui/subscriptionStatus.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';


class SafeDrawer extends StatefulWidget {
  @override
  _SafeDrawerState createState() => _SafeDrawerState();
}
Timer? getStorageLeft;
class _SafeDrawerState extends State<SafeDrawer> {

  @override
    void initState() {

      getStorageLeft = Timer.periodic(Duration(seconds: 10),(_){
        user!.getIdTokenResult(true).then((token){
        VaultIdToken.setStorageLeft(token.claims!['storageLeft']);
      });
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    double width = 10;
    Dashboard child = Provider.of<Dashboard>(context);
    DrawerState size = Provider.of<DrawerState>(context);
    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.teal,
        body: Stack(
          children: [
           Positioned(
             top: context.safePercentHeight * 5,
             left: (context.isMobileTypeHandset)?context.safePercentWidth * 5: context.safePercentWidth * 8,
                child: Row(
                children: [
                  Image.asset('assets/images/SafeSpace.png',height: 50.h,width: 50.w,fit: BoxFit.contain,color: Colors.white),
                  SizedBox(width:7.w),
                  if(context.isMobileTypeHandset)Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(email!,style: TextStyle(color:color,fontSize: RFontSize.small)),
                      SizedBox(height: 5.h),
                      Text((!SafeSpaceSubscription.isPremiumUser)?'Trial Version':'Time Left: ${SafeSpaceSubscription.timeLeftToExpire()} days',style: TextStyle(color:color,fontSize: 16))
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
            top: context.screenHeight * 0.32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Container(
                     height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                     color: (child.dashboardChild.toString() == 'Password')? secondaryColor : Colors.transparent,
                     child: GestureDetector(
                        onTap: (){
                          child.change(Password());
                        size.closeDrawer();
                        },
                          child: Row(
                          children: [
                            Icon(MdiIcons.lock,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Passwords',style: navigationDrawer),
                          ],
                        ),
                     ),
                   ),
                    Container(
                      height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: (child.dashboardChild.toString() == 'Identity')? secondaryColor : Colors.transparent,
                      child: GestureDetector(
                        onTap: (){ child.change(Identity());
                        size.closeDrawer();
                        },
                          child: Row(
                          children: [
                            Icon(MdiIcons.cardAccountDetailsOutline,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Passports',style: navigationDrawer),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                       color: (child.dashboardChild.toString() == 'Payment')? secondaryColor : Colors.transparent,
                      child: GestureDetector(
                        onTap: (){child.change(Payment());
                        size.closeDrawer();
                        },
                          child: Row(
                          children: [
                            Icon(Icons.credit_card,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Payments',style: navigationDrawer),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: (child.dashboardChild.toString() == 'Documents')? secondaryColor : Colors.transparent,
                      child: GestureDetector(
                        onTap: (){ child.change(Documents());
                        size.closeDrawer();},
                          child: Row(
                          children: [
                            Icon(MdiIcons.fileDocument,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Documents',style: navigationDrawer),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: (child.dashboardChild.toString() == 'Certificate')? secondaryColor : Colors.transparent,
                      child: GestureDetector(
                        onTap: (){child.change(Certificate());
                        size.closeDrawer();},
                          child: Row(
                          children: [
                            Icon(MdiIcons.certificate,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Certificates',style: navigationDrawer),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: context.screenHeight/15,
                     width: context.screenWidth,
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: (child.dashboardChild.toString() == 'Setting')? secondaryColor : Colors.transparent,
                      child: GestureDetector(
                      onTap: (){child.change(Setting());
                      size.closeDrawer();},
                          child: Row(
                          children: [
                            Icon(Icons.settings,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Settings',style: navigationDrawer),
                          ],
                        ),
                  ),
                    ),
                ],
              ),
            ),
              Positioned(
                bottom: context.safePercentHeight * 5,
                left:context.safePercentWidth* 5,
                  child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                      size.closeDrawer();
                      signOut(context);
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                      },
                          child: Row(
                          children: [
                            Icon(Icons.logout,color: color,size: (context.isMobileTypeHandset)?25:20.w),SizedBox(width: width),
                            Text('Log out',style: navigationDrawer),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget currentDashboard = Password();
class Dashboard with ChangeNotifier{
Widget get dashboardChild => currentDashboard;
set dashboardChild(Widget page){
  currentDashboard = page;
  notifyListeners();
}
change(Widget page){
  dashboardChild = page;
}
}
class DrawerState with ChangeNotifier{
  bool isDrawerOpen = false;
  bool get drawerSlide => isDrawerOpen;
  set drawerSlide(bool state){
    isDrawerOpen = state;
    notifyListeners();
  }
openDrawer(){
drawerSlide = true;
}
closeDrawer(){
drawerSlide = false;
}
}
class AttachmentDownload with ChangeNotifier{
   double percent = 0.0;
   int currentFile = 0;
   
   int get currentFileIndex => currentFile;
   set currentFileIndex(int latestIndex){
    currentFile = latestIndex;
    notifyListeners();
  }
  double get currentPercent => percent;
  set currentPercent(double newPercent){
    percent = newPercent;
    notifyListeners();
  }
  update(double update){
    currentPercent = update;
  }
  updateIndex(int newIndex){
    currentFileIndex = newIndex;
  }
}
class SearchBar with ChangeNotifier{
  bool isSearching = false;
  bool get searching => isSearching;
  set searching(bool value){
    isSearching = value;
    notifyListeners();
  }
  updateSearchBar(bool update){
    searching = update;
  }
}