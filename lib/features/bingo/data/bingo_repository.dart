import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/bingo_card.dart';
import '../domain/bingo_game_state.dart';
import 'bingo_local_data_source.dart';

abstract interface class BingoRepository {
  BingoGameState loadGameState();

  List<BingoCard> getAvailableCardTypes();

  Future<void> saveGameState(BingoGameState state);
}

final Provider<BingoRepository> bingoRepositoryProvider =
    Provider<BingoRepository>(
      (Ref ref) => BingoRepositoryImpl(ref.watch(bingoLocalDataSourceProvider)),
    );

final class BingoRepositoryImpl implements BingoRepository {
  const new(this._localDataSource);

  final BingoLocalDataSource _localDataSource;

  @override
  List<BingoCard> getAvailableCardTypes() => BingoCard.officialCards;

  @override
  BingoGameState loadGameState() =>
      _localDataSource.getSavedGameState() ?? const BingoGameState();

  @override
  Future<void> saveGameState(BingoGameState state) =>
      _localDataSource.saveGameState(state);
}
