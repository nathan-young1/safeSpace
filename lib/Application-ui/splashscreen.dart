import 'package:flutter/material.dart';
import 'dart:async';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  void initState() {
    super.initState();
    changeRouteTimer();
  }

  Future<bool> isUserFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserFirstTime = prefs.containsKey('isUserFirstTime') ? false : true;
    return isUserFirstTime;
  }

  changeRouteTimer() => Timer(Duration(seconds: 2), () async =>(await isUserFirstTime())?Navigator.pushReplacementNamed(context,'IntroPages'):Navigator.pushReplacementNamed(context,'Login'));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(null),
      child: Scaffold(
     body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/SafeSpace.png',
            height: 65.r,
            width: 60.r,
            color: mainColor,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 8.w),
          Text('Safe Space',style: Theme.of(context).textTheme.headline1
          ),
        ]),
      ],
    ),
        ),
    ));
  }
}