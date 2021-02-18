import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle appBarTextStyle = GoogleFonts.oswald(color: Colors.black,fontSize: RFontSize.appBarText,fontWeight: FontWeight.w300);
TextStyle logoTextStyleTeal = GoogleFonts.pacifico(color: Colors.teal,fontSize: RFontSize.xxxlarge);
TextStyle logoTextStyleWhite = logoTextStyleTeal.copyWith(color: Colors.white);
//for the list tile
TextStyle listTextStyle = TextStyle(fontSize: RFontSize.small);
//for the login/sign up buttons
TextStyle authTextStyle = GoogleFonts.oswald(color: Colors.white,fontSize: RFontSize.large);
TextStyle navigationDrawer = appBarTextStyle.copyWith(color: Colors.white,fontSize: RFontSize.medium);
//for the input dialog
TextStyle dialogTitle = appBarTextStyle.copyWith(fontSize: RFontSize.medium,fontWeight: FontWeight.w400);
//for list tile on tap dialog
TextStyle popupStyle = appBarTextStyle.copyWith(fontSize: RFontSize.medium);
//authentication text field
TextStyle authTextField = TextStyle(fontSize: 18.ssp);