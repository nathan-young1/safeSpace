import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class ReEncryptionPercent extends ChangeNotifier{
  int _numberOfTimesCalled;
  int _totalNumberOfFiles;
  int _numberOfFilesDownloaded;
  bool showProgressDialog;
  double get percent => (showProgressDialog)?(_numberOfFilesDownloaded/_totalNumberOfFiles):0.0;
  totalNumberOfFiles(int numberOfFilesInSection){
    _totalNumberOfFiles +=numberOfFilesInSection;
    _numberOfTimesCalled++;
    print('$_numberOfTimesCalled timesCalled');
    if(_numberOfTimesCalled == 4){
      showProgressDialog = true;
    }
  }
  updateNumberOfFilesDownloaded(){
    _numberOfFilesDownloaded++;
    notifyListeners();
  }
  intialize(){
    _numberOfFilesDownloaded = 0;
    _numberOfTimesCalled = 0;
    showProgressDialog = false;
    _totalNumberOfFiles = 0;
  }
}
//Todo check the tap to add text and make reencryption percent responsive
showReEncryptionPercent(BuildContext context) {
    AlertDialog downloadProgress = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        content: StatefulBuilder(
          builder: (context,StateSetter setState) {
          double percentage = Provider.of<ReEncryptionPercent>(context).percent;
          print('i am failing because of ${(percentage * 100).toInt()}');
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              child: CircularPercentIndicator(
              radius: 70.r,
              lineWidth: 5.r,
              percent: percentage,
              center: Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.normal),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.teal,
            )),
            SizedBox(height: 6.h),
            Text('ReEncrypting Vault',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.medium))
          ]);}
        ),);
    showDialog(context: context, child: downloadProgress, barrierDismissible: false);
}