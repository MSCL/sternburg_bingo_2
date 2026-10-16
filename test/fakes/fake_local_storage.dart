import 'package:sternburg_bingo_2/core/storage/local_storage.dart';

/// In-memory [LocalStorage] implementation for unit and widget tests.
final class FakeLocalStorage implements LocalStorage {
  new([Map<String, Object>? initialData])
    : _data = <String, Object>{...?initialData};

  final Map<String, Object> _data;

  @override
  String? getString(String key) => switch (_data[key]) {
    final String val => val,
    _ => null,
  };

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;

  @override
  bool? getBool(String key) => switch (_data[key]) {
    final bool val => val,
    _ => null,
  };

  @override
  Future<void> setBool(String key, {required bool value}) async =>
      _data[key] = value;
}
