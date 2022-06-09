import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {

   Timer? timer;
  @override
    void initState() {
      super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) { 
          timer = Timer.periodic(Duration(milliseconds: 30),(_) => setState((){}));
       });
    }
    @override
      void dispose() {
        super.dispose();
        timer!.cancel();
      }

  @override
  Widget build(BuildContext context) {
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    const int $nbsp = 0x00A0;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
        title: Text('Subscription Status',style: Theme.of(context).appBarTheme.textTheme!.headline1),
      ),
      body: (internetConnection)?Column(
        children: [
          SizedBox(height: 30.h),
          FlutterAnalogClock(
            height: 150.h,
            width: 150.w,
            borderColor: mainColor,
            minuteHandColor: secondaryColor,
            hourHandColor: secondaryColor,
            secondHandColor: secondaryColor,
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w,0,20.w,0),
            child: Column(children: [
            Row(
              children: [
                Flexible(child: Text('Email:${String.fromCharCode($nbsp)}$email',style: TextStyle(fontSize: RFontSize.normal))),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
            children: [
              Text((!SafeSpaceSubscription.isPremiumUser)?'Status: Trial Version':'Status: Premium Version',
              style: TextStyle(fontSize: RFontSize.normal)),
            ],
            ),
            SizedBox(height: 5.h),
            if(SafeSpaceSubscription.isPremiumUser)
            Row(
              children: [
                Text('Storage Left: ${VaultIdToken.currentStorageLeft} MegaBytes',style: TextStyle(fontSize: RFontSize.normal)),
              ],
            ),
            SizedBox(height: 5.h),
            if(SafeSpaceSubscription.isPremiumUser)
            Row(
              children: [
                Text('Time Left: ${SafeSpaceSubscription.timeLeftToExpire()} days',style: TextStyle(fontSize: RFontSize.normal)),
              ],
            ),
            ],),
          ),
        ],
      ):NoInternetConnection(),
    );
  }
}


class VaultIdToken{
  static int? _storageLeft;
  static int get currentStorageLeft => _storageLeft!;
  static setStorageLeft(var spaceLeft){
    //i am divide it so as to convert it to megabytes
    _storageLeft = (spaceLeft as int)~/1048576;
  }
}