import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static const Color _red = Color(0xFFE30613);

  static ThemeData get lightTheme => ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _red),
  );

  static ThemeData get darkTheme => ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _red,
      brightness: Brightness.dark,
    ),
  );
}
