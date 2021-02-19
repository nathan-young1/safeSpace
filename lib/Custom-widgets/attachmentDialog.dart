import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/filePicker.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

    attachmentPicker({@required BuildContext buildContext}) async {
    FocusScope.of(buildContext).unfocus();
    AlertDialog dialog = AlertDialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
    contentPadding: EdgeInsets.only(top: 10.0),
    content: StatefulBuilder(
    builder: (context, StateSetter setState) => SingleChildScrollView(
    child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            SizedBox(width: 6),
            IconButton(
                icon: Icon(Icons.arrow_back_ios,size: 28.r),
                onPressed: () =>Navigator.of(context).pop()),
                SizedBox(width: 3),
                Text('Attachments',style: dialogTitle),
                new Spacer(),
                IconButton(
                    icon: Icon(Icons.add,size: 30.r),
                    onPressed: () async {
                      await progressDialog(buildContext:context,message:'Please Wait....',command: ProgressDialogVisiblity.show);
                      attachments.addAll(await filePicker());
                      progressDialog(buildContext:context,command:ProgressDialogVisiblity.hide);
                      setState(() {});
                    }),
                        ]),
                SizedBox(height: 10.h),
                (attachments.isEmpty)
                  ?StatefulBuilder(
                    builder: (context, StateSetter setState) => Container(
                    height: 300.h,
                    width: 300.w,
                    child: Center(child: Text('Add files',style: TextStyle(fontSize: RFontSize.normal))),
                  ))
              :StatefulBuilder(
              builder: (context, StateSetter setState) => Container(
              height: 300.h,
              width: 300.w,
              child: ListView(
                children: attachments.map((attachment)=> 
                Container(
                  color: Colors.grey[250],
                  child: ListTile(
                    title: Text(attachment.path.toString().split('/').last,
                    style: TextStyle(fontSize: RFontSize.normal)),
                    trailing: IconButton(
                        icon: Icon(Icons.close,size: 28.r),
                        onPressed: () {
                          setState(() {
                            attachments.remove(attachment);
                          });
                        }),
                  ),
                )
                ).toList(),
                ),
                )),
                        InkWell(
                          onTap: (){
                          Navigator.of(context).pop();
                          return attachments;
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text(
                              "Ok",
                              style: TextStyle(fontSize: RFontSize.medium,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                )));
    showDialog(context: buildContext, child: dialog, barrierDismissible: false);
  }