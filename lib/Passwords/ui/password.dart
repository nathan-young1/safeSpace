import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Core-Services/passwordMiner.dart';
import 'package:safeSpace/Custom-widgets/appBar.dart';
import 'package:safeSpace/Custom-widgets/appListTile.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Firebase-Services/firebase-models.dart';
import 'package:safeSpace/Passwords/code/passwordDetails.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';

//todo if tablet different list tile size than if mobile
class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController passwordField = TextEditingController();
  TextEditingController passMiner = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController networkUrl = TextEditingController();
  TextEditingController accountUsername = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode networkFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
    void initState() {
      super.initState();
      //set state when search Bar contents changes
      searchBarState.onData((_) => setState(() {}));
    }

  @override
    void dispose() {
      super.dispose();
      titleFocus.dispose();
      networkFocus.dispose();
      usernameFocus.dispose();
      passwordField.dispose();
      passMiner.dispose();
      title.dispose();
      networkUrl.dispose();
      accountUsername.dispose();
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
              child: CustomAppBar(collection: Collection.passwords)),
            body: (internetConnection)?ListPage():NoInternetConnection(),
            floatingActionButton: (!isSearching.searching && internetConnection)
              ? InkWell(
                  onTap: () {
                  if(Provider.of<List<Passwords>>(context,listen: false).length == 10){
                  (SafeSpaceSubscription.isPremiumUser)
                  ?password()
                  :Navigator.of(context).pushNamed('UpgradePlan');
                  }else{
                  password();
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
      ),
    );
  }

  password() {
    final _passwordFormKey = GlobalKey<FormState>();
    AutovalidateMode passwordValidation = AutovalidateMode.onUserInteraction;
    AlertDialog dialog = new AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: StatefulBuilder(
        builder: (context, _setState) => SingleChildScrollView(
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
                    icon: Icon(Icons.arrow_back_ios,size: 25.r),onPressed: () => clearText('Back')),
                ),
                Text('Password Field',style: dialogTitle)
              ]),
              Form(
                key: _passwordFormKey,
                child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
                  child: Column(children: [
                  Container(
                    width: (context.isMobileTypeHandset)?200.w:140.w,
                    child: TextFormField(
                      style: authTextField,
                      autovalidateMode: passwordValidation,
                      focusNode: titleFocus,
                      controller: title,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                    },
                  onFieldSubmitted: (value) =>FocusScope.of(context).requestFocus(networkFocus),
                  decoration: textInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.title,size: 25),
                  labelText: 'Title'))),
                  SizedBox(height: 5.h),
                  Container(
                    width: (context.isMobileTypeHandset)?200.w:140.w,
                    child: TextFormField(
                        style: authTextField,
                        focusNode: networkFocus,
                        controller: networkUrl,
                        onFieldSubmitted: (value) =>FocusScope.of(context).requestFocus(usernameFocus),
                        decoration: textInputDecoration.copyWith(
                        prefixIcon: Icon(MdiIcons.web,size: 25),
                        labelText: 'Website Url'))),
                  SizedBox(height: 5.h),
                  Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                        style: authTextField,
                        autovalidateMode: passwordValidation,
                        focusNode: usernameFocus,
                        controller: accountUsername,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(Icons.person,size: 25,),
                          labelText: 'Username'))),
                  SizedBox(height: 5.h),
                  Container(
                      width: (context.isMobileTypeHandset)?200.w:140.w,
                      child: TextFormField(
                        focusNode: passwordFocusNode,
                        style: authTextField,
                        autovalidateMode: passwordValidation,
                        autofocus: false,
                        autocorrect: false,
                        controller: passwordField,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      decoration: textInputDecoration.copyWith(
                      suffixIcon: IconButton(
                            tooltip: 'Generate Password',
                            icon: Icon(Icons.enhanced_encryption,color: secondaryColor,size: (context.isMobileTypeHandset)?30.r:22.r),
                            onPressed: (){ 
                              FocusScope.of(context).unfocus();
                              passwordFocusNode.unfocus();
                              passwordFocusNode.canRequestFocus = false;
                              openPasswordMiner();
                              }),
                        labelText: 'Password'),
                                      ))
                          ]),
                        )),
                        ),
                  GestureDetector(
                    onTap: (){
                      if (_passwordFormKey.currentState!.validate()) {
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
                      child: Text("Save",style: authTextStyle.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                      )
                      ),
                        ),
                      ]),
                )));
    showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
  }

  openPasswordMiner() {
    validate(true, true, true,true, passwordLength.toInt());
    passMiner.text = '$generatedPassword';
    passwordMiner();
  }

  clearText(String option) async {
    switch (option) {
      case 'Back':
      Navigator.of(context, rootNavigator: true).pop();
      break;
      case 'Save':
      Navigator.of(context).pop();
      dynamic color = randomColor.randomColor().toString();
      await Passwords.uploadPassword(color: (color.substring(color.indexOf('0'), color.indexOf(")"))),
      username: accountUsername.text,password: passwordField.text,
      context: context,title: title.text,networkUrl: networkUrl.text);
      break;
    }
    passwordLength = 30.0;
    title.text = '';
    passwordField.text = '';
    accountUsername.text = '';
    networkUrl.text = '';
  }

  createPassword(bool small, bool capital, bool number, bool special, int passwordLength) {
    if (small == false &&capital == false &&number == false &&special == false) {
      passMiner.text = '';
    } else {
      validate(small, capital, number, special, passwordLength);
      passMiner.text = "$generatedPassword";
    }
  }

  passwordMiner() {
    bool special = true;
    bool number = true;
    bool small = true;
    bool capital = true;
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: StatefulBuilder(
        builder: (context, StateSetter setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
            children: [
              SizedBox(width: 10.w),
              Flexible(
                child: IconButton(
                  alignment: Alignment.bottomCenter,
                    icon: Icon(Icons.arrow_back_ios, size: 25.r),
                    onPressed: () { 
                      passwordFocusNode.canRequestFocus = true;
                      Navigator.pop(context);}),
              ),
              Text('Password Miner',style: dialogTitle),
              ]),
              Card(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Column(children: [
                    SizedBox(
                      width: (context.isMobileTypeHandset)?220.w:150.w,
                      child: TextField(
                        autocorrect: false,
                        autofocus: false,
                        readOnly: true,
                        style: authTextField,
                        controller: passMiner,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(Icons.refresh,size: 25.r),
                            onPressed: () {
                              setState(() => createPassword(small,capital,number,special,passwordLength.toInt()));
                            },
                            color: secondaryColor,
                                        ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.content_copy,size: 24.r),
                            onPressed: () async{
                              await Clipboard.setData(new ClipboardData(text: passMiner.text))
                                .then((_) => showCopiedFlushBar(context));
                            },
                            color: secondaryColor,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(width: 2, color: Colors.green)),
                        ))),
                        SizedBox(height: 5.h),
                        SizedBox(
                          child: Text('Password Lenth: ${passwordLength.toInt()}',style: dialogTitle.copyWith(fontSize: RFontSize.normal))),
                        SizedBox(
                          child: Slider.adaptive(
                            onChanged: (value) {
                              setState(() => passwordLength = value);
                              createPassword(small, capital, number,special, passwordLength.toInt());
                            },
                            max: 128,
                            min: 10,
                            divisions: 118,
                            value: passwordLength,
                            label: passwordLength.toInt().toString(),
                            activeColor: secondaryColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                            child: Row(
                          children: [
                          SizedBox(width: 12),
                          Container(
                            width: (context.isMobileTypeHandset)?200.w:150.w,
                            child: ExpansionTile(
                              title: Text('Advanced Settings',style: dialogTitle.copyWith(fontSize: RFontSize.normal)),
                              children: [
                                Column(children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    SizedBox(width: 10),
                                    Transform.scale(
                                      scale: (context.isMobileTypeHandset)?0.6:0.9,
                                      child: CustomSwitch(
                                        activeColor: secondaryColor,
                                        value: small,
                                        onChanged: (value) {
                                          setState(() {
                                            small = !small;
                                            createPassword(small,capital,number,special,passwordLength.toInt());
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text('a-z',style: dialogTitle.copyWith(fontSize: RFontSize.normal))
                                            ]),
                                    Row(children: [
                                      SizedBox(width: 10),
                                      Transform.scale(
                                        scale:  (context.isMobileTypeHandset)?0.6:0.9,
                                        child: CustomSwitch(
                                          activeColor: secondaryColor,
                                          value: capital,
                                          onChanged: (value) {
                                            setState(() {
                                              capital = !capital;
                                              createPassword(small,capital,number,special,passwordLength.toInt());
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text('A-Z',style: dialogTitle.copyWith(fontSize: RFontSize.normal)),
                                    ]),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Transform.scale(
                                          scale:  (context.isMobileTypeHandset)?0.6:0.9,
                                          child: CustomSwitch(
                                            activeColor: secondaryColor,
                                            value: number,
                                            onChanged: (value) {
                                              setState(() {
                                                number = !number;
                                                createPassword(small,capital,number,special,passwordLength.toInt());
                                              });
                                            },
                                          ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Text('0-9',style: dialogTitle.copyWith(fontSize: RFontSize.normal)),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Transform.scale(
                                          scale:  (context.isMobileTypeHandset)?0.6:0.9,
                                          child: CustomSwitch(
                                            activeColor: secondaryColor,
                                            value: special,
                                            onChanged: (value) {
                                              setState(() {
                                                special = !special;
                                                createPassword(small,capital, number,special,passwordLength.toInt());
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Flexible(child: Text('Special Character',style: dialogTitle.copyWith(fontSize: RFontSize.normal))),
                                        ],
                                      ),
                                          ])
                                        ]),
                                  ),
                                  SizedBox(width: 5.h),
                                ],
                              )),
                            ]),
                )),
                      GestureDetector(
                        onTap: () {
                          passwordField.text = passMiner.text;
                          passwordFocusNode.canRequestFocus = true;
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          height: 50.h,
                          child: Container(
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0),bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text("Ok",style: authTextStyle.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            ),
                        ),
                      ),
                    ])));
    showDialog(
    builder: (context) => WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        passwordFocusNode.canRequestFocus = true;
        Navigator.pop(context);
        return Future.value(true);
      },
      child: dialog), context: context, 
    barrierDismissible: false);
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    navigateToDetail(Passwords password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(passwords: password)));
    }

    var streamProvider = Provider.of<List<Passwords>>(context);
    
    if (streamProvider != null) {
      return Container(
        child: (streamProvider.length != 0)?ListView(
          children: streamProvider.where((password) =>
          password.title.toString().toLowerCase().contains(query.toLowerCase())).map((Passwords password)=>
            GestureDetector(
            onTap: () {
              AlertDialog dialog = new AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  contentPadding: EdgeInsets.only(top: 3.0, left: 4.0),
                  content: StatefulBuilder(
                    builder: (_, _setState) =>
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(height: 1),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            padding: (context.isMobileTypeTablet)?EdgeInsets.symmetric(vertical: 5.h, horizontal: 7.w):null,
                            child: Column(children: [
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  navigateToDetail(password);
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
                                Clipboard.setData(new ClipboardData(text: password.username)).then((_)  =>
                                 passwordFlushBar(context: context,type: PasswordCopiedType.Username)
                                );
                              },
                            title: Row(
                              children: [
                                Icon(MdiIcons.contentCopy,color: secondaryColor,size: 30.r),
                                SizedBox(width: 20),
                                Text('Copy Username',style: popupStyle)
                              ],
                            )),
                             if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                            ListTile(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(text: password.password)).then((_) =>
                                  passwordFlushBar(context: context,type: PasswordCopiedType.Password)
                                );
                              },
                                title: Row(
                                  children: [
                                    Icon(MdiIcons.contentCopy,color: secondaryColor,size: 30.r),
                                    SizedBox(width: 20),
                                    Text('Copy Password',style: popupStyle)
                                  ],
                                )),
                               if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                            ListTile(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                   if(await showConfirmFileDeleteDialog(context,DeleteOption.document)){
                                    await Passwords.deletePassword(dbName: password.dbName, context: context);
                                    } 
                                },
                                title: Row(
                                  children: [
                                    Icon(Icons.delete_sweep,color: secondaryColor,size: 35.r),
                                    SizedBox(width: 20),
                                    Text('Delete',style: popupStyle)
                                  ],
                                )),
                                 if(context.isMobileTypeTablet)SizedBox(height: 5.h),
                                  ]),
                          )),
                          ])));
              showDialog(builder: (context) => dialog, context: context, barrierDismissible: true);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              height: 90.h,
              child: Card(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                child: Row(
                  children: [
                    (password.image == 'No Logo')
                        ? Container(
                            decoration: BoxDecoration(
                              color: password.color,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                            ),
                            width: (context.isMobileTypeHandset)?120.w:90.w,
                            child: Align(
                                child: Text(
                              password.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'style'),
                              textAlign: TextAlign.center,
                            )),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                            ),
                            width: (context.isMobileTypeHandset)?120.w:90.w,
                            child: Align(child: Image.asset(password.image, height: 70.h)),
                          ),
                          AppListTile(title: password.username,subtitle: password.title)
                  ],
                ),
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
            Text(' to add passwords',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style'))
          ],)
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class DetailPage extends StatefulWidget {
  final passwords;
  DetailPage({this.passwords});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool enabled = false;
  @override
  void initState() {
    username.text = widget.passwords.username;
    password.text = widget.passwords.password;
    enabled = false;
    super.initState();
  }
  @override
    void dispose() {
      username.dispose();
      password.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    Color icon = (widget.passwords.image == 'No Logo')
        ? (widget.passwords.color)
        : Colors.teal;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: (widget.passwords.image == 'No Logo')
                    ? (widget.passwords.color)
                    : Colors.transparent,
                height: (context.screenHeight) / 2.5,
                child: Stack(
                  children: [
                    (widget.passwords.image == 'No Logo')
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15,0,15,0),
                              child: Text(
                                widget.passwords.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: RFontSize.xxxlarge),
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Image.asset(widget.passwords.image,
                                height: 300, width: 300)),
                    Positioned(
                        top: 10.h,
                        left: 8.w,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 28.r),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        )),
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
                            var _selection;
                            setState(() => _selection = result);
                            print(_selection);
                            switch (_selection) {
                              case PopupMenuChoice.edit:
                                setState(() => enabled = true);
                                break;
                              case PopupMenuChoice.delete:
                                FocusScope.of(context).unfocus();
                                if(await showConfirmFileDeleteDialog(context,DeleteOption.document)){
                                    await Passwords.deletePassword(dbName: widget.passwords.dbName, context: context);
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
                                    Icon(Icons.edit,size: 30.r),
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
                                    Icon(Icons.delete_sweep,
                                        size: 30.r),
                                    SizedBox(width: 10),
                                    Text('Delete',
                                        style: TextStyle(fontSize: RFontSize.normal)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                        top: 10.h,
                        right: 40.w,
                        child: FlatButton.icon(
                            color: Colors.transparent,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await Passwords.updatePassword(username: username.text,password: password.text,context: context,dbName: widget.passwords.dbName);
                            },
                            icon: Icon(
                              Icons.check,
                              size: 30.r,
                            ),
                            label: Text('Save',style:TextStyle(fontSize: RFontSize.normal)))),
                  ],
                )),
            SizedBox(height: 60),
            SingleChildScrollView(
                child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: 300.w,
                    child: TextField(
                      enabled: enabled,
                      style: authTextField,
                      cursorColor: secondaryColor,
                      controller: username,
                      decoration: detailInputDecoration.copyWith(
                          labelText: 'Username',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.person, size: 30.r, color: icon),
                          )),
                    )),
                SizedBox(width: 2),
                IconButton(
                    icon: Icon(MdiIcons.contentCopy, color: icon, size: 25.r),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: username.text))
                          .then((_) => showCopiedFlushBar(context));
                    }),
              ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                width: 300.w,
                child: TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    enabled: enabled,
                    style: authTextField,
                    cursorColor: secondaryColor,
                    controller: password,
                    decoration: detailInputDecoration.copyWith(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.lock, size: 25.r, color: icon),
                      ),
                      labelText: 'Password',
                    ))),
            SizedBox(width: 2),
            IconButton(
            icon: Icon(MdiIcons.contentCopy, color: icon, size: 25.r),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: password.text)).then((_) => showCopiedFlushBar(context));
            })
              ]),
            ]))
          ],
        ),
      ))
    );
  }
}
