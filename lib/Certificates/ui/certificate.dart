import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Certificates/code/certificateDetails.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/appBar.dart';
import 'package:safeSpace/Custom-widgets/appListTile.dart';
import 'package:safeSpace/Custom-widgets/attachButton.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';

class Certificate extends StatefulWidget {
  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  TextEditingController name = TextEditingController();
  TextEditingController typeOfCertificate = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController yearOfGraduation = TextEditingController();
  TextEditingController searchBar = TextEditingController();
  final nameFocus = FocusNode();
  final typeOfCertificateFocus = FocusNode();
  final collegeFocus = FocusNode();
  Future selectGraduationYear(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2130, 12));
    if (picked != null && picked != DateTime.now())
      setState(() {
        var startSelect;
        String year;
        String fulldate;
        String month;
        String day;
        startSelect = picked;
        fulldate = startSelect.toString().substring(0, 11);
        year = fulldate.substring(0, 4);
        month = fulldate.substring(5, 7);
        day = fulldate.substring(8, 10);
        yearOfGraduation.text = (day + '/' + month + '/' + year);
      });
  }
  @override
    void initState() {
      super.initState();
      //set state when search Bar contents changes
      searchBarState.onData((_) => setState(() {}));
    }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    typeOfCertificate.dispose();
    college.dispose();
    yearOfGraduation.dispose();
    nameFocus.dispose();
    typeOfCertificateFocus.dispose();
    collegeFocus.dispose();
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
              child: CustomAppBar(collection: Collection.certificates)),
          body: (internetConnection)?ListPage():NoInternetConnection(),
          floatingActionButton: (!isSearching.searching && internetConnection)
              ? InkWell(
                  onTap: () {
                  if(Provider.of<List<Certificates>>(context,listen: false).length == 5){
                  (SafeSpaceSubscription.isPremiumUser)
                  ?certificateDialog()
                  :Navigator.of(context).pushNamed('UpgradePlan');
                  }else{
                  certificateDialog();
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
              : null,
        ),
      ),
    );
  }

  certificateDialog() {
    final _certificateFormKey = GlobalKey<FormState>();
    AlertDialog dialog = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: StatefulBuilder(
            builder: (context, _setState) => Container(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                      SizedBox(width: 10.w),
                      Flexible(
                        child: IconButton(
                          alignment: Alignment.bottomCenter,
                            icon: Icon(Icons.arrow_back_ios,size: 25.r),
                            onPressed: () {
                              clearText('Back');
                            }),
                      ),
                            Text('Certificate',style: dialogTitle),
                          ]),
                          Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Form(
                                key: _certificateFormKey,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                                  child: Column(children: [
                                    SizedBox(
                                      width: (context.isMobileTypeHandset)?200.w:140.w,
                                      child: TextFormField(
                                        style: (context.isMobileTypeTablet)?authTextField:null,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          focusNode: nameFocus,
                                          controller: name,
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(collegeFocus);
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Name is required';
                                            }
                                            return null;
                                          },
                                          decoration:
                                          textInputDecoration.copyWith(
                                              prefixIcon: Icon(Icons.person,size: 22.r,),
                                              labelText: 'Name')),
                                    ),
                                    SizedBox(height: 5.h),
                                    SizedBox(
                                      width: (context.isMobileTypeHandset)?200.w:140.w,
                                      child: TextFormField(
                                        style: (context.isMobileTypeTablet)?authTextField:null,
                                          focusNode: collegeFocus,
                                          controller: college,
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(
                                                typeOfCertificateFocus);
                                          },
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  prefixIcon: Icon(Icons.school,size: 22.r,),
                                                  labelText: 'School/College')),
                                    ),
                                    SizedBox(height: 5.h),
                                    SizedBox(
                                      width: (context.isMobileTypeHandset)?200.w:140.w,
                                      child: TextFormField(
                                        style: (context.isMobileTypeTablet)?authTextField:null,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          focusNode: typeOfCertificateFocus,
                                          controller: typeOfCertificate,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Type is required';
                                            }
                                            return null;
                                          },
                                          decoration: textInputDecoration.copyWith(
                                                  prefixIcon:
                                                      Icon(MdiIcons.ribbon,size: 22.r,),
                                                  labelText:'Type Of Certificate')),
                                    ),
                                    SizedBox(height: 5.h),
                                    SizedBox(
                                      width: (context.isMobileTypeHandset)?200.w:140.w,
                                      child: TextField(
                                        style: (context.isMobileTypeTablet)?authTextField:null,
                                          readOnly: true,
                                          controller: yearOfGraduation,
                                          onTap: () {
                                            selectGraduationYear(context);
                                          },
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  prefixIcon:
                                                      Icon(MdiIcons.calendar,size: 22.r),
                                                  labelText: 'Year')),
                                    ),
                                    SizedBox(height: 10.h),
                                    AttachButton(),
                                  ]),
                                ),
                              )),
                              SizedBox(height: 10),
                          GestureDetector(
                            onTap: (){
                              if (_certificateFormKey.currentState.validate()) {
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
                        ]),
                  ),
                )));
    showDialog(context: context, child: dialog, barrierDismissible: false);
  }

  clearText(String option) async {
    FocusScope.of(context).unfocus();
    switch (option) {
      case 'Back':
      Navigator.of(context).pop();
      break;
      case 'Save':
      await Certificates.uploadCertificate(
      name: name.text, 
      typeOfCertificate: typeOfCertificate.text,
      yearOfGraduation: yearOfGraduation.text, 
      college: college.text,
      buildContext: context,
      filesToUpload: attachments
      );
      break;
    }
    name.text = '';
    college.text = '';
    typeOfCertificate.text = '';
    yearOfGraduation.text = '';
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
    navigateToDetail(Certificates certificates) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(certificate: certificates)));
    }

    List<Certificates> streamProvider = Provider.of<List<Certificates>>(context);
    if (streamProvider != null) {
      return Container(
        child: (streamProvider.length != 0)?ListView(
            children: streamProvider.where((certificate) =>
            certificate.typeOfCertificate.toLowerCase().contains(query.toLowerCase())).map((Certificates certificate)=>
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
                                SizedBox(height: 1.h),
                                Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Column(children: [
                                      ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            navigateToDetail(certificate);
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
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                            context,MaterialPageRoute(
                                                builder: (context) =>
                                                    Attachment(collection:Collection.certificates,dbName: certificate.dbName,docName: certificate.typeOfCertificate)));
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
                                        await Certificates.deleteCertificate(dbName: certificate.dbName,context: context);
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
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    child: Row(children: [
                      Image.asset(
                        'assets/images/certificate.png',
                        width: (context.isMobileTypeHandset)?100:120,
                      ),
                      AppListTile(title: certificate.name,subtitle:certificate.typeOfCertificate)
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
            Text(' to add certificates',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style'),)
          ],)
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class DetailPage extends StatefulWidget {
  final Certificates certificate;
  DetailPage({this.certificate});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController name = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController typeOfCertificate = TextEditingController();
  TextEditingController yearOfGraduation = TextEditingController();
  Future selectGraduationYear(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2130, 12));
    if (picked != null && picked != DateTime.now())
      setState(() {
        var startSelect;
        String year;
        String fulldate;
        String month;
        String day;
        startSelect = picked;
        fulldate = startSelect.toString().substring(0, 11);
        year = fulldate.substring(0, 4);
        month = fulldate.substring(5, 7);
        day = fulldate.substring(8, 10);
        yearOfGraduation.text = (day + '/' + month + '/' + year);
      });
  }

  bool enabled = false;
  @override
  void initState() {
    name.text = widget.certificate.name;
    college.text = widget.certificate.college;
    typeOfCertificate.text = widget.certificate.typeOfCertificate;
    yearOfGraduation.text = widget.certificate.yearOfGraduation;
    enabled = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    typeOfCertificate.dispose();
    college.dispose();
    yearOfGraduation.dispose();
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
              child: Column(
                children: [
                  Container(
                      height: (context.screenHeight) / 2.5,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              image,
                              width: 200,
                              height: 200,
                            ),
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
                                    await Certificates.updateCertificate(
                                    name: name.text, 
                                    typeOfCertificate: typeOfCertificate.text, 
                                    college: college.text, 
                                    yearOfGraduation: yearOfGraduation.text, 
                                    context: context, 
                                    dbName: widget.certificate.dbName);
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                  icon: Icon(Icons.check,size: 30.r),
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
                                      await Certificates.deleteCertificate(dbName: widget.certificate.dbName,context: context);
                                      Navigator.of(context).pop();
                                       }
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<PopupMenuChoice>>[
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
                  SizedBox(
                    height: 60,
                  ),
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
                                controller: name,
                                decoration: detailInputDecoration.copyWith(
                                  labelText: 'Name',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person, size: 25.r),
                                  ),
                                )),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(
                                        new ClipboardData(text: name.text))
                                    .then((_) => showCopiedFlushBar(context));
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
                              cursorColor: secondaryColor,
                              controller: college,
                              decoration: detailInputDecoration.copyWith(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.school, size: 25.r),
                                ),
                                labelText: 'School/College',
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(
                                        new ClipboardData(text: college.text))
                                    .then((_) => showCopiedFlushBar(context));
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
                              cursorColor: secondaryColor,
                              controller: typeOfCertificate,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Type Of Certificate',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(MdiIcons.ribbon, size: 25.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(
                                        text: typeOfCertificate.text))
                                    .then((_) => showCopiedFlushBar(context));
                              }),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150.w,
                            child: TextField(
                              style: authTextField,
                              onTap: () {
                                selectGraduationYear(context);
                              },
                              readOnly: true,
                              enabled: enabled,
                              cursorColor: secondaryColor,
                              controller: yearOfGraduation,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Year',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(MdiIcons.calendar, size: 25.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(
                                        text: yearOfGraduation.text))
                                    .then((_) => showCopiedFlushBar(context));
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
