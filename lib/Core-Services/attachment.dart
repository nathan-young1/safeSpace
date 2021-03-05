import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Firebase-Services/cloud-storage.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'encrypt.dart';
import 'global.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

//Todo remeber to fix attachment to not upload if the user is not a premium user
bool taskCanceled = false;
class Attachment extends StatelessWidget {
  final String dbName;
  final String collection;
  final String docName;
  Attachment({Key key,this.collection, this.dbName, this.docName}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamProvider<List<String>>.value(
        value: FirestoreFileStorage.streamAttachmentList(collection: collection,dbName: dbName),
        catchError: (_, __) => null,
        builder: (context,_)=>  AttachmentBody(collection: collection,dbName: dbName,docName: docName)
      )
    );
  }
}

  

class GetDirectories{
  static Directory _externalDirectory;
  static final Directory systemTempDir = Directory.systemTemp;
  static String pathToVaultFolder;

  static initialize() async {
    _externalDirectory = await getExternalStorageDirectory();
    pathToVaultFolder = '${_externalDirectory.path}/vault';
  }
}

class AttachmentBody extends StatefulWidget {
  final String dbName;
  final String collection;
  final String docName;
  AttachmentBody({Key key,this.collection, this.dbName, this.docName}):super(key: key);
  @override
  _AttachmentBodyState createState() => _AttachmentBodyState();
}

class _AttachmentBodyState extends State<AttachmentBody> {

  List<File> attachments = List<File>();
  bool taskCanceled = false;

    openfile(String collection, String docName, String fileName) async {
    String fullPath ='${GetDirectories.pathToVaultFolder}/$collection/$docName';
    (File('$fullPath/$fileName').existsSync())
        ? OpenFile.open('$fullPath/$fileName')
        : await getFiles(collection: widget.collection,documentName: widget.docName,fileDir: fileName)
            .whenComplete(() {
            setState(() {});
            OpenFile.open('$fullPath/$fileName');
          });
  }

  @override
  Widget build(BuildContext context) {
    
    var fileAttachments = Provider.of<List<String>>(context);
    return Scaffold(
            appBar: AppBar(
              centerTitle: Theme.of(context).appBarTheme.centerTitle,
              leading: Padding(
              padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
              child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:18.w,color: Colors.black),
              onPressed: ()=> Navigator.of(context).pop()),
            ),
              title: Text('Attachments',style: Theme.of(context).appBarTheme.textTheme.headline1),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              actions: [
                Padding(
                  padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(0,0,8,0),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.black, size: (context.isMobileTypeTablet)?21.w:30),
                    onPressed: () =>  (SafeSpaceSubscription.isPremiumUser)
                    ?FirestoreFileStorage.uploadFileToFirestore(context: context,dbName: widget.dbName,
                    collection: widget.collection,checkIfExist: fileAttachments,commandFrom: UploadFileToFirestore.fromAttachment)
                    :Navigator.of(context).pushNamed('UpgradePlan')
                                              
                  ),
                )
              ],
            ),
            body: (fileAttachments != null)
                ? (fileAttachments.length != 0)?ListView.builder(
                    itemCount: fileAttachments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10.w,(context.isMobileTypeTablet)?15.h:5.h,6.w,6),
                        child: GestureDetector(
                          onTap: () async {
                              await openfile(widget.collection, widget.docName,fileAttachments[index]);
                            },
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                fileExists(collection: widget.collection,documentName: widget.docName,fileName: fileAttachments[index])
                                ? Icon(MdiIcons.fileCheck, size: 30.r, color: mainColor)
                                : Icon(MdiIcons.fileDownload, size: 31.r, color: mainColor),
                                SizedBox(width: 7.w),
                              Expanded(child: Text(fileAttachments[index],style: TextStyle(fontSize: RFontSize.normal))),
                              PopupMenuButton<Options>(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.more_vert,size: 28.r),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSelected: (Options result) async {
                                switch (result) {
                                  case Options.delete:
                                  if(await showConfirmFileDeleteDialog(context,DeleteOption.file)){
                                   progressDialog(buildContext: context,message: 'Deleting...',command: ProgressDialogVisiblity.show);
                                   await deleteFromFirestore(widget.collection,widget.dbName,fileAttachments[index]).then((_)=>
                                   progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide));
                                   }
                                  break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<Options>>[
                                PopupMenuItem<Options>(
                                  value: Options.delete,
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_sweep,size: 28.r, color: Colors.black54),
                                      SizedBox(width: 10.w),
                                      Text('Delete',style: TextStyle(fontSize: RFontSize.normal)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                              ], 
                          ),
                        ),
                      );
                    }):Center(child: Text('No Attachments',style: TextStyle(fontSize: RFontSize.normal)))
                : Container(child: Center(child: CircularProgressIndicator())),
              bottomSheet: (fileAttachments != null && fileAttachments.length != 0)
                ? GestureDetector(
                    onTap: () async {
                      await getFiles(collection: widget.collection,documentName: widget.docName,fileDir: fileAttachments);
                    },
                    child: Container(
                      height: 50.h,
                      color: Colors.teal,
                      child: Center(
                          child: Text('Download All',
                        style: TextStyle(color: Colors.white, fontSize: RFontSize.medium),
                      )),
                    ),
                  )
                : Container(height: 50),
    );
  }
  Future getFiles({String collection, String documentName, dynamic fileDir}) async {
    FirestoreFileStorage.downloadFilesFromFirestore(dbName: widget.dbName,attachmentNames: fileDir,collection: collection,documentName: documentName, context: context);
  }


  Future deleteFromFirestore(String collection, String docName, String fileName) async {
    List<int> dbName = (await encrypt(fileName)).toString().codeUnits;
    await FirebaseStorage.instance
        .ref()
        .child(userUid)
        .child(Collection.vault)
        .child(collection)
        .child(docName)
        .child('$dbName')
        .delete();
  }

}
//Todo revisit here
showTaskDialog(BuildContext context, int filesLength,TaskDialog type) {
    AlertDialog downloadProgress = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 10.w, right: 10.w),
        content: StatefulBuilder(builder: (_, StateSetter setState) {
          int index = Provider.of<AttachmentDownload>(context).currentFileIndex;
          double percent = double.parse(Provider.of<AttachmentDownload>(context)
              .percent
              .toString()
              .substring(0, 3));
          return Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  child: CircularPercentIndicator(
                radius: 70.0.r,
                lineWidth: 5.0.r,
                percent: percent,
                center: new Text(
                  '${(percent * 100).toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.normal),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.teal,
              )),
              SizedBox(height: 6.h),
              (type == TaskDialog.download)?Text('Downloading $index of $filesLength files',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.normal))
              :Text('Uploading $index of $filesLength files',
                  style:TextStyle(fontWeight: FontWeight.bold, fontSize: RFontSize.normal)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: (){
                  setState((){ 
                    taskCanceled = true;
                    cancelUploadOrDownload.add(null);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: RFontSize.normal,
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

    bool fileExists({String collection, String documentName, String fileName}){
    String fullPath = '${GetDirectories.pathToVaultFolder}/$collection/$documentName';
    return (File('$fullPath/$fileName').existsSync());
  }
