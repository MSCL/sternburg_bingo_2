import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);
}

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope!');
});

class SharedPreferencesLocalStorage implements LocalStorage {
  const new(this._prefs);

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}
