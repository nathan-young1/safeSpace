import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Agreement/privacyPolicy.dart';
import 'package:safeSpace/Agreement/termsOfService.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Introduction/introPagesHolder.dart';
import 'package:safeSpace/Styles/theme.dart';
import 'package:safeSpace/Subscription/ui/purchaseSubscription.dart';
import 'package:safeSpace/Vault-Recryption/reEncryptionPercent.dart';
import 'Application-ui/homePage.dart';
import 'Application-ui/navigationDrawer.dart';
import 'Application-ui/splashscreen.dart';
import 'Authentication/ui/login.dart';
import 'Authentication/ui/signup.dart';
import 'Core-Services/applicationInfo.dart';
import 'Core-Services/global.dart';
import 'Settings/changeMasterPassword.dart';
import 'Settings/manageAccount.dart';
import 'Subscription/ui/subscriptionStatus.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(Safe());
}

class Safe extends StatefulWidget {
  @override
  _SafeState createState() => _SafeState();
}

class _SafeState extends State<Safe> {
  bool _initialized = false;
  bool _error = false;
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    await ApplicationInfo.intialize();
    await GetDirectories.initialize();
    await Permission.storage.request();
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      print('an error occured');
    }
    if (!_initialized) {
      print('loading');
    }
    return LayoutBuilder(
      builder: (_, constraints) {
        ScreenUtil.init(constraints);
        return ScreenUtilInit(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<Dashboard>.value(value: Dashboard()),
                  ChangeNotifierProvider<DrawerState>.value(value: DrawerState()),
                  ChangeNotifierProvider<AttachmentDownload>.value(value: AttachmentDownload()),
                  ChangeNotifierProvider<SearchBar>.value(value: SearchBar()),
                  ChangeNotifierProvider<InternetConnection>.value(value: InternetConnection()),
                  ChangeNotifierProvider<ReEncryptionPercent>.value(value: ReEncryptionPercent())
                ],
                child: MaterialApp(
                  title: 'Safe Space',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    appBarTheme: appBarTheme,
                    textTheme: textTheme,
                    primarySwatch: Colors.teal,
                    accentColor: Colors.pinkAccent[100],
                    primaryColor: Colors.teal,
                    cursorColor: Colors.pinkAccent[100],
                  ),
                  routes: {
                    '/': (context)=> Splashscreen(),
                    'IntroPages': (context)=> IntroPageHolder(),
                    'Login': (context) => Login(),
                    'SignUp': (context) => Signup(),
                    'SafeDrawer': (context) => SafeHome(),
                    'ManageAccount': (context) => ManageAccount(),
                    'ChangeMasterPassword': (context) => ChangeMasterPassword(),
                    'SubscriptionStatus': (context) => Subscription(),
                    'UpgradePlan': (context) => PurchaseSubscription(),
                    'TermsOfService': (context) => TermsOfService(),
                    'PrivacyPolicy': (context) => PrivacyPolicy()
                  },
                ),
              ),
        );
      }
    );
  }
}
