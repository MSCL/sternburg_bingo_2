import 'package:freezed_annotation/freezed_annotation.dart';

import 'bingo_card.dart';

part 'bingo_game_state.freezed.dart';
part 'bingo_game_state.g.dart';

final class BingoWinningCombo {
  const new({required this.card, required this.winningNumbers});

  final BingoCard card;
  final List<int> winningNumbers;
}

// for a feature this size, for now we re-use 1 model for all layers
@freezed
abstract class BingoGameState with _$BingoGameState {
  const factory({
    @CardIdMapConverter() @Default(<CardId, int>{}) Map<CardId, int> cardCounts,
    @Default(<int, int>{}) Map<int, int> collectedNumbers,
  }) = _BingoGameState;

  factory fromJson(Map<String, Object?> json) => _$BingoGameStateFromJson(json);

  const new _();

  // simple logic to check for a win, more advanced would be to not just
  // randomly take the first win but take the win which leaves the highest
  // potential for more wins in the future. you could have a look at all the
  // collected fields and numbers and make a more sophisticated decision.
  BingoWinningCombo? get winningCombo {
    for (final BingoCard card in BingoCard.officialCards) {
      final int count = cardCounts[card.id] ?? 0;
      if (count <= 0) {
        continue;
      }

      bool isChecked(int index) =>
          (collectedNumbers[card.numbers[index]] ?? 0) > 0;

      List<int> getComboNumbers(List<int> indices) =>
          indices.map((int idx) => card.numbers[idx]).toList();

      // 5 Rows
      for (int row = 0; row < 5; row++) {
        final int start = row * 5;
        final List<int> indices = <int>[
          start,
          start + 1,
          start + 2,
          start + 3,
          start + 4,
        ];
        if (indices.every(isChecked)) {
          return BingoWinningCombo(
            card: card,
            winningNumbers: getComboNumbers(indices),
          );
        }
      }

      // 5 Columns
      for (int col = 0; col < 5; col++) {
        final List<int> indices = <int>[
          col,
          col + 5,
          col + 10,
          col + 15,
          col + 20,
        ];
        if (indices.every(isChecked)) {
          return BingoWinningCombo(
            card: card,
            winningNumbers: getComboNumbers(indices),
          );
        }
      }

      // Diagonal 1 (top-left to bottom-right)
      const List<int> diag1 = <int>[0, 6, 12, 18, 24];
      if (diag1.every(isChecked)) {
        return BingoWinningCombo(
          card: card,
          winningNumbers: getComboNumbers(diag1),
        );
      }

      // Diagonal 2 (top-right to bottom-left)
      const List<int> diag2 = <int>[4, 8, 12, 16, 20];
      if (diag2.every(isChecked)) {
        return BingoWinningCombo(
          card: card,
          winningNumbers: getComboNumbers(diag2),
        );
      }
    }

    return null;
  }

  bool get isWon => winningCombo != null;
}
