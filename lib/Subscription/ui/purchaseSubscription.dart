import 'dart:async';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';

//listener to update subscription state
final StreamSubscription listener = updateState.stream.listen((_){});

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(MdiIcons.asterisk,size: 25.r),
    );
  }
}

class PurchaseSubscription extends StatefulWidget {
  @override
  _PurchaseSubscriptionState createState() => _PurchaseSubscriptionState();
}

class _PurchaseSubscriptionState extends State<PurchaseSubscription> {

  @override
    void initState() {
      super.initState();
      listener.onData((_) => setState(() {print('i have updated');}));
    }

    @override
      void dispose() {
        super.dispose();
        print('i am being disposed');
      }
  @override
  Widget build(BuildContext context) {
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    Widget durationWidget = Padding(
      padding: EdgeInsets.only(right: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
      children:[
        Text('Duration:',style: TextStyle(fontSize: RFontSize.normal,fontWeight: FontWeight.bold),),
        SizedBox(width: 6),
        Text('One Year',style: TextStyle(fontSize:  RFontSize.normal))
        ]));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
          title: Text('Get Premium',style: Theme.of(context).appBarTheme.textTheme.headline1),
        ),
        body: (internetConnection)?Container(
          child: Column(
            children: [
              SizedBox(height: 20.h),
            Text('Features', style: Theme.of(context).appBarTheme.textTheme.headline1.copyWith(fontSize: RFontSize.medium)),
            // ListTile(
            //   leading: MyBullet(),
            //   title: Text('Biometric Authentication', style: TextStyle(fontSize: RFontSize.normal)),
            // ),
            ListTile(
              leading: MyBullet(),
              title: Text('2Gb Encrypted Storage', style: TextStyle(fontSize: RFontSize.normal)),
            ),
            ListTile(
              leading: MyBullet(),
              title: Text('Sync Across All Devices', style: TextStyle(fontSize: RFontSize.normal)),
            ),
            ListTile(
              leading: MyBullet(),
              title: Text('Store Unlimited Credentials', style: TextStyle(fontSize: RFontSize.normal)),
            ),
            SizedBox(height: 17.h),
            durationWidget,
            SizedBox(height: 25.h),
            Container(
              height: 40.h,
              child: (!SafeSpaceSubscription.isPremiumUser)?RaisedButton.icon(onPressed: (){
                SafeSpaceSubscription.buyProduct();
              }, 
              icon: Icon(MdiIcons.creditCardOutline,color: Colors.white,size: 25.r),
               label: Text('Get Plan', style: TextStyle(fontSize: RFontSize.normal)),
               color: mainColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10)
               ),):RaisedButton.icon(onPressed: null, 
              icon: Icon(MdiIcons.creditCardCheck,color: Colors.white,size: 25.r),
               label: Text('Purchased', style: TextStyle(fontSize: RFontSize.normal)),
               color: mainColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10)
               ),),
            )
            ],
          )
        ):NoInternetConnection(),
      ),
    );
  }
}