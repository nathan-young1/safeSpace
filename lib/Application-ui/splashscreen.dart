import 'package:flutter/material.dart';
import 'dart:async';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  void initState() {
    super.initState();
    changeRouteTimer();
  }

  changeRouteTimer() => Timer(Duration(seconds: 1), () => Navigator.pushReplacementNamed(context,'Login'));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
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