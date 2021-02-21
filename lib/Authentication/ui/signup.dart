import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:password_strength/password_strength.dart';
import 'package:safeSpace/Application-ui/homePage.dart';
import 'package:safeSpace/Authentication/code/authentication.dart';
import 'package:safeSpace/Core-Services/enum.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Custom-widgets/flushBars.dart';
import 'package:safeSpace/Custom-widgets/passwordStrengthIndicator.dart';
import 'package:safeSpace/Custom-widgets/progressDialog.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _validateVaultKey(String value) {
    String pattern =  r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#=+!\$%&?(){}~_\\-\\.,^;:|#*]).{8,}$';
    RegExp regExp = new RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(value);
  }

  TextEditingController password;
  TextEditingController retypePassword;
  bool hideText = true;
  FocusNode masterPasswordFocus = FocusNode();
  FocusNode retypePasswordFocus = FocusNode();
  double passwordStrength = 0.0;
  Color passwordStrengthColor = Colors.transparent;
  bool agreementCheckBox;
  @override
    void initState() {
      super.initState();
      agreementCheckBox = false;
      //clears the password by creating new text editing controller on each init state
      password = TextEditingController(text: '');
      retypePassword  = TextEditingController(text: '');
    }
  @override
    void dispose() {
      super.dispose();
      password.dispose();
      retypePassword.dispose();
      masterPasswordFocus.dispose();
      retypePasswordFocus.dispose();
    }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: context.screenHeight,
            width: context.screenWidth,
            child: Column(
              children: [
                Stack(
                  children: [
                    (context.isMobileTypeHandset)
                    ?MobileClipPath()
                    :TabletClipPath(),
                  ]),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 250.w,
                            decoration: (context.isMobileTypeHandset)?authenticationContainerDecoration:null,
                            child: TextField(
                                focusNode: masterPasswordFocus,
                                obscureText: hideText,
                                controller: password,
                                style: authTextField,
                                onChanged: (value){
                                  setState(() {
                                    double strength = estimatePasswordStrength(value);
                                    if (value.length == 0) {
                                      passwordStrengthColor = Colors.transparent;
                                      passwordStrength = 0.0;
                                    } else if (strength <= 0.4 && strength > 0) {
                                      passwordStrengthColor = Colors.red;
                                      passwordStrength = 40.0;
                                    } else if (strength <= 0.7 && strength > 0.4) {
                                      passwordStrengthColor = Colors.yellow;
                                      passwordStrength = 70.0;
                                    } else if (strength <= 1 && strength > 0.7 && _validateVaultKey(value)) {
                                      passwordStrengthColor = Colors.teal;
                                      passwordStrength = 100.0;
                                    }
                                  });
                                },
                                onSubmitted: (value) => FocusScope.of(context).requestFocus(retypePasswordFocus),
                                decoration: (context.isMobileTypeHandset)
                                ?textInputDecorationForSafe.copyWith(
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                    (hideText)
                                    ?Icons.lock
                                    :Icons.lock_open,
                                    color: mainColor),
                                    onPressed: () =>  setState(() => hideText =! hideText),
                                  ),
                                  suffixIcon: PasswordStrengthIndicator(passwordStrength: passwordStrength, passwordStrengthColor: passwordStrengthColor),
                                  labelText: 'Create Vault Key',
                                )
                                :InputDecoration(
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                labelStyle:TextStyle(color: Colors.black, fontSize: 17.ssp),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                    icon: Icon(
                                    (hideText)
                                    ?Icons.lock
                                    :Icons.lock_open,
                                    color: mainColor),
                                    onPressed: () =>  setState(() => hideText =! hideText),
                                  ),
                                  ),
                                  suffixIcon: PasswordStrengthIndicator(passwordStrength: passwordStrength, passwordStrengthColor: passwordStrengthColor),
                                  labelText: 'Create Vault Key',
                                )),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 250.w,
                            decoration: (context.isMobileTypeHandset)?authenticationContainerDecoration:null,
                            child: TextField(
                                focusNode: retypePasswordFocus,
                                obscureText: hideText,
                                controller: retypePassword,
                                style: authTextField,
                                decoration: (context.isMobileTypeHandset)
                                ?textInputDecorationForSafe.copyWith(
                                prefixIcon: IconButton(
                                  icon: Icon( MdiIcons.lockReset, color: mainColor,size: 28),
                                  onPressed: () => setState(() => hideText =! hideText),
                                ),
                                labelText: 'Retype Vault Key')
                                :InputDecoration(
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                labelStyle:TextStyle(color: Colors.black, fontSize: 17.ssp),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon( MdiIcons.lockReset, color: mainColor,size: 18.w),
                                    onPressed: () => setState(() => hideText =! hideText),
                                  ),
                                ),
                                labelText: 'Retype Vault Key')),
                          ),
                          SizedBox(height: 15.h),
                            Container(
                              child: Flexible(
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                        activeColor: mainColor,
                                        value: agreementCheckBox,
                                        onChanged: (_)=>setState(()=> agreementCheckBox = !agreementCheckBox),
                                      ),
                                    ),
                                    Wrap(children:[
                                    Text('I agree to the ',
                                      style: TextStyle(fontSize: RFontSize.normal),),
                                    GestureDetector(
                                      onTap:() => Navigator.of(context).pushNamed('TermsOfService'),
                                      child: Text('Terms Of Service ',
                                      style: TextStyle(fontSize: RFontSize.normal,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor),)),
                                     Text('and ',
                                      style: TextStyle(fontSize: RFontSize.normal),),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pushNamed('PrivacyPolicy'),
                                      child: Text('Privacy Policy',
                                      style: TextStyle(fontSize: RFontSize.normal,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor))),
                                      Text('.',
                                      style: TextStyle(fontSize: RFontSize.normal),)
                          ]),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 15.h),
                          ButtonTheme(
                            minWidth: 100.w,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              onPressed: () {
                              if(passwordStrength == 100 && password.text == retypePassword.text){
                              registerSafe();
                              }else if(passwordStrength != 100){
                                showFlushBar(context,'Vault key is weak',MdiIcons.qualityLow);
                              }else if(password.text != retypePassword.text){
                                showFlushBar(context,'Vault keys do not match',MdiIcons.notEqual);
                              }
                              },
                              child: Text('Sign up',style: authTextStyle),
                              color: mainColor,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Already Signed In? ',style: TextStyle(fontSize: 16.ssp)),
                              GestureDetector(
                                  onTap: () =>  Navigator.of(context).pushReplacement(_routeToLogin()),
                                  child: Text('Login',style: TextStyle(color: secondaryColor, fontSize: 17.ssp)))
                            ],
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }


  registerSafe() async {
    progressDialog(buildContext: context,message: 'Setting Things Up',command: ProgressDialogVisiblity.show);
    Authentication result = await signInWithEmailAndPassword(password.text,context);
    progressDialog(buildContext: context,command: ProgressDialogVisiblity.hide);
    switch (result) {
      case Authentication.Successful:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', email);
        password.text = '';
        retypePassword.text='';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SafeHome()));
        break;
      case Authentication.EmailExists:
        showFlushBar(context,'Email already exists',MdiIcons.emailRemove);
        break;
      case Authentication.Error:
        showFlushBar(context,'Error occured during signup',Icons.error);
        break;
      default:
        showFlushBar(context,'Error occured during signup',Icons.error);
        break;
    }
  }


  Route _routeToLogin() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => Login(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            transitionType: SharedAxisTransitionType.scaled,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: Login(),
          );
        });
  }
}

class MobileClipPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        color: mainColor,
        height: context.screenHeight / 1.9,
        width: context.screenWidth,
        child: Align(
          alignment: Alignment(0, -0.3),
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
                SizedBox(width: 2),
                SizedBox(
                  child: Text(
                    'Safe Space',
                    style: Theme.of(context).textTheme.headline2
                  ),
                ),
              ]),
        ),
      ),
      clipper: SignupClipPath(),
    );
  }
}

class TabletClipPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      height: context.screenHeight * 0.5,
      width: context.screenWidth,
      child: Align(
        child: Image.asset(
          'assets/images/SafeSpace.png',
          height: 80.h,
          width: 60.w,
          fit: BoxFit.fill,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SignupClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, (size.height) / 1.55);
    var firstControlPoint = Offset(size.width / 15, size.height / 1.45);
    var firstEndPoint = Offset(size.width / 6, size.height - (size.height / 3));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(
        size.width - (size.width / 2), size.height - (size.height / 2.7));
    var secondEndPoint =
        Offset(size.width - (size.width / 5), size.height - (size.height / 5));
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    var thirdControlPoint =
        Offset(size.width - (size.width / 10), size.height - (size.height / 7));
    var thirdEndPoint = Offset(size.width, size.height - (size.height / 6));
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
