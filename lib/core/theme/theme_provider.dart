import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/local_storage.dart';

part 'theme_provider.g.dart';

@riverpod
final class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const String _themeKey = 'selected_theme_mode';

  @override
  ThemeMode build() {
    final String? savedMode = ref
        .read(localStorageProvider)
        .getString(_themeKey);
    if (savedMode == ThemeMode.light.name) {
      return ThemeMode.light;
    } else if (savedMode == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    unawaited(ref.read(localStorageProvider).setString(_themeKey, state.name));
  }
}
