import 'package:flutter_screenutil/screenutil.dart';

class RFontSize{
  static double small = ScreenUtil().setSp(15,allowFontScalingSelf: true);
  static double normal = ScreenUtil().setSp(20,allowFontScalingSelf: true);
  static double medium = ScreenUtil().setSp(25,allowFontScalingSelf: true);
  static double large = ScreenUtil().setSp(28,allowFontScalingSelf: true);
  static double xxlarge = ScreenUtil().setSp(30,allowFontScalingSelf: true);
  static double xxxlarge = ScreenUtil().setSp(39,allowFontScalingSelf: true);
  static double appBarText = ScreenUtil().setSp(25,allowFontScalingSelf: true);
}