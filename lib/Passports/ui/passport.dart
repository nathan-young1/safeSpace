import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Core-Services/attachment.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/appBar.dart';
import 'package:safeSpace/Custom-widgets/appListTile.dart';
import 'package:safeSpace/Custom-widgets/attachButton.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passports/code/passportDetails.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';

class Identity extends StatefulWidget {
  @override
  _IdentityState createState() => _IdentityState();
}

class _IdentityState extends State<Identity> {
  TextEditingController name = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController typeOfPassport = TextEditingController();
  TextEditingController passportNumber = TextEditingController();
  TextEditingController issuedDate = TextEditingController();
  TextEditingController expireDate = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController issuedAuthority = TextEditingController();
  TextEditingController searchBar = TextEditingController();
  final nationalityFocus = FocusNode();
  final genderFocus = FocusNode();
  final countryFocus = FocusNode();
  final idNumberFocus = FocusNode();
  final typeOfPassportFocus = FocusNode();
  final passportNumberFocus = FocusNode();
  final issuedAuthorityFocus = FocusNode();
  Future selectDate(BuildContext context, String textField) async {
    final DateTime? picked = await showDatePicker(
        helpText: textField.toUpperCase(),
        fieldLabelText: textField,
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
        switch (textField) {
          case 'Date Of Birth':
            birthDate.text = (day + '/' + month + '/' + year);
            break;
          case 'Issued Date':
            issuedDate.text = (day + '/' + month + '/' + year);
            break;
          case 'Expiration Date':
            expireDate.text = (day + '/' + month + '/' + year);
            break;
        }
      });
  }
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
      name.dispose();
      nationality.dispose();
      gender.dispose();
      country.dispose();
      idNumber.dispose();
      typeOfPassport.dispose();
      passportNumber.dispose();
      issuedDate.dispose();
      expireDate.dispose();
      birthDate.dispose();
      issuedAuthority.dispose();
      nationalityFocus.dispose();
      genderFocus.dispose();
      countryFocus.dispose();
      idNumberFocus.dispose();
      typeOfPassportFocus.dispose();
      passportNumberFocus.dispose();
      issuedAuthorityFocus.dispose();
    }
  @override
  Widget build(BuildContext context) {
    SearchBar isSearching = Provider.of<SearchBar>(context);
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Scaffold( 
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(collection: Collection.passports)),
          body: (internetConnection)?ListPage():NoInternetConnection(),
          floatingActionButton: (!isSearching.searching && internetConnection)
              ? InkWell(
                  onTap: () {
                  if(Provider.of<List<Passports>>(context,listen: false).length == 10){
                  (SafeSpaceSubscription.isPremiumUser)
                  ?passportDialog()
                  :Navigator.of(context).pushNamed('UpgradePlan');
                  }else{
                  passportDialog();
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
              : null
        ),
      ),
    );
  }

  passportDialog() {
    final _identityFormKey = GlobalKey<FormState>();
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: StatefulBuilder(
        builder: (context, setState) => Container(
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
                    onPressed: () => clearText('Back')
                    ),
              ),
              Text('Passport',style: dialogTitle)
            ]),
            Form(
              key: _identityFormKey,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                  child: Column(children: [
                    Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                          style: (context.isMobileTypeTablet)?authTextField:null,
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(nationalityFocus);
                          },
                          controller: name,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(Icons.text_fields,size: 22.r),
                              labelText: 'Name')),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nationality is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(genderFocus);
                          },
                          focusNode: nationalityFocus,
                          controller: nationality,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(Icons.map,size: 22.r,),
                              labelText: 'Nationality')),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Gender is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(countryFocus);
                          },
                          focusNode: genderFocus,
                          controller: gender,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon:
                                  Icon(MdiIcons.genderMaleFemale,size: 22.r,),
                              labelText: 'Gender')),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Country is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(idNumberFocus);
                          },
                          focusNode: countryFocus,
                          controller: country,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(MdiIcons.earth,size: 22.r,),
                              labelText: 'Country')),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                        width: (context.isMobileTypeHandset)?200.w:140.w,
                        child: TextFormField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(typeOfPassportFocus);
                          },
                          focusNode: idNumberFocus,
                          controller: idNumber,
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(MdiIcons.numeric,size: 22.r,),
                              labelText: 'ID Number'),
                        )),
                        SizedBox(height: 5.h),
                        Container(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextFormField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(passportNumberFocus);
                              },
                              focusNode: typeOfPassportFocus,
                              controller: typeOfPassport,
                              decoration: textInputDecoration.copyWith(
                                  prefixIcon: Icon(MdiIcons.group,size: 22.r,),
                                  labelText: 'Type')),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              focusNode: passportNumberFocus,
                              controller: passportNumber,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Passport Number',
                                  prefixIcon: Icon(MdiIcons.numeric,size: 22.r,))),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              controller: birthDate,
                              readOnly: true,
                              onTap: () {
                                selectDate(context, 'Date Of Birth');
                              },
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Date of Birth',
                                  prefixIcon: Icon(Icons.date_range,size: 22.r,))),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              readOnly: true,
                              controller: issuedDate,
                              onTap: () {
                                selectDate(context, 'Issued Date');
                              },
                              decoration: textInputDecoration.copyWith(
                                labelText: 'Issued Date',
                                prefixIcon: Icon(Icons.date_range,size: 22.r,),
                              )),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              readOnly: true,
                              controller: expireDate,
                              onTap: () {
                                selectDate(context, 'Expiration Date');
                              },
                              decoration: textInputDecoration.copyWith(
                                labelText: 'Expiration Date',
                                prefixIcon: Icon(Icons.date_range,size: 22.r,),
                              )),
                        ),
                        SizedBox(height: 5.h),
                        SizedBox(
                          width: (context.isMobileTypeHandset)?200.w:140.w,
                          child: TextField(
                      style: (context.isMobileTypeTablet)?authTextField:null,
                              focusNode: issuedAuthorityFocus,
                              controller: issuedAuthority,
                              decoration: textInputDecoration.copyWith(
                                labelText: 'Issued Authority',
                                prefixIcon: Icon(Icons.person_outline,size: 22.r,),
                              )),
                        ),
                        SizedBox(height: 10.h),
                        AttachButton(),
                            ]),
                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                          if (_identityFormKey.currentState!.validate()) {
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
                    ])))));
    showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
  }

  clearText(String option) async {
    FocusScope.of(context).unfocus();
    switch (option) {
      case 'Back':
      Navigator.of(context).pop();
      break;
      case 'Save':
        await Passports.uploadPassport(birthDate: birthDate.text,name: name.text,
        context: context,country: country.text,
        typeOfPassport: typeOfPassport.text,filesToUpload: attachments,
        expireDate: expireDate.text,issuedAuthority: issuedAuthority.text,
        issuedDate: issuedDate.text,passportNumber: passportNumber.text,
        idNumber: idNumber.text,gender: gender.text,nationality: nationality.text
        );
        break;
    }
    name.text = '';
    nationality.text = '';
    gender.text = '';
    country.text = '';
    idNumber.text = '';
    typeOfPassport.text = '';
    passportNumber.text = '';
    issuedDate.text = '';
    expireDate.text = '';
    issuedAuthority.text = '';
    birthDate.text = '';
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
    navigateToDetail(Passports passports) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(passports: passports)));
    }

    var streamProvider = Provider.of<List<Passports>>(context);
    if (streamProvider != null) {
      return Container(
        child: (streamProvider.length != 0)?ListView(
            children: streamProvider.where((passports) =>
              passports.country.toLowerCase().contains(query.toLowerCase())).map((Passports passport)=>
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
                                          navigateToDetail(passport);
                                        },
                                        title: Row(
                                          children: [
                                            Icon( MdiIcons.eye,color: secondaryColor,size: 30.r),
                                            SizedBox(width: 20),
                                            Text('View',style: popupStyle)
                                          ],
                                          )),
                                           if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                                      ListTile(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,MaterialPageRoute(
                                                builder: (context) =>
                                                Attachment(collection:Collection.passports,dbName: passport.dbName,docName: passport.country)));
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
                                        await Passports.deletePassport(dbName: passport.dbName,context: context);
                                        } },
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
                      builder: (context) => dialog, context: context, barrierDismissible: true);
                },
                child: Container(
                  height: 90.h,
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: ShaderMask(
                          child: Image.asset('assets/images/passport.png',
                              width: 90, color: mainColor),
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [mainColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)
                          .createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                        ),
                      ),
                      AppListTile(title: passport.name,subtitle: passport.country)
                    ]),
                  ),
                ),
              )
              ).toList())
          :Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Tap ',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style')),
            ClipRRect(child: Container(child: Icon(Icons.add,color: Colors.white,size: 30),
            color: Colors.grey[300],height: 40,width: 40),
            borderRadius: BorderRadius.circular(8)),
            Text(' to add passports',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style'),)
          ],)
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class DetailPage extends StatefulWidget {
  final Passports passports;
  DetailPage({required this.passports});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController name = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController typeOfPassport = TextEditingController();
  TextEditingController passportNumber = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController issuedDate = TextEditingController();
  TextEditingController expireDate = TextEditingController();
  TextEditingController issuedAuthority = TextEditingController();

  Future selectDate(BuildContext context, String textField) async {
    final DateTime? picked = await showDatePicker(
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
        switch (textField) {
          case 'Date Of Birth':
            birthDate.text = (day + '/' + month + '/' + year);
            break;
          case 'Issued Date':
            issuedDate.text = (day + '/' + month + '/' + year);
            break;
          case 'Expiration Date':
            expireDate.text = (day + '/' + month + '/' + year);
            break;
        }
      });
  }

  bool? enabled;

  @override
  void initState() {
    name.text = widget.passports.name;
    nationality.text = widget.passports.nationality;
    gender.text = widget.passports.gender;
    country.text = widget.passports.country;
    idNumber.text = widget.passports.idNumber;
    typeOfPassport.text = widget.passports.typeOfPassport;
    passportNumber.text = widget.passports.passportNumber;
    birthDate.text = widget.passports.birthDate;
    issuedDate.text = widget.passports.issuedDate;
    expireDate.text = widget.passports.expireDate;
    issuedAuthority.text = widget.passports.issuedAuthority;
    enabled = false;
    super.initState();
  }

  @override
    void dispose() {
      super.dispose();
      name.dispose();
      nationality.dispose();
      gender.dispose();
      country.dispose();
      idNumber.dispose();
      typeOfPassport.dispose();
      passportNumber.dispose();
      issuedDate.dispose();
      expireDate.dispose();
      birthDate.dispose();
      issuedAuthority.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          //to act as safe area
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: SingleChildScrollView(
            child: Padding(
              //to add to the bottom of the list
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Column(
                children: [
                  Container(
                    height: (context.screenHeight) / 2.5,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: ShaderMask(
                            child: Image.asset('assets/images/passport.png',
                                width: 150, height: 150),
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                      colors: [mainColor, secondaryColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)
                                  .createShader(bounds);
                            },
                              blendMode: BlendMode.srcATop,
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
                                  onPressed: () async => await Passports.updatePassport(
                                    name: name.text,
                                    nationality:nationality.text,
                                    gender: gender.text,
                                    country: country.text,
                                    idNumber: idNumber.text,
                                    typeOfPassport: typeOfPassport.text,
                                    passportNumber: passportNumber.text,
                                    issuedDate: issuedDate.text,
                                    expireDate: expireDate.text,
                                    birthDate: birthDate.text,
                                    issuedAuthority: issuedAuthority.text,
                                    context: context,
                                    dbName: widget.passports.dbName
                                    ),
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
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.more_vert, size: 28.r),
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
                                      await Passports.deletePassport(dbName: widget.passports.dbName, context: context);
                                      Navigator.of(context).pop();
                                      }
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
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
                                  PopupMenuItem(
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
                            enabled: enabled,
                            style: authTextField,
                            cursorColor: secondaryColor,
                            controller: name,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Name',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.text_fields, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: name.text))
                                  .then((_) =>  showCopiedFlushBar(context));
                            })
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300.w,
                          child: TextField(
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: nationality,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Nationality',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.map, size: 25.r),
                                ),
                              )),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: nationality.text))
                                  .then((_) =>  showCopiedFlushBar(context));
                            })
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
                            controller: gender,
                            decoration: detailInputDecoration.copyWith(
                              prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(MdiIcons.genderMaleFemale, size: 25.r),
                                  ),
                              labelText: 'Gender',
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: gender.text))
                                  .then((_) => showCopiedFlushBar(context));
                            })
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
                            controller: country,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Country',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(MdiIcons.earth, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: country.text))
                                  .then((_) =>  showCopiedFlushBar(context));
                            })
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
                              controller: idNumber,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Id Number',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(MdiIcons.numeric, size: 25.r),
                                ),
                              )),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: idNumber.text))
                                  .then((_) => showCopiedFlushBar(context));
                            })
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
                            controller: typeOfPassport,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Type Of Passport',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(MdiIcons.group, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(
                                      text: typeOfPassport.text))
                                  .then((_) => showCopiedFlushBar(context));
                            })
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
                              controller: passportNumber,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Passport Number',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(MdiIcons.numeric, size: 25.r),
                                ),
                              )),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(
                                      text: passportNumber.text))
                                  .then((_) => showCopiedFlushBar(context));
                            })
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
                            onTap: () {
                              setState(() {
                                selectDate(context, 'Date Of Birth');
                              });
                            },
                            enabled: enabled,
                            readOnly: true,
                            cursorColor: secondaryColor,
                            controller: birthDate,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Date Of Birth',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.date_range, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: birthDate.text))
                                  .then((_) => showCopiedFlushBar(context));
                            })
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
                            onTap: () {
                              setState(() {
                                selectDate(context, 'Issued Date');
                              });
                            },
                            enabled: enabled,
                            readOnly: true,
                            cursorColor: secondaryColor,
                            controller: issuedDate,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Issued Date',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.date_range, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: issuedDate.text))
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
                              onTap: () {
                                setState(() {
                                  selectDate(context, 'Expiration Date');
                                });
                              },
                              enabled: enabled,
                              readOnly: true,
                              cursorColor: secondaryColor,
                              controller: expireDate,
                              decoration: detailInputDecoration.copyWith(
                                labelText: 'Expiration Date',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.date_range, size: 25.r),
                                ),
                              )),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: expireDate.text))
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
                            controller: issuedAuthority,
                            decoration: detailInputDecoration.copyWith(
                              labelText: 'Issued Authority',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.person, size: 25.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        IconButton(
                            icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(
                                      text: issuedAuthority.text))
                                  .then((_) => showCopiedFlushBar(context));
                            }),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }
}
