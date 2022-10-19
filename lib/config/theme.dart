import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop/config/colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Palette.primaryMaterialColor,
  fontFamily: "poppins",
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(color: Colors.black, fontFamily: "poppins"),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: true,
      systemNavigationBarContrastEnforced: true,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
