import 'package:flutter/material.dart';
import 'package:restaurant_app/presentation/styles/typography/app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        colorScheme: ColorScheme.light(
            primary: const Color(0xFF262626),
            onPrimary: const Color(0xFFFCFCFC),
            tertiary: const Color.fromARGB(127, 38, 38, 38)),
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: _textTheme);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        colorScheme: ColorScheme.dark(
            primary: const Color(0xFFFCFCFC),
            onPrimary: const Color(0xFF262626),
            tertiary: const Color.fromARGB(127, 252, 252, 252)),
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: _textTheme);
  }

  static TextTheme get _textTheme {
    return TextTheme(
        displaySmall: AppTypography.displaySmall,
        headlineSmall: AppTypography.headlineSmall,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLargeRegular);
  }
}
