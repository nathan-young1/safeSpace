import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/appBar.dart';
import 'package:safeSpace/Custom-widgets/attachButton.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Documents/code/documentDetails.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';

class Documents extends StatefulWidget {
  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  TextEditingController nameOfDocument = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController searchBar = TextEditingController();
  final nameOfDocumentFocus = FocusNode();
  final noteFocus = FocusNode();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //set state when search Bar contents changes
      searchBarState.onData((_) => setState(() {}));
    }

  @override
    void dispose() {
      super.dispose();
      nameOfDocument.dispose();
      note.dispose();
      nameOfDocumentFocus.dispose();
      noteFocus.dispose();
    }
  @override
  Widget build(BuildContext context) {
    SearchBar isSearching = Provider.of<SearchBar>(context);
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(collection: Collection.documents)),
          body: (internetConnection)?ListPage():NoInternetConnection(),
          floatingActionButton: (!isSearching.searching && internetConnection)
              ? InkWell(
                  onTap: () {
                  if(Provider.of<List<Document>>(context,listen: false).length == 5){
                  (SafeSpaceSubscription.isPremiumUser)
                  ?documentDialog()()
                  :Navigator.of(context).pushNamed('UpgradePlan');
                  }else{
                  documentDialog()();
                  }},
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(15),
                    child: Container(
                      height: 50.r,
                      width: 50.r,
                      color: mainColor,
                      child: Icon(Icons.add, color: Colors.white, size: 35.r)),
                  ),
                )
              : null),
    ));
  }

  documentDialog() {
    final _documentFormKey = GlobalKey<FormState>();
    AlertDialog dialog = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: StatefulBuilder(
            builder: (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        SizedBox(width: 10.w),
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios,size: 25.r),
                            onPressed: () {
                              clearText('Back');
                            }),
                        Text('Document',style: dialogTitle),
                      ]),
                      Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Form(
                            key: _documentFormKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                              child: Column(children: [
                                SizedBox(
                                    width: (context.isMobileTypeHandset)?200.w:140.w,
                                    child: TextFormField(
                                      style: (context.isMobileTypeTablet)?authTextField:null,
                                      focusNode: nameOfDocumentFocus,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Document name is required';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(noteFocus);
                                      },
                                      controller: nameOfDocument,
                                      decoration: textInputDecoration.copyWith(
                                          prefixIcon: Icon(Icons.title,size: 22.r,),
                                          labelText: 'Name Of Document'),
                                    )),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  width: (context.isMobileTypeHandset)?200.w:140.w,
                                  child: TextField(
                                      controller: note,
                                      style: (context.isMobileTypeTablet)?authTextField:null,
                                      focusNode: noteFocus,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: textInputDecoration.copyWith(
                                          prefixIcon: Icon(Icons.note,size: 22.r,),
                                          labelText: 'Note')),
                                ),
                                SizedBox(height: 10.h),
                                AttachButton(),
                              ]),
                            ),
                          )),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (_documentFormKey.currentState.validate()) {
                            clearText('Save');
                          }
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: Text(
                            "Save",style: authTextStyle.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ])));
    showDialog(context: context, child: dialog, barrierDismissible: false);
  }

  clearText(String option) async {
    FocusScope.of(context).unfocus();
    switch (option) {
      case 'Back':
      Navigator.of(context).pop();
      break;
      case 'Save':
        await Document.uploadDocument(nameOfDocument: nameOfDocument.text,context: context,
        note: note.text,filesToUpload: attachments);
        break;
    }
    nameOfDocument.text = '';
    note.text = '';
    attachments = [];
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    navigateToDetail(Document document) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(document: document)));
    }

    var streamProvider = Provider.of<List<Document>>(context);
    if (streamProvider != null) {
      return Container(
        child: (streamProvider.length != 0)?ListView(
          children: streamProvider.where((document) => document.nameOfDocument
          .toLowerCase()
          .contains(query.toLowerCase())).map((Document document)=>
          GestureDetector(
                onTap: () {
                  AlertDialog dialog = new AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      contentPadding: EdgeInsets.only(top: 3.0, left: 5.0),
                      content: StatefulBuilder(
                          builder: (_, _setState) =>
                              Column(mainAxisSize: MainAxisSize.min, children: [
                                SizedBox(height: 1),
                                Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Column(children: [
                                      ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            navigateToDetail(document);
                                          },
                                          title: Row(
                                            children: [
                                              Icon(MdiIcons.eye,color: secondaryColor,size: 30.r),
                                              SizedBox(width: 20),
                                              Text('View',style: popupStyle)
                                            ],
                                          )),
                                          if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                                      ListTile(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                            context, MaterialPageRoute(
                                                builder: (context) =>Attachment(collection:Collection.documents,
                                                dbName: document.dbName,docName: document.nameOfDocument)));
                                          },
                                          title: Row(
                                            children: [
                                              Icon(Icons.collections,color: secondaryColor,size: 30.r),
                                              SizedBox(width: 20),
                                              Text('See Attachments',style: popupStyle)
                                            ],
                                          )),
                                          if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                                      ListTile(
                                          onTap: () async { 
                                            Navigator.of(context).pop();
                                           if(await showConfirmFileDeleteDialog(context,DeleteOption.document)){
                                          await Document.deleteDocument(dbName: document.dbName, context: context);
                                          }
                                          },
                                          title: Row(
                                            children: [
                                              Icon(Icons.delete_sweep,color: secondaryColor,size: 35.r),
                                              SizedBox(width: 20),
                                              Text('Delete',style: popupStyle)
                                            ],
                                          )),
                                    ])),
                              ])));
                  showDialog(
                      context: context, child: dialog, barrierDismissible: true);
                },
                child: Container(
                  height: 90.h,
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Row(children: [
                      Image.asset(
                        'assets/images/document.png',
                        width: (context.isMobileTypeHandset)?80:110,
                        color: mainColor,
                      ),
                      Container(
                        height: 70,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Colors.transparent,
                        width: (MediaQuery.of(context).size.width) / 1.55,
                        child: Stack(
                          children: [
                            Positioned(
                                top: 10,
                                left: 40,
                                child: Text(
                                  document.nameOfDocument,
                                  style: TextStyle(fontSize: RFontSize.normal),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              )).toList()
              ):Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Tap ',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style')),
            ClipRRect(child: Container(child: Icon(Icons.add,color: Colors.white,size: 30),
            color: Colors.grey[300],height: 40,width: 40),
            borderRadius: BorderRadius.circular(8)),
            Text(' to add documents',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style'),)
          ],)
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class DetailPage extends StatefulWidget {
  final Document document;
  DetailPage({this.document});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameOfDocument = TextEditingController();
  TextEditingController note = TextEditingController();
  bool enabled = false;
  @override
  void initState() {
    nameOfDocument.text = widget.document.nameOfDocument;
    note.text = widget.document.note;
    enabled = false;
    super.initState();
  }
  @override
    void dispose() {
      super.dispose();
      nameOfDocument.dispose();
      note.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Column(children: [
            Container(
                  height: (context.screenHeight) / 2.5,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(image,
                            width: 150, height: 150, color: mainColor),
                      ),
                      Positioned(
                          top: 10.h,
                          left: 8.w,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 28.r,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            },
                          )),
                      Positioned(
                           top: 10.h,
                            right: 40.w,
                          child: FlatButton.icon(
                              color: Colors.transparent,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                await Document.updateDocument(context: context,nameOfDocument: nameOfDocument.text,note: note.text,dbName: widget.document.dbName);
                              },
                              icon: Icon(
                                Icons.check,
                                size: 30.r,
                              ),
                              label: Text(
                                'Save',style:TextStyle(fontSize: RFontSize.normal)
                              ))),
                      Positioned(
                          top: 10.h,
                          right: 8.w,
                          child: PopupMenuButton<PopupMenuChoice>(
                            icon: Icon(Icons.more_vert, size: 28.r),
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onSelected: (PopupMenuChoice result) async {
                              switch (result) {
                                case PopupMenuChoice.edit:
                                  setState(() => enabled = true);
                                  break;
                                case PopupMenuChoice.delete:
                                  FocusScope.of(context).unfocus();
                                   if(await showConfirmFileDeleteDialog(context,DeleteOption.document)){
                                  await Document.deleteDocument(dbName: widget.document.dbName,context: context);
                                    Navigator.of(context).pop();
                                   }
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<PopupMenuChoice>(
                                value: PopupMenuChoice.edit,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 30.r),
                                      SizedBox(width: 10),
                                      Text('Edit',style: TextStyle(fontSize: RFontSize.normal)),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem<PopupMenuChoice>(
                                value: PopupMenuChoice.delete,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_sweep, size: 30.r),
                                      SizedBox(width: 10),
                                      Text('Delete',style: TextStyle(fontSize: RFontSize.normal)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            SizedBox(height: 60),
            Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.w,
                        child: TextField(
                          style: authTextField,
                          enabled: enabled,
                          cursorColor: secondaryColor,
                          controller: nameOfDocument,
                          decoration: detailInputDecoration.copyWith(
                            labelText: 'Name Of Document',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.title, size: 25.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      IconButton(
                          icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                          onPressed: () {
                            Clipboard.setData(
                                    new ClipboardData(text: nameOfDocument.text))
                                .then((_) {
                              showCopiedFlushBar(context);
                            });
                          }),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.w,
                        child: TextField(
                          style: authTextField,
                          enabled: enabled,
                          controller: note,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: detailInputDecoration.copyWith(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.note, size: 25.r),
                            ),
                            labelText: 'Note',
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      IconButton(
                          icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: note.text))
                                .then((_) {
                              showCopiedFlushBar(context);
                            });
                          }),
                    ],
                  ),
                ],
            ),
          ]),
              )),
        ),
      ),
    );
  }
}
