import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'attachmentDialog.dart';

class AttachButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 36.h,
          child: RaisedButton.icon(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            color: secondaryColor,
            icon: Icon(Icons.collections,size: 22.r),
            label: Text('Attach',style: TextStyle(fontSize: RFontSize.small,color: Colors.black)),
            onPressed: () {
             if(SafeSpaceSubscription.isPremiumUser){
                  attachmentPicker(buildContext: context);
              }else{
                Navigator.of(context).pushNamed('UpgradePlan');
              }
          },
              ),
        ),
      ],
    );
  }
}