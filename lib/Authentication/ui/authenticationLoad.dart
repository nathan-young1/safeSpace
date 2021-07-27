import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: SpinKitWave(
        color: Colors.teal,
        size: 70.h,
      ),)
    );
  }
}