import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/bingo_repository.dart';
import '../domain/bingo_card.dart';
import '../domain/bingo_game_state.dart';

part 'bingo_provider.g.dart';

@riverpod
final class BingoNotifier extends _$BingoNotifier {
  @override
  BingoGameState build() => ref.watch(bingoRepositoryProvider).loadGameState();

  Future<void> incrementCardCount(CardId cardId) => _saveState(
    state.copyWith(cardCounts: _incrementMap(state.cardCounts, cardId)),
  );

  Future<void> decrementCardCount(CardId cardId) => _saveState(
    state.copyWith(cardCounts: _decrementMap(state.cardCounts, cardId)),
  );

  Future<void> addNumber(int number) {
    if (number < 1 || number > 99) {
      return Future<void>.value();
    }
    return _saveState(
      state.copyWith(
        collectedNumbers: _incrementMap(state.collectedNumbers, number),
      ),
    );
  }

  Future<void> decrementNumber(int number) => _saveState(
    state.copyWith(
      collectedNumbers: _decrementMap(state.collectedNumbers, number),
    ),
  );

  Future<void> _saveState(BingoGameState newState) {
    state = newState;
    return ref.read(bingoRepositoryProvider).saveGameState(newState);
  }

  static Map<T, int> _incrementMap<T>(Map<T, int> source, T key) {
    final Map<T, int> copy = Map<T, int>.from(source);
    copy[key] = (copy[key] ?? 0) + 1;
    return copy;
  }

  static Map<T, int> _decrementMap<T>(Map<T, int> source, T key) {
    final Map<T, int> copy = Map<T, int>.from(source);
    final int current = copy[key] ?? 0;
    if (current <= 1) {
      copy.remove(key);
    } else {
      copy[key] = current - 1;
    }
    return copy;
  }
}
