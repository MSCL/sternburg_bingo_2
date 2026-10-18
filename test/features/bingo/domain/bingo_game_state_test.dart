import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_card.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_game_state.dart';

void main() {
  const CardId card1Id = CardId('1');
  const CardId card2Id = CardId('2');

  group('BingoGameState', () {
    test('defaults to empty cardCounts and collectedNumbers', () {
      const BingoGameState state = BingoGameState();

      expect(state.cardCounts, isEmpty);
      expect(state.collectedNumbers, isEmpty);
      expect(state.isWon, isFalse);
    });

    test('isWon returns false when no cards are possessed', () {
      const BingoGameState state = BingoGameState(
        collectedNumbers: <int, int>{3: 1, 27: 1, 36: 1, 89: 1, 70: 1},
      );

      expect(state.isWon, isFalse);
    });

    test('isWon returns false when card count is zero', () {
      const BingoGameState state = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 0},
        collectedNumbers: <int, int>{3: 1, 27: 1, 36: 1, 89: 1, 70: 1},
      );

      expect(state.isWon, isFalse);
    });

    group('isWon win detection for card 1', () {
      const BingoGameState card1State = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 1},
      );

      test('detects horizontal row wins', () {
        // Row 0: 3, 27, 36, 89, 70
        final BingoGameState row0 = card1State.copyWith(
          collectedNumbers: <int, int>{3: 1, 27: 1, 36: 1, 89: 1, 70: 1},
        );
        expect(row0.isWon, isTrue);

        // Row 4: 71, 13, 84, 5, 33
        final BingoGameState row4 = card1State.copyWith(
          collectedNumbers: <int, int>{71: 1, 13: 1, 84: 1, 5: 1, 33: 1},
        );
        expect(row4.isWon, isTrue);
      });

      test('detects vertical column wins', () {
        // Column 0: 3, 54, 19, 67, 71
        final BingoGameState col0 = card1State.copyWith(
          collectedNumbers: <int, int>{3: 1, 54: 1, 19: 1, 67: 1, 71: 1},
        );
        expect(col0.isWon, isTrue);

        // Column 4: 70, 48, 24, 98, 33
        final BingoGameState col4 = card1State.copyWith(
          collectedNumbers: <int, int>{70: 1, 48: 1, 24: 1, 98: 1, 33: 1},
        );
        expect(col4.isWon, isTrue);
      });

      test('detects diagonal wins', () {
        // Diagonal 1 (top-left to bottom-right): 3, 90, 2, 26, 33
        final BingoGameState diag1 = card1State.copyWith(
          collectedNumbers: <int, int>{3: 1, 90: 1, 2: 1, 26: 1, 33: 1},
        );
        expect(diag1.isWon, isTrue);

        // Diagonal 2 (top-right to bottom-left): 70, 11, 2, 30, 71
        final BingoGameState diag2 = card1State.copyWith(
          collectedNumbers: <int, int>{70: 1, 11: 1, 2: 1, 30: 1, 71: 1},
        );
        expect(diag2.isWon, isTrue);
      });

      test('returns false when line is incomplete', () {
        // 4 out of 5 numbers in row 0
        final BingoGameState incomplete = card1State.copyWith(
          collectedNumbers: <int, int>{3: 1, 27: 1, 36: 1, 89: 1},
        );
        expect(incomplete.isWon, isFalse);
      });
    });

    group('isWon win detection for card 2', () {
      const BingoGameState card2State = BingoGameState(
        cardCounts: <CardId, int>{card2Id: 1},
      );

      test('detects win on card 2 when possessed', () {
        // Row 0 of type2 card: 10, 81, 54, 29, 47
        final BingoGameState row0 = card2State.copyWith(
          collectedNumbers: <int, int>{10: 1, 81: 1, 54: 1, 29: 1, 47: 1},
        );
        expect(row0.isWon, isTrue);
        expect(row0.winningCombo?.card.id, card2Id);
      });
    });

    test('winningCombo returns correct card and numbers for winning line', () {
      const BingoGameState state = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 1},
        collectedNumbers: <int, int>{3: 1, 27: 1, 36: 1, 89: 1, 70: 1},
      );

      expect(state.winningCombo, isNotNull);
      expect(state.winningCombo!.card.id, card1Id);
      expect(state.winningCombo!.winningNumbers, <int>[3, 27, 36, 89, 70]);
    });

    test('serializes to and from JSON correctly', () {
      const BingoGameState original = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 2, card2Id: 1},
        collectedNumbers: <int, int>{3: 1, 27: 3},
      );

      final Map<String, Object?> json = original.toJson();
      final BingoGameState restored = BingoGameState.fromJson(json);

      expect(restored, equals(original));
      expect(restored.cardCounts[card1Id], 2);
      expect(restored.collectedNumbers[27], 3);
    });
  });
}
