import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/features/bingo/data/bingo_repository.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_card.dart';
import 'package:sternburg_bingo_2/features/bingo/domain/bingo_game_state.dart';
import 'package:sternburg_bingo_2/features/bingo/presentation/bingo_provider.dart';

final class _FakeBingoRepository implements BingoRepository {
  new([this.state = const BingoGameState()]);

  BingoGameState state;

  @override
  List<BingoCard> getAvailableCardTypes() => BingoCard.officialCards;

  @override
  BingoGameState loadGameState() => state;

  @override
  Future<void> saveGameState(BingoGameState state) async => this.state = state;
}

void main() {
  const CardId card1Id = CardId('1');
  const CardId card2Id = CardId('2');

  (ProviderContainer, _FakeBingoRepository) createContainer({
    BingoGameState initialGameState = const BingoGameState(),
  }) {
    final _FakeBingoRepository repository = _FakeBingoRepository(
      initialGameState,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        bingoRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return (container, repository);
  }

  group('BingoNotifier', () {
    test('build loads initial state from repository', () {
      const BingoGameState initial = BingoGameState(
        cardCounts: <CardId, int>{card1Id: 2},
      );
      final (ProviderContainer container, _) = createContainer(
        initialGameState: initial,
      );

      final BingoGameState state = container.read(bingoProvider);

      expect(state, initial);
    });

    test(
      'incrementCardCount increments card count and persists to repository',
      () async {
        final (ProviderContainer container, _FakeBingoRepository repository) =
            createContainer();
        final BingoNotifier notifier = container.read(bingoProvider.notifier);

        await notifier.incrementCardCount(card1Id);

        final BingoGameState state1 = container.read(bingoProvider);
        expect(state1.cardCounts[card1Id], 1);
        expect(repository.state, state1);

        await notifier.incrementCardCount(card1Id);

        final BingoGameState state2 = container.read(bingoProvider);
        expect(state2.cardCounts[card1Id], 2);
        expect(repository.state, state2);
      },
    );

    test(
      'decrementCardCount decrements card count and removes when <= 1',
      () async {
        const BingoGameState initial = BingoGameState(
          cardCounts: <CardId, int>{card1Id: 2, card2Id: 1},
        );
        final (ProviderContainer container, _FakeBingoRepository repository) =
            createContainer(initialGameState: initial);
        final BingoNotifier notifier = container.read(bingoProvider.notifier);

        await notifier.decrementCardCount(card1Id);
        final BingoGameState state1 = container.read(bingoProvider);
        expect(state1.cardCounts[card1Id], 1);

        await notifier.decrementCardCount(card2Id);
        final BingoGameState state2 = container.read(bingoProvider);
        expect(state2.cardCounts.containsKey(card2Id), isFalse);
        expect(repository.state, state2);
      },
    );

    test('addNumber adds valid number count and persists', () async {
      final (ProviderContainer container, _FakeBingoRepository repository) =
          createContainer();
      final BingoNotifier notifier = container.read(bingoProvider.notifier);

      await notifier.addNumber(42);

      final BingoGameState state1 = container.read(bingoProvider);
      expect(state1.collectedNumbers[42], 1);
      expect(repository.state, state1);

      await notifier.addNumber(42);

      final BingoGameState state2 = container.read(bingoProvider);
      expect(state2.collectedNumbers[42], 2);
    });

    test('addNumber ignores numbers less than 1 or greater than 99', () async {
      final (ProviderContainer container, _FakeBingoRepository repository) =
          createContainer();
      final BingoNotifier notifier = container.read(bingoProvider.notifier);

      await notifier.addNumber(0);
      await notifier.addNumber(-5);
      await notifier.addNumber(100);

      final BingoGameState state = container.read(bingoProvider);
      expect(state.collectedNumbers, isEmpty);
      expect(repository.state, const BingoGameState());
    });

    test(
      'decrementNumber decrements collected number and removes when <= 1',
      () async {
        const BingoGameState initial = BingoGameState(
          collectedNumbers: <int, int>{10: 2, 20: 1},
        );
        final (ProviderContainer container, _FakeBingoRepository repository) =
            createContainer(initialGameState: initial);
        final BingoNotifier notifier = container.read(bingoProvider.notifier);

        await notifier.decrementNumber(10);
        final BingoGameState state1 = container.read(bingoProvider);
        expect(state1.collectedNumbers[10], 1);

        await notifier.decrementNumber(20);
        final BingoGameState state2 = container.read(bingoProvider);
        expect(state2.collectedNumbers.containsKey(20), isFalse);
        expect(repository.state, state2);
      },
    );
  });
}
