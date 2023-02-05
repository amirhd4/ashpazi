import 'package:ashpazi/common/app.dart';
import 'package:flutter/material.dart';

class TextWidget {
  static Text splashText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: SplashScreenInfo.splashTextColor,
        fontSize: SplashScreenInfo.splashTextSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Text text(String text, {Color? color, double? fontSize}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: "bMitra",
        fontSize: fontSize ?? 25,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Text textBold(String text, {Color? color, double? fontSize}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: "bMitra",
        fontSize: fontSize ?? 23,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Text textItem(String text, {Color? color, double? fontSize}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color ?? Colors.grey.shade800,
        fontFamily: "bMitra",
        fontSize: fontSize ?? 21,
      ),
    );
  }
}
