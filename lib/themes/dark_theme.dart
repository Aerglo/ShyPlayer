import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'segoe',
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.lightBlue.shade200,
    onPrimary: Colors.grey,
    secondary: Colors.grey,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.black87,
    onBackground: Colors.grey.shade900,
    surface: Colors.grey,
    onSurface: Colors.grey,
  ),
);
