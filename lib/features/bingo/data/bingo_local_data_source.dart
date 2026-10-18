import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage.dart';
import '../domain/bingo_game_state.dart';

abstract interface class BingoLocalDataSource {
  BingoGameState? getSavedGameState();

  Future<void> saveGameState(BingoGameState state);
}

final Provider<BingoLocalDataSource> bingoLocalDataSourceProvider =
    Provider<BingoLocalDataSource>(
      (Ref ref) => BingoLocalDataSourceImpl(ref.watch(localStorageProvider)),
    );

final class BingoLocalDataSourceImpl implements BingoLocalDataSource {
  const new(this._localStorage);

  final LocalStorage _localStorage;

  static const String _gameStateStorageKey = 'bingo_game_state_json';

  @override
  BingoGameState? getSavedGameState() {
    final String? stored = _localStorage.getString(_gameStateStorageKey);
    if (stored != null) {
      return BingoGameState.fromJson(
        jsonDecode(stored) as Map<String, Object?>,
      );
    }
    return null;
  }

  @override
  Future<void> saveGameState(BingoGameState state) =>
      _localStorage.setString(_gameStateStorageKey, jsonEncode(state.toJson()));
}
