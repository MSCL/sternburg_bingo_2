import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/features/bingo/data/bingo_local_data_source.dart';
import 'package:sternburg_bingo_2/features/bingo/data/bingo_repository.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_card.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_game_state.dart';

final class _FakeBingoLocalDataSource implements BingoLocalDataSource {
  new([this.savedState]);

  BingoGameState? savedState;

  @override
  BingoGameState? getSavedGameState() => savedState;

  @override
  Future<void> saveGameState(BingoGameState state) async => savedState = state;
}

void main() {
  const CardId card1Id = CardId('1');

  group('BingoRepositoryImpl', () {
    test('getAvailableCardTypes returns official cards', () {
      final _FakeBingoLocalDataSource dataSource = _FakeBingoLocalDataSource();
      final BingoRepositoryImpl repository = BingoRepositoryImpl(dataSource);

      expect(repository.getAvailableCardTypes(), BingoCard.officialCards);
    });

    test('loadGameState returns default state when no state is saved', () {
      final _FakeBingoLocalDataSource dataSource = _FakeBingoLocalDataSource();
      final BingoRepositoryImpl repository = BingoRepositoryImpl(dataSource);

      expect(repository.loadGameState(), const BingoGameState());
    });

    test('loadGameState returns saved state from local data source', () {
      const BingoGameState savedState = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 2},
      );
      final _FakeBingoLocalDataSource dataSource = _FakeBingoLocalDataSource(
        savedState,
      );
      final BingoRepositoryImpl repository = BingoRepositoryImpl(dataSource);

      expect(repository.loadGameState(), savedState);
    });

    test('saveGameState persists state to local data source', () async {
      final _FakeBingoLocalDataSource dataSource = _FakeBingoLocalDataSource();
      final BingoRepositoryImpl repository = BingoRepositoryImpl(dataSource);
      const BingoGameState stateToSave = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 1},
        collectedNumbers: <int, int>{7: 2},
      );

      await repository.saveGameState(stateToSave);

      expect(dataSource.savedState, stateToSave);
    });
  });
}
