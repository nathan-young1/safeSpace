import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/filePicker.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Styles/textStyle.dart';

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
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () =>Navigator.of(context).pop()),
                SizedBox(width: 3),
                Text('Attachments',style: dialogTitle),
                new Spacer(),
                IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 32,
                    onPressed: () async {
                      await progressDialog(buildContext:context,message:'Please Wait....',command: ProgressDialogVisiblity.show);
                      attachments.addAll(await filePicker());
                      progressDialog(buildContext:context,command:ProgressDialogVisiblity.hide);
                      setState(() {});
                    }),
                        ]),
                        SizedBox(height: 8),
                        (attachments.isEmpty)
                        ?StatefulBuilder(
                    builder: (context, StateSetter setState) => Container(
                    height: 300,
                    width: 300,
                    child: Center(child: Text('Add files')),
                  ))
              :StatefulBuilder(
              builder: (context, StateSetter setState) => Container(
              height: 300,
              width: 300,
              child: ListView(
                children: attachments.map((attachment)=> 
                Container(
                  color: Colors.grey[250],
                  child: ListTile(
                    title: Text(
                        attachment.path.toString().split('/').last),
                    trailing: IconButton(
                        icon: Icon(Icons.close),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            return attachments;
                          },
                          child: SizedBox(
                            height: 50,
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.only(top: 10.0),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(32.0),
                                      bottomRight: Radius.circular(32.0)),
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontFamily: 'style',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                )));
    showDialog(context: buildContext, child: dialog, barrierDismissible: false);
  }