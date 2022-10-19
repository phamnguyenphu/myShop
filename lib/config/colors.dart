import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF583bb8); // #22CB0C, #583bb8, #421e15
const Color buttonColor = Color(0xFF583bb8);

const Color accentColor = Color(0xFFf39c12); // #583bb8, #f39c12, #fc5f53

final Color tileColor = Colors.green[100]!;

class Palette {
  static const MaterialColor primaryMaterialColor = MaterialColor(
    0xFF583bb8,
    <int, Color>{
      50: Color(0xFF583bb8), //10%
      100: Color(0xFF583bb8), //20%
      200: Color(0xFF583bb8), //30%
      300: Color(0xFF583bb8), //40%
      400: Color(0xFF583bb8), //50%
      500: Color(0xFF583bb8), //60%
      600: Color(0xFF583bb8), //70%
      700: Color(0xFF583bb8), //80%
      800: Color(0xFF583bb8), //90%
      900: Color(0xFF583bb8), //100%
    },
  );
}
