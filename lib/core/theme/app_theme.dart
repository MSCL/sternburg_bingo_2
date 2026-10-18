import 'package:material_ui/material_ui.dart';

const double appSpacingXxs = 2;
const double appSpacingXs = 4;
const double appSpacingSm = 8;
const double appSpacingMd = 12;
const double appSpacingLg = 16;
const double appSpacingXl = 24;
const double appSpacingXxl = 32;

const double appButtonHeight = 48;
const double appIconSizeSmall = 18;
const double appBorderWidth = 1.5;
const double appGridSpacing = 6;
const Duration appAnimationDuration = Duration(milliseconds: 200);

final BorderRadius appBorderRadiusSm = BorderRadius.circular(appSpacingSm);
final BorderRadius appBorderRadiusMd = BorderRadius.circular(appSpacingMd);
final BorderRadius appBorderRadiusLg = BorderRadius.circular(appSpacingLg);
final BorderRadius appBorderRadiusXl = BorderRadius.circular(appSpacingXl);
final BorderRadius appBorderRadiusXxl = BorderRadius.circular(appSpacingXxl);

ThemeData _buildTheme(Brightness brightness) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFE30613),
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: appBorderRadiusLg,
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: appBorderWidth,
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: appBorderRadiusMd,
        borderSide: BorderSide(
          color: colorScheme.outline,
          width: appBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: appBorderRadiusMd,
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
          width: appBorderWidth,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: appSpacingMd,
        vertical: appSpacingMd,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: appBorderRadiusMd),
        minimumSize: const Size(0, appButtonHeight),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: appBorderRadiusMd),
      ),
    ),
    dialogTheme: const DialogThemeData(elevation: 0),
  );
}

final ThemeData appLightTheme = _buildTheme(Brightness.light);
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);
