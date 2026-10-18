import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/features/bingo/data/bingo_local_data_source.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_card.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_game_state.dart';

import '../../../fakes/fake_local_storage.dart';

void main() {
  const String storageKey = 'bingo_game_state_json';
  const CardId card1Id = CardId('1');

  group('BingoLocalDataSourceImpl', () {
    test('returns null when no saved game state exists in storage', () {
      final FakeLocalStorage fakeStorage = FakeLocalStorage();
      final BingoLocalDataSourceImpl dataSource = BingoLocalDataSourceImpl(
        fakeStorage,
      );

      expect(dataSource.getSavedGameState(), isNull);
    });

    test('returns saved BingoGameState when valid JSON exists in storage', () {
      const BingoGameState storedState = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 3},
        collectedNumbers: <int, int>{3: 1, 27: 2},
      );
      final FakeLocalStorage fakeStorage = FakeLocalStorage(<String, Object>{
        storageKey: jsonEncode(storedState.toJson()),
      });
      final BingoLocalDataSourceImpl dataSource = BingoLocalDataSourceImpl(
        fakeStorage,
      );

      final BingoGameState? loadedState = dataSource.getSavedGameState();

      expect(loadedState, equals(storedState));
    });

    test(
      'encodes state to JSON and persists to local storage when saved',
      () async {
        final FakeLocalStorage fakeStorage = FakeLocalStorage();
        final BingoLocalDataSourceImpl dataSource = BingoLocalDataSourceImpl(
          fakeStorage,
        );
        const BingoGameState stateToSave = BingoGameState(
          cardCounts: <CardId, int>{card1Id: 1},
          collectedNumbers: <int, int>{54: 1},
        );

        await dataSource.saveGameState(stateToSave);

        final String? rawJson = fakeStorage.getString(storageKey);
        expect(rawJson, isNotNull);

        final Map<String, Object?> jsonMap =
            jsonDecode(rawJson!) as Map<String, Object?>;
        expect(BingoGameState.fromJson(jsonMap), equals(stateToSave));
      },
    );
  });
}
