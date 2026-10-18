import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/i18n/strings.g.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/bingo_repository.dart';
import '../../domain/bingo_card.dart';
import '../../domain/bingo_game_state.dart';
import '../bingo_provider.dart';

final class BingoCardListSection extends ConsumerWidget {
  const new({
    required this.selectedCardTypeIndex,
    required this.onSelectCardType,
    super.key,
  });

  final int selectedCardTypeIndex;
  final ValueChanged<int> onSelectCardType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<BingoCard> availableCardTypes = ref
        .watch(bingoRepositoryProvider)
        .getAvailableCardTypes();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(appSpacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: appSpacingMd,
          children: <Widget>[
            Text(
              context.t.bingoCardTypesTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              spacing: appSpacingSm,
              children: List<Widget>.generate(availableCardTypes.length, (
                int index,
              ) {
                final BingoCard card = availableCardTypes[index];
                final bool isSelected = selectedCardTypeIndex == index;

                return _CardTypeTile(
                  card: card,
                  index: index,
                  isSelected: isSelected,
                  onSelect: () => onSelectCardType(index),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CardTypeTile extends ConsumerWidget {
  const new({
    required this.card,
    required this.index,
    required this.isSelected,
    required this.onSelect,
  });

  final BingoCard card;
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final int count = ref.watch(
      bingoProvider.select(
        (BingoGameState state) => state.cardCounts[card.id] ?? 0,
      ),
    );
    final String cardName = context.t.bingoCardName(id: card.id.id);

    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: appBorderRadiusLg,
      child: InkWell(
        borderRadius: appBorderRadiusLg,
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: appSpacingLg,
            vertical: appSpacingSm,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected ? Icons.grid_on : Icons.grid_on_outlined,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: appSpacingMd),
              Expanded(
                child: Text(
                  cardName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              _QuantityCounter(
                count: count,
                isSelected: isSelected,
                onDecrement: count > 0
                    ? () => unawaited(
                        ref
                            .read(bingoProvider.notifier)
                            .decrementCardCount(card.id),
                      )
                    : null,
                onIncrement: () => unawaited(
                  ref.read(bingoProvider.notifier).incrementCardCount(card.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _QuantityCounter extends StatelessWidget {
  const new({
    required this.count,
    required this.isSelected,
    required this.onIncrement,
    this.onDecrement,
  });

  final int count;
  final bool isSelected;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onDecrement,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: appSpacingSm,
            vertical: appSpacingXs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
            borderRadius: appBorderRadiusLg,
          ),
          child: Text(
            context.t.bingoCount(count: count),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
