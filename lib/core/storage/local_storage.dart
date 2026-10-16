import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/provider_utils.dart';

abstract interface class LocalStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);

  bool? getBool(String key);

  Future<void> setBool(String key, {required bool value});
}

/// Provider for [LocalStorage]. Must be overridden in [ProviderScope].
final Provider<LocalStorage> localStorageProvider = Provider<LocalStorage>(
  (Ref ref) => throwUnimplementedProviderError('localStorageProvider'),
);

final class SharedPreferencesLocalStorage implements LocalStorage {
  const new(this._prefs);

  final SharedPreferencesWithCache _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);
}
