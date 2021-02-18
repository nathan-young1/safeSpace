import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/alertDialogs.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class ManageAccount extends StatefulWidget {
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  bool _biometric = false;
  bool _screenShot = false;

  @override
  Widget build(BuildContext context) {
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
        title: Text('Manage Account',
        style: Theme.of(context).appBarTheme.textTheme.headline1),),
      body: (internetConnection)?Padding(
        padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(0,8,0,0),
        child: ListView(
          children: [
            Container(
              height: 60.h,
              child: Card(
                child: Align(
                  child: ListTile(
                    onTap: (){
                      authenticateVaultKeyBeforeReEncryption(context: context);
                    },
                    title: Text('Change Vault Key',style: TextStyle(fontSize: RFontSize.normal)),
                    leading: Icon(MdiIcons.lockReset,size: 35.r,color: mainColor)
                  ),
                )
              ),
            ),
             Container(
               height: 60.h,
               child: Card(
                child: Align(
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed('SubscriptionStatus');
                    },
                    title: Text('Subscription Status',style: TextStyle(fontSize: RFontSize.normal)),
                    leading: Icon(MdiIcons.alarm,size: 35.r,color: mainColor)
                  ),
                )
            ),
             ),
             Container(
               height: 60.h,
               child: Card(
                child: Align(
                  child: SwitchListTile(
                    onChanged: (value)=> setState(()=> _biometric = value),
                    value: _biometric,
                    title: Text('Enable Biometric',style: TextStyle(fontSize: RFontSize.normal)),
                    secondary: Icon(MdiIcons.fingerprint,size: 35.r,color: mainColor)
                  ),
                )
            ),
             ),
             Container(
               height: 60.h,
               child: Card(
                child: Align(
                  child: SwitchListTile(
                    onChanged: (value) => setState(()=> _screenShot = value),
                    value: _screenShot,
                    title: Text('Disable Screenshot',style: TextStyle(fontSize: RFontSize.normal)),
                    secondary: Icon(MdiIcons.cellphoneScreenshot,size: 35.r,color: mainColor)
                  ),
                )
            ),
             )
          ],
        ),
      ):NoInternetConnection(),
                        )
    );
  }
}