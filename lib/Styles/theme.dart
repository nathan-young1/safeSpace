import 'package:flutter/material.dart';
import 'package:safeSpace/Styles/textStyle.dart';

AppBarTheme appBarTheme = AppBarTheme(
iconTheme: IconThemeData(color: Colors.black,size: 32),
color: Colors.white,
centerTitle: true,
textTheme: TextTheme(headline1: appBarTextStyle)
);
TextTheme textTheme = TextTheme(
headline1: logoTextStyleTeal,
headline2: logoTextStyleWhite);