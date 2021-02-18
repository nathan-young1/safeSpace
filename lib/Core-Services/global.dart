import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Custom-widgets/appBar.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'enum.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String masterkey;
String query = '';
//to tell the class when to update the widget based on the current search bar state
StreamSubscription searchBarState = searchBarStateController.stream.listen((_){});
List<File> attachments = List<File>();
double passwordLength = 30.0;
String generatedPassword;
RandomColor randomColor = RandomColor();
Color allColor = randomColor.randomColor();
Color mainColor = Colors.teal;
Color secondaryColor = Color.fromRGBO(254, 77, 145, 80);
BoxDecoration authenticationContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(15),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 1,
      offset: Offset(0, 0.4), // changes position of shadow
    ),
  ],
);
final InputDecoration textInputDecoration = InputDecoration(
  errorStyle: authTextField,
  isDense: true,
  labelStyle: TextStyle(color: Colors.black, fontSize: 17.ssp),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
);
final InputDecoration detailInputDecoration = InputDecoration(
  isDense: true,
  labelStyle: TextStyle(color: Colors.black, fontSize: 17.ssp),
  border: UnderlineInputBorder(borderRadius: BorderRadius.circular(15)),
);
final InputDecoration textInputDecorationForSafe = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  labelStyle:TextStyle(color: Colors.black, fontSize: 17.ssp),
);

showExitDialog(BuildContext context) {
  AlertDialog exit = new AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Row(
      children: [
        Image.asset(
          'assets/images/SafeSpace.png',
          height: 30.h,
          width: 40.w,
          color: mainColor,
        ),
        SizedBox(width: 5),
        SizedBox(
          child: Text(
            'Safe Space',
            style: TextStyle(
              fontSize: RFontSize.medium
            ),
          ),
        ),
      ]),
    content: Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
      Text('Do you want to sign out ?',
        style: TextStyle(fontSize: RFontSize.normal),
      ),
    ]),
    actions: [
      Padding(
        padding: EdgeInsets.fromLTRB(0,0,15.r,10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  signOut(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: RFontSize.normal),
                )),
            SizedBox(width: 20.w),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text('No', style: TextStyle(color: mainColor,fontWeight: FontWeight.bold,fontSize: RFontSize.normal)))
          ],
        ),
      )
    ],
  );
  showDialog(context: context, child: exit, barrierDismissible: true);
}

showConfirmFileDeleteDialog(BuildContext context,DeleteOption option) {
  AlertDialog exit = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Delete',style: TextStyle(color: Colors.black,fontSize: RFontSize.medium),
      textAlign: TextAlign.center,
      ),
      Divider(height: 15,color: Colors.grey,thickness: 2),
      (option == DeleteOption.file)?Text('Do you want to delete this file ?',style: popupStyle)
      :Text('Do you want to delete this document ?',style: popupStyle),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () => Navigator.pop(context,true),
              child: Text(
                'Yes',
                style: popupStyle.copyWith(color: mainColor,fontWeight: FontWeight.bold),
              )),
          SizedBox(width: 20),
          GestureDetector(
              onTap: () => Navigator.pop(context,false),
              child: Text('No', style: popupStyle.copyWith(color: mainColor,fontWeight: FontWeight.bold)))
        ],
      )
    ]),
  );
  return showDialog(context: context, child: exit, barrierDismissible: false);
}
showUploadDialog(BuildContext context, int filesLength) {
    AlertDialog downloadProgress = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        content: StatefulBuilder(builder: (context, StateSetter setState) {
          int index = Provider.of<AttachmentDownload>(context).currentFileIndex;
          double percent = double.parse(Provider.of<AttachmentDownload>(context)
              .percent
              .toString()
              .substring(0, 3));
          return Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  child: CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 5.0,
                percent: percent,
                center: new Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.teal,
              )),
              SizedBox(height: 6),
              Text('Uploading $index of $filesLength files',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop('Cancel');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: secondaryColor)),
                    SizedBox(width: 10),
                  ],
                ),
              )
            ]),
          );
        }));
    showDialog(context: context, child: downloadProgress, barrierDismissible: false);
  }

bool isDeviceConnected;
StreamSubscription subscription;
class InternetConnection with ChangeNotifier{
  bool get checkInternet => isDeviceConnected;
  set checkInternet(bool update){
    isDeviceConnected = update;
    notifyListeners();
  }
  update(bool update){
    checkInternet = update;
  }
}