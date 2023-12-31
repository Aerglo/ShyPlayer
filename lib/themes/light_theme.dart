import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'segoe',
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue.shade900,
    onPrimary: Colors.grey,
    secondary: Colors.black87,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.grey.shade200,
    onBackground: Colors.grey.shade400,
    surface: Colors.grey,
    onSurface: Colors.grey,
  ),
);
