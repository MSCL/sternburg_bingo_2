import 'package:freezed_annotation/freezed_annotation.dart';

import 'bingo_card.dart';

part 'bingo_game_state.freezed.dart';
part 'bingo_game_state.g.dart';

// for a feature this size, for now we re-use 1 model for all layers
@freezed
abstract class BingoGameState with _$BingoGameState {
  const factory({
    @CardIdMapConverter() @Default(<CardId, int>{}) Map<CardId, int> cardCounts,
    @Default(<int, int>{}) Map<int, int> collectedNumbers,
  }) = _BingoGameState;

  factory fromJson(Map<String, Object?> json) => _$BingoGameStateFromJson(json);

  const new _();

  bool get isWon {
    for (final BingoCard card in BingoCard.officialCards) {
      final int count = cardCounts[card.id] ?? 0;
      if (count > 0 && _checkCardWon(card.numbers)) {
        return true;
      }
    }
    return false;
  }

  bool _checkCardWon(List<int> numbers) {
    bool isChecked(int index) => (collectedNumbers[numbers[index]] ?? 0) > 0;

    // 5 Rows
    for (int row = 0; row < 5; row++) {
      final int start = row * 5;
      if (isChecked(start) &&
          isChecked(start + 1) &&
          isChecked(start + 2) &&
          isChecked(start + 3) &&
          isChecked(start + 4)) {
        return true;
      }
    }

    // 5 Columns
    for (int col = 0; col < 5; col++) {
      if (isChecked(col) &&
          isChecked(col + 5) &&
          isChecked(col + 10) &&
          isChecked(col + 15) &&
          isChecked(col + 20)) {
        return true;
      }
    }

    // Diagonal 1 (top-left to bottom-right)
    if (isChecked(0) &&
        isChecked(6) &&
        isChecked(12) &&
        isChecked(18) &&
        isChecked(24)) {
      return true;
    }

    // Diagonal 2 (top-right to bottom-left)
    if (isChecked(4) &&
        isChecked(8) &&
        isChecked(12) &&
        isChecked(16) &&
        isChecked(20)) {
      return true;
    }

    return false;
  }
}
