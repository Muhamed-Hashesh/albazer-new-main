import 'package:albazar_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColor.coverPageColor,
    brightness: Brightness.light,
    secondaryHeaderColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    highlightColor: const Color(0xFFF6F9FF),
    shadowColor: const Color(0x3F000000),
    focusColor: const Color(0xff1D1D1B),
    hoverColor: Colors.black,
    cardColor: const Color(0xFFF6F9FF),
    canvasColor: const Color(0xFF1E1E1E),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xff9C9C9C),
    brightness: Brightness.dark,
    secondaryHeaderColor: const Color(0xFF1D1D1B),
    scaffoldBackgroundColor: const Color(0xFF1D1D1B),
    highlightColor: Colors.black,
    shadowColor: const Color.fromARGB(255, 48, 48, 48),
    focusColor: Colors.white,
    hoverColor: Colors.white,
    cardColor: const Color(0xFF1D1D1B),
    canvasColor: Colors.white,
  );
}
