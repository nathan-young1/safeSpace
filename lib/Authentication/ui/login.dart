import 'package:animations/animations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeSpace/Application-ui/homePage.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Authentication/ui/signup.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:safeSpace/Subscription/code/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'authenticationLoad.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  IconData passIcon = Icons.lock;
  bool hideText = true;
  TextEditingController safeSpacePassword;
  TextEditingController safeSpaceUsername = TextEditingController();
  final passwordFocus = FocusNode();
  bool loading = false;
  autofillUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.containsKey('username') ? prefs.getString('username') : '';
    safeSpaceUsername.text = username;
  }
  @override
  void initState() {
    super.initState();
    //clears the password by creating new text editing controller on each init state
    safeSpacePassword = TextEditingController(text: '');
    WidgetsBinding.instance.addPostFrameCallback((_) { 
    subscription = DataConnectionChecker().onStatusChange.listen((status) async {
     switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        Provider.of<InternetConnection>(context,listen: false).update(true);
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        showFlushBar(context,'No internet connection',Icons.wifi_off);
        Provider.of<InternetConnection>(context,listen: false).update(false);
        break;
    }
    });
    });
    autofillUsername();
  }

@override
  void dispose() {
    super.dispose();
    subscription.cancel();
    safeSpacePassword.clear();
    safeSpacePassword.dispose();
    safeSpaceUsername.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () => SystemNavigator.pop(),
            child: SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Container(
                    height: context.screenHeight,
                    width: context.screenWidth,
                    child: Column(
                      children: [
                        Stack(children: [
                          (context.isMobileTypeHandset)
                          ?MobileClipPath()
                          :TabletClipPath(),
                        ]),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (context.isMobileTypeHandset)
                                ?Container(
                                  width: 230.w,
                                  decoration: authenticationContainerDecoration,
                                  child: TextField(
                                      cursorHeight: 22,
                                      controller: safeSpaceUsername,
                                      style: authTextField,
                                      onSubmitted: (value) => FocusScope.of(context).requestFocus(passwordFocus),
                                      decoration: textInputDecorationForSafe.copyWith(
                                      prefixIcon: Icon(Icons.person,size: 27,color: mainColor)
                                      ,labelText: 'Email Address')),
                                )
                                :Container(
                                  width: 250.w,
                                  child: TextField(
                                      cursorHeight: 22,
                                      controller: safeSpaceUsername,
                                      style: authTextField,
                                      onSubmitted: (value) => FocusScope.of(context).requestFocus(passwordFocus),
                                      decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.w),
                                      labelStyle:TextStyle(color: Colors.black, fontSize: 17.ssp),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.person,size: 22.w,color: mainColor),
                                      ),
                                      labelText: 'Email Address')),
                                ),
                                SizedBox(height: 8.h),
                                (context.isMobileTypeHandset)
                                ?Container(
                                    width: 230.w,
                                    decoration: authenticationContainerDecoration,
                                    child: TextField(
                                        enableInteractiveSelection: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: authTextField,
                                        cursorHeight: 22,
                                        focusNode: passwordFocus,
                                        controller: safeSpacePassword,
                                        obscureText: hideText,
                                        onSubmitted: (value) {
                                            setState(() => loading = true);
                                            loginIntoSafe();
                                        },
                                        decoration: textInputDecorationForSafe.copyWith(
                                                prefixIcon: IconButton(
                                                  icon: Icon(passIcon,color: mainColor,size: 27),
                                                  onPressed: () => setState(() => togglePasswordIcon()),
                                                ),
                                                labelText: 'Vault Key')))
                                  :Container(
                                    width: 250.w,
                                    child: TextField(
                                        enableInteractiveSelection: false,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: authTextField,
                                        cursorHeight: 22,
                                        focusNode: passwordFocus,
                                        controller: safeSpacePassword,
                                        obscureText: hideText,
                                        onSubmitted: (value) {
                                            setState(() => loading = true);
                                            loginIntoSafe();
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                          labelStyle:TextStyle(color: Colors.black, fontSize: 17.ssp),
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: IconButton(icon: Icon(passIcon,color: mainColor,size: 18.w),
                                                    onPressed: () => setState(() => togglePasswordIcon()),
                                                  ),
                                                ),
                                                labelText: 'Vault Key'))),
                                SizedBox(height: 15.h),
                                ButtonTheme(
                                    minWidth: 100.w,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateColor.resolveWith((states) => mainColor)),
                                        onPressed: (){
                                            setState(() => loading = true);
                                            loginIntoSafe();
                                        },
                                        child: Text('Login',style: authTextStyle))),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('New User? ',style: TextStyle(fontSize: 16.ssp)),
                                    GestureDetector(
                                        onTap: () =>  Navigator.of(context).push(_routeToSignUp()),
                                        child: Text('Signup',style: TextStyle(color: secondaryColor, fontSize: 17.ssp)))
                                  ],
                                ),
                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ]),
                    ),
                  ),
                ),
              ),
          );
  }

  togglePasswordIcon() {
    if (passIcon == Icons.lock) {
      passIcon = Icons.lock_open;
      hideText = false;
    } else {
      passIcon = Icons.lock;
      hideText = true;
    }
  }

  loginIntoSafe() async {
    Authentication result = await signInWithEmailAndPasswordInLogin(safeSpaceUsername.text, safeSpacePassword.text,context);
    switch (result) {
      case Authentication.Successful:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', email);
        await SafeSpaceSubscription.initalizePlugin();
        Navigator.of(context).pushReplacement(_routeToHome());
        break;
      case Authentication.InvalidDetail:
        setState(() => loading = false);
        safeSpacePassword.text = '';
        showFlushBar(context, 'Invalid details', MdiIcons.lockAlert);
        break;
      case Authentication.WrongPassword:
        setState(() => loading = false);
        safeSpacePassword.text = '';
        showFlushBar(context, 'Wrong Password', MdiIcons.lockAlert);
        break;
      case Authentication.Error:
        setState(() => loading = false);
        showFlushBar(context, 'Error occured during login', Icons.error);
        break;
      default:
        setState(() => loading = false);
        safeSpacePassword.text = '';
        showFlushBar(context, 'Error occured during login', Icons.error);
        break;
    }
  }


  Route _routeToHome() {
    return PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) => SafeHome(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SafeHome(),
          );
        });
  }

  Route _routeToSignUp() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => Signup(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            transitionType: SharedAxisTransitionType.scaled,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: Signup(),
          );
        });
  }
}

class MobileClipPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LoginClipPath(),
      child: Container(
        color: Colors.teal,
        height: context.screenHeight * 0.6,
        width: context.screenWidth,
        child: Align(
          alignment: Alignment(0, -0.2),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/SafeSpace.png',
                  height: 60,
                  width: 50,
                  fit: BoxFit.cover,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                SizedBox(
                  child: Text(
                    'Safe Space',
                    style: Theme.of(context).textTheme.headline2
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class TabletClipPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      height: context.screenHeight * 0.5,
      width: context.screenWidth,
      child: Align(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/SafeSpace.png',
                height: 75,
                width: 70,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
              SizedBox(width: 4.w),
              SizedBox(
                child: Text(
                  'Safe Space',
                  style: Theme.of(context).textTheme.headline2
                ),
              ),
            ]),
      ),
    );
  }
}

class LoginClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, (size.height) - 10);
    var firstControlPoint = Offset(size.width / 15, size.height);
    var firstEndPoint = Offset(size.width / 8, size.height - (size.height / 17));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(
        size.width - (size.width / 2), size.height - (size.height / 2.5));
    var secondEndPoint = Offset(
        size.width - (size.width / 7), size.height - (size.height / 2.95));
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    var thirdControlPoint = Offset(
        size.width - (size.width / 20), size.height - (size.height / 3.2));
    var thirdEndPoint = Offset(size.width, size.height - (size.height / 3));
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
