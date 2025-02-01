import 'package:flutter/material.dart';

class AppTypography {
  static const TextStyle _commonStyle = TextStyle(fontFamily: 'Lexend');

  static TextStyle displaySmall =
      _commonStyle.copyWith(fontSize: 36, fontWeight: FontWeight.w700);

  static TextStyle headlineSmall =
      _commonStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle titleSmall =
      _commonStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle bodyLargeRegular = 
    _commonStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w200,);
}
