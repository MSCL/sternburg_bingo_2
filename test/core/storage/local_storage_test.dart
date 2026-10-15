import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sternburg_bingo_2/core/storage/local_storage.dart';

final class _FakeSharedPreferencesWithCache extends Fake
    implements SharedPreferencesWithCache {
  final Map<String, String> _store = {};

  @override
  String? getString(String key) => _store[key];

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;
}

void main() {
  const testKey = 'test_key';
  const testValue = 'test_value';
  const themeKey = 'theme';
  const lightValue = 'light';
  const darkValue = 'dark';

  group('SharedPreferencesLocalStorage', () {
    late SharedPreferencesLocalStorage localStorage;

    setUp(() {
      localStorage = SharedPreferencesLocalStorage(
        _FakeSharedPreferencesWithCache(),
      );
    });

    test('returns null when key is not found in storage', () {
      expect(localStorage.getString('non_existent_key'), isNull);
    });

    test('stores and retrieves string values correctly', () async {
      await localStorage.setString(testKey, testValue);
      expect(localStorage.getString(testKey), testValue);
    });

    test('overwrites existing values when setString is called again', () async {
      await localStorage.setString(themeKey, lightValue);
      expect(localStorage.getString(themeKey), lightValue);

      await localStorage.setString(themeKey, darkValue);
      expect(localStorage.getString(themeKey), darkValue);
    });
  });
}
