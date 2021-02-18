import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    Key key,
    @required this.passwordStrength,
    @required this.passwordStrengthColor,
  }) : super(key: key);

  final double passwordStrength;
  final Color passwordStrengthColor;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (_, snapshot) {
      return ButtonTheme(
        height: 10.h,
        minWidth: 30.w,
        child: Transform.scale(
          scale: 0.5.r,
          child: Tooltip(
            message: 'Password Strength Checker',
            child: IgnorePointer(
              ignoring: true,
              child: SleekCircularSlider(
                initialValue: passwordStrength,
                appearance: CircularSliderAppearance(
                    infoProperties: null,
                    size: 1,
                    angleRange: 360,
                    customWidths: CustomSliderWidths(progressBarWidth: 5, handlerSize: 0.0),
                    customColors: CustomSliderColors(
                        hideShadow: true,
                        dotColor: Colors.transparent,
                        trackColor: Colors.transparent,
                        progressBarColor: passwordStrengthColor)),
                min: 0,
                max: 100,
              ),
            ),
          ),
        ),
      );
    });
  }
}