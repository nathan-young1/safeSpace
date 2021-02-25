import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
import 'package:safeSpace/Payments/code/paymentDetails.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:velocity_x/velocity_x.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController expirationDate = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController nameOnCard = TextEditingController();
  TextEditingController typeOfCard = TextEditingController();
  TextEditingController numberOnCard = TextEditingController();
  TextEditingController securityCode = TextEditingController();
  TextEditingController searchBar = TextEditingController();
  final nameFocus = FocusNode();
  final nameOnCardFocus = FocusNode();
  final typeOfCardFocus = FocusNode();
  final numberOnCardFocus = FocusNode();
  final securityFocus = FocusNode();
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
      expirationDate.dispose();
      name.dispose();
      nameOnCard.dispose();
      typeOfCard.dispose();
      numberOnCard.dispose();
      securityCode.dispose();
      nameFocus.dispose();
      nameOnCardFocus.dispose();
      typeOfCardFocus.dispose();
      numberOnCardFocus.dispose();
      securityFocus.dispose();
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
              child: CustomAppBar(collection: Collection.payments)),
            body: (internetConnection)? ListPage(): NoInternetConnection(),
            floatingActionButton: (!isSearching.searching && internetConnection)
              ? InkWell(
                  onTap: () {
                  if(Provider.of<List<Payments>>(context,listen: false).length == 5){
                  (SafeSpaceSubscription.isPremiumUser)
                  ?paymentDialog()
                  :Navigator.of(context).pushNamed('UpgradePlan');
                  }else{
                  paymentDialog();
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

  paymentDialog() {
    final _paymentFormKey = GlobalKey<FormState>();
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
                          onPressed: () => clearText('Back')
                        ),
                      ),
                      Text('Payment Card',style: dialogTitle),
                      ]),
                      Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Form(
                          key: _paymentFormKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                            child: Column(children: [
                              SizedBox(
                                width: (context.isMobileTypeHandset)?200.w:140.w,
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: (context.isMobileTypeTablet)?authTextField:null,
                                  focusNode: nameFocus,
                                  controller: name,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).requestFocus(nameOnCardFocus);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                  decoration: textInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.person,size: 22.r),
                                      labelText: 'Name'),
                                )),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: (context.isMobileTypeHandset)?200.w:140.w,
                                child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    focusNode: nameOnCardFocus,
                                    style: (context.isMobileTypeTablet)?authTextField:null,
                                    controller: nameOnCard,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(typeOfCardFocus);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Card Name is required';
                                      }
                                      return null;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        prefixIcon: Icon(MdiIcons.formatTitle,size: 22.r),
                                        labelText: 'Name On Card')),
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                  width: (context.isMobileTypeHandset)?200.w:140.w,
                                  child: TextFormField(
                                    focusNode: typeOfCardFocus,
                                    controller: typeOfCard,
                                    style: (context.isMobileTypeTablet)?authTextField:null,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(numberOnCardFocus);
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        prefixIcon: Icon(MdiIcons.group,size: 22.r),
                                        labelText: 'Type'),
                              )),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: (context.isMobileTypeHandset)?200.w:140.w,
                                child: TextFormField(
                                  focusNode: numberOnCardFocus,
                                  controller: numberOnCard,
                                  style: (context.isMobileTypeTablet)?authTextField:null,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).requestFocus(securityFocus);
                                  },
                                    decoration: textInputDecoration.copyWith(
                                        prefixIcon: Icon(Icons.payment,size: 22.r),
                                        labelText: 'Number On Card')),
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: (context.isMobileTypeHandset)?200.w:140.w,
                                child: TextFormField(
                                    focusNode: securityFocus,
                                    controller: securityCode,
                                    style: (context.isMobileTypeTablet)?authTextField:null,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).unfocus();
                                    },
                                decoration: textInputDecoration.copyWith(
                                    prefixIcon: Icon(Icons.code,size: 22.r),
                                    labelText: 'Security Code')),
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: (context.isMobileTypeHandset)?200.w:140.w,
                                child: TextField(
                                    readOnly: true,
                                    controller: expirationDate,
                                    style: (context.isMobileTypeTablet)?authTextField:null,
                                    onTap: () {
                                      showMonthPicker(
                                        context: context,
                                        firstDate: DateTime(1950, 1),
                                        lastDate: DateTime(2130, 12),
                                        initialDate: DateTime.now(),
                                        locale: Locale("en"),
                                      ).then((date) {
                                        if (date != null) {
                                          setState(() {
                                            var expSelect;
                                            String year;
                                            String fulldate;
                                            String month;
                                            expSelect = date;
                                            fulldate = expSelect
                                                .toString()
                                                .substring(0, 8);
                                            year = fulldate.substring(0, 4);
                                            month = fulldate.substring(5, 7);
                                            expirationDate.text =
                                                (month + '/' + year);
                                          });
                                        }
                                      });
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        prefixIcon: Icon(Icons.date_range,size: 22.r),
                                        labelText: 'Expiration Date')),
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
                          if (_paymentFormKey.currentState.validate()) {
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
    showDialog(context: context, child: dialog, barrierDismissible: false);
  }

  clearText(String option) async {
    FocusScope.of(context).unfocus();
    switch (option) {
      case 'Back':
      Navigator.of(context).pop();
      break;
      case 'Save':
        await Payments.uploadPayment(name:name.text,filesToUpload: attachments,context: context,
        nameOnCard: nameOnCard.text,numberOnCard: numberOnCard.text,typeOfCard: typeOfCard.text,
        securityCode: securityCode.text,expirationDate: expirationDate.text);
        break;
    }
    attachments = [];
    name.text = '';
    nameOnCard.text = '';
    typeOfCard.text = '';
    numberOnCard.text = '';
    securityCode.text = '';
    expirationDate.text = '';
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    navigateToDetail(Payments payments) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(payments: payments)));
    }

    var streamProvider = Provider.of<List<Payments>>(context);
    if (streamProvider != null) {
      return Container(
        child: (streamProvider.length != 0)?ListView(
            children: streamProvider.where((payment) =>
              payment.nameOnCard.toLowerCase().contains(query.toLowerCase())).map((Payments payment)=>
              GestureDetector(
                onTap: () {
                  AlertDialog dialog = new AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    contentPadding: EdgeInsets.only(top: 3.0, left: 5.0),
                    content: StatefulBuilder(
                      builder: (_, setState) =>
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(height: 1),
                          Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Column(children: [
                                ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  navigateToDetail(payment);
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
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                          Attachment(
                                            collection: Collection.payments,
                                            dbName: payment.dbName,
                                            docName: payment.nameOnCard),
                                          ),
                                        );
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
                                        await Payments.deletePayment(dbName: payment.dbName, context: context);
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
                  showDialog(context: context, child: dialog, barrierDismissible: true);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  height: 90.h,
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Row(children: [
                      Container(
                          child: (payment.image == 'No Logo')
                              ? ShaderMask(
                                  child: Image.asset(
                                    'assets/images/otherPayment.png',
                                    width: (context.isMobileTypeHandset)?90:120,
                                  ),
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                            colors: [mainColor, secondaryColor],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)
                                        .createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcATop,
                                )
                              : Image.asset(
                                  payment.image,
                                  width: (context.isMobileTypeHandset)?90:120,
                                )),
                                AppListTile(title: payment.nameOnCard,subtitle: payment.typeOfCard)
                    ]),
                  ),
                ),
              )).toList()):Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Tap ',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style')),
            ClipRRect(child: Container(child: Icon(Icons.add,color: Colors.white,size: 30),
            color: Colors.grey[300],height: 40,width: 40),
            borderRadius: BorderRadius.circular(8)),
            Text(' to add Payment card',style: TextStyle(color: Colors.grey,fontSize: 25,fontFamily: 'style'),)
          ],)
        ),
      );
    } else {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}

class DetailPage extends StatefulWidget {
  final Payments payments;
  DetailPage({this.payments});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController paymentTitle = TextEditingController();
  TextEditingController nameOnCard = TextEditingController();
  TextEditingController typeOfCard = TextEditingController();
  TextEditingController numberOnCard = TextEditingController();
  TextEditingController securityCode = TextEditingController();
  TextEditingController expirationDate = TextEditingController();
  bool enabled = false;
  @override
  void initState() {
    paymentTitle.text = widget.payments.name;
    nameOnCard.text = widget.payments.nameOnCard;
    typeOfCard.text = widget.payments.typeOfCard;
    numberOnCard.text = widget.payments.numberOnCard;
    securityCode.text = widget.payments.securityCode;
    expirationDate.text = widget.payments.expirationDate;
    enabled = false;
    super.initState();
  }
  @override
  void dispose() {
  super.dispose();
  paymentTitle.dispose();
  nameOnCard.dispose();
  typeOfCard.dispose();
  numberOnCard.dispose();
  securityCode.dispose();
  expirationDate.dispose();
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
                          child: (widget.payments.image == 'No Logo')
                            ? ShaderMask(
                              child: Image.asset('assets/images/otherPayment.png',width: 250,height: 300),
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [mainColor, secondaryColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight)
                                .createShader(bounds);
                              },
                              blendMode: BlendMode.srcATop,
                            )
                            : Image.asset(widget.payments.image,width: 250, height: 300)),
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
                              await Payments.updatePayment(name: paymentTitle.text,dbName: widget.payments.dbName,
                              nameOnCard: nameOnCard.text,numberOnCard: numberOnCard.text,expirationDate: expirationDate.text,
                              securityCode: securityCode.text,context: context,typeOfCard: typeOfCard.text);
                            },
                            icon: Icon(Icons.check,size: 30.r),
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
                                  await Payments.deletePayment(dbName: widget.payments.dbName,context: context);
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
                                      Icon(Icons.edit,size: 30.r),
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
                                      Icon(Icons.delete_sweep,size: 30.r),
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
                  Container(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: TextField(
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: paymentTitle,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person, size: 25.r),
                                  ),
                                  labelText: 'Name'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: paymentTitle.text))
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
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: nameOnCard,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(MdiIcons.formatTitle, size: 25.r),
                                      ),
                                  labelText: 'Name On Card'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(
                                        text: nameOnCard.text))
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
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: typeOfCard,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(MdiIcons.group, size: 25.r),
                                  ),
                                  labelText: 'Type'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: typeOfCard.text))
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
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: numberOnCard,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.payment, size: 25.r),
                                  ),
                                  labelText: 'Number On Card'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: numberOnCard.text))
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
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: securityCode,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.code, size: 25.r),
                                  ),
                                  labelText: 'Security Code'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: securityCode.text))
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
                              onTap: () {
                                showMonthPicker(
                                  context: context,
                                  firstDate: DateTime(1950, 1),
                                  lastDate: DateTime(2130, 12),
                                  initialDate: DateTime.now(),
                                  locale: Locale("en"),
                                ).then((date) {
                                  if (date != null) {
                                    setState(() {
                                      var expSelect;
                                      String year;
                                      String fulldate;
                                      String month;
                                      expSelect = date;
                                      fulldate =
                                          expSelect.toString().substring(0, 8);
                                      year = fulldate.substring(0, 4);
                                      month = fulldate.substring(5, 7);
                                      expirationDate.text =
                                          (month + '/' + year);
                                    });
                                  }
                                });
                              },
                              readOnly: true,
                              enabled: enabled,
                              style: authTextField,
                              cursorColor: secondaryColor,
                              controller: expirationDate,
                              decoration: detailInputDecoration.copyWith(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.date_range, size: 25.r),
                                  ),
                                  labelText: 'Expiration Date'),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              icon: Icon(MdiIcons.contentCopy, color: secondaryColor, size: 25.r),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: expirationDate.text))
                                  .then((_) => showCopiedFlushBar(context));
                              })
                        ],
                      ),
                    ]),
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
