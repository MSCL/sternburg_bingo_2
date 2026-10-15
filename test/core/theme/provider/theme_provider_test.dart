import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sternburg_bingo_2/core/storage/local_storage.dart';
import 'package:sternburg_bingo_2/core/theme/provider/theme_provider.dart';

final class _FakeLocalStorage implements LocalStorage {
  new([Map<String, String>? initialData]) : _data = {...?initialData};

  final Map<String, String> _data;

  @override
  String? getString(String key) => _data[key];

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;
}

void main() {
  const themeKey = 'selected_theme_mode';
  const light = 'light';
  const dark = 'dark';

  ProviderContainer createContainer([LocalStorage? localStorage]) {
    final container = ProviderContainer(
      overrides: [
        localStorageProvider.overrideWithValue(
          localStorage ?? _FakeLocalStorage(),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ThemeModeNotifier', () {
    test('defaults to ThemeMode.system when no saved mode exists', () {
      final container = createContainer();
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('restores ThemeMode.light from local storage', () {
      final container = createContainer(_FakeLocalStorage({themeKey: light}));
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('restores ThemeMode.dark from local storage', () {
      final container = createContainer(_FakeLocalStorage({themeKey: dark}));
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('updates theme mode state and persists to local storage', () {
      final fakeStorage = _FakeLocalStorage();
      final container = createContainer(fakeStorage);
      final notifier = container.read(themeModeProvider.notifier);

      expect(container.read(themeModeProvider), ThemeMode.system);

      notifier.setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(fakeStorage.getString(themeKey), dark);

      notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(fakeStorage.getString(themeKey), light);
    });
  });
}
