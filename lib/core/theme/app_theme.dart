// Static theme configuration class.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
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
