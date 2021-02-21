import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/navigationDrawer.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/applicationInfo.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/noInternet.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:velocity_x/velocity_x.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  
  @override
  Widget build(BuildContext context) {
    DrawerState size = Provider.of<DrawerState>(context);
    bool internetConnection = Provider.of<InternetConnection>(context,listen: true).checkInternet;
    return Material(
       elevation: 10,
      borderRadius: BorderRadius.circular((Provider.of<DrawerState>(context).isDrawerOpen)?30.0:0),
          child: Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((Provider.of<DrawerState>(context).isDrawerOpen)?30.0:0),
          color: Colors.white, 
          ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor:  Colors.transparent,
            leading: (Provider.of<DrawerState>(context).isDrawerOpen)?IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
            onPressed: (){
             size.closeDrawer();
            })
            :IconButton(onPressed: (){
             size.openDrawer();
            },icon: Icon(MdiIcons.sortVariant,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),),
                title: Text('Settings',style: Theme.of(context).appBarTheme.textTheme.headline1),
              ),
              body: (internetConnection)?(context.isMobileTypeHandset)
              ?MobileSettings()
              :TabletSettings()
              :NoInternetConnection(),
        ),
      ),
    );
  }
}

class MobileSettings extends StatelessWidget {
  const MobileSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Card(
        child: ListTile(
        onTap: (){
          Navigator.of(context).pushNamed('ManageAccount');
        },
        leading: Image.asset('assets/images/SafeSpace.png',color: mainColor,height: 40,),
        title: Text('Manage Account',style: TextStyle(color: Colors.black,
                      fontSize: RFontSize.medium),),
        subtitle: Text(email,style: TextStyle(color: Colors.black,
                      fontSize: RFontSize.small+2),),
        )
    ),
    Card(
      child: SafeArea(
      child: AboutListTile(
        child: Text('About Safe Space',style: TextStyle(fontSize: RFontSize.medium)),
        dense: false,
        //applicationLegalese: '© Safe Space',
        icon: Icon(MdiIcons.progressQuestion,color: mainColor,size: 35.r),
        applicationIcon: Image.asset('assets/images/SafeSpace.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          color: Colors.teal,
                        ),
        applicationVersion: 'v${ApplicationInfo.version}',
        aboutBoxChildren: [
          Text('''Safe Space is a password manager designed with secruity, elegance and comfort in mind.
              \nAll data is encrypted using AES-256 Encryption before it's stored in your vault.
              ''',textAlign: TextAlign.justify,)
        ],),
      )
    ),
    Card(
      child: ListTile(
      onTap: ()=>Navigator.of(context).pushNamed('TermsOfService'),
      leading: Icon(Icons.rule,color: mainColor,size: 38.r),
      title: Text('Terms Of Service',style: TextStyle(fontSize: RFontSize.medium)),),
    ),
    Card(
      child: ListTile(
      onTap: ()=>Navigator.of(context).pushNamed('PrivacyPolicy'),
      leading: Icon(MdiIcons.security,color: mainColor,size: 35.r),
      title: Text('Privacy Policy',style: TextStyle(color: Colors.black,
                      fontSize: RFontSize.medium)),),
    ),
    // Todo: add help list tile
    ],);
  }
}

class TabletSettings extends StatelessWidget {
  const TabletSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,8,0,0),
      child: ListView(
        children: [
        Container(
          height: 60.h,
          child: Card(
            child: Align(
              child: ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('ManageAccount');
              },
              leading: Image.asset('assets/images/SafeSpace.png',color: mainColor,height: 40.h),
              title: Text('Manage Account',style: TextStyle(fontSize: RFontSize.normal)),
              subtitle: Text(email,style: TextStyle(fontSize: RFontSize.small)),
              ),
            )
      ),
        ),
      Container(
        height: 60.h,
        child: Card(
          child: SafeArea(
          child: Align(
            child: AboutListTile(
              child: Text('About Safe Space',style: TextStyle(fontSize: RFontSize.normal)),
              dense: false,
              //applicationLegalese: '© Safe Space',
              icon: Icon(MdiIcons.progressQuestion,color: mainColor,size: 35.r),
              applicationIcon: Image.asset('assets/images/SafeSpace.png',
                                height: 40.h,
                                width: 40.w,
                                fit: BoxFit.contain,
                                color: Colors.teal,
                              ),
              applicationVersion: 'v${ApplicationInfo.version}',
              aboutBoxChildren: [
                Text('''Safe Space is a password manager designed with secruity, elegance and comfort in mind.
                    \nAll data is encrypted using AES-256 Encryption before it's stored in your vault.
                    ''',textAlign: TextAlign.justify,style: TextStyle(fontSize: RFontSize.normal),)
              ],),
          ),
          )
        ),
      ),
      Container(
        height: 60.h,
        child: Card(
          child: Align(
            child: ListTile(
            onTap: ()=>Navigator.of(context).pushNamed('TermsOfService'),
            leading: Icon(Icons.rule,color: mainColor,size: 38.r),
            title: Text('Terms Of Service',style: TextStyle(fontSize: RFontSize.normal)),),
          ),
        ),
      ),
      Container(
        height: 60.h,
        child: Card(
          child: Align(
            child: ListTile(
            onTap: ()=>Navigator.of(context).pushNamed('PrivacyPolicy'),
            leading: Icon(MdiIcons.security,color: mainColor,size: 35.r),
            title: Text('Privacy Policy',style: TextStyle(fontSize: RFontSize.normal)),),
          ),
        ),
      ),
      // Todo: add help list tile
      ],),
    );
  }
}