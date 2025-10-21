import 'package:flutter/material.dart';

class AppTheme {

  static const primaryColor= Color(0xff2c3947);
  static const secondaryColor= Color(0xff6c757d);
  static const backColor= Color(0xfff8fbff);
  static const buttonsColor= Color(0xff8d9fb0);
  static const colorGeneral= Color.fromARGB(255, 248, 251, 255);
  static const cardColor= Color(0xfff8fbff);
  static const extraColor= Color.fromARGB(255, 237, 240, 243);
  static const greyColor= Color(0xffd4d6d8);
  static const forgottenColor= Color(0xfff4b898);

  

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color(0xff2c3947),
  ); 
}