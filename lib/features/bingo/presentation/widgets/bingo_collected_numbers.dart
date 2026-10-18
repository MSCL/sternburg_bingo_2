import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/i18n/strings.g.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/bingo_game_state.dart';
import '../bingo_constants.dart';
import '../bingo_provider.dart';

final class BingoCollectedNumbersSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Map<int, int> collectedNumbers = ref.watch(
      bingoProvider.select((BingoGameState state) => state.collectedNumbers),
    );

    final List<MapEntry<int, int>> sortedEntries =
        collectedNumbers.entries.toList()..sort(
          (MapEntry<int, int> a, MapEntry<int, int> b) =>
              a.key.compareTo(b.key),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: appSpacingMd,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              context.t.bingoCollectedTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (sortedEntries.isNotEmpty)
              Text(
                context.t.bingoCollectedCount(
                  total: collectedNumbers.values.fold<int>(
                    0,
                    (int sum, int count) => sum + count,
                  ),
                  distinct: sortedEntries.length,
                ),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        if (sortedEntries.isEmpty)
          Card(
            color: theme.colorScheme.surfaceContainerLowest,
            child: Padding(
              padding: const EdgeInsets.all(appSpacingLg),
              child: Text(
                context.t.bingoCollectedEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Wrap(
            spacing: appSpacingSm,
            runSpacing: appSpacingSm,
            children: sortedEntries
                .map(
                  (MapEntry<int, int> entry) => _CollectedChip(
                    number: entry.key,
                    count: entry.value,
                    onIncrement: () => unawaited(
                      ref.read(bingoProvider.notifier).addNumber(entry.key),
                    ),
                    onDecrement: () => unawaited(
                      ref
                          .read(bingoProvider.notifier)
                          .decrementNumber(entry.key),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

final class _CollectedChip extends StatelessWidget {
  const new({
    required this.number,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int number;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: appSpacingSm,
        vertical: appSpacingXs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: appBorderRadiusXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: appSpacingXs,
        children: <Widget>[
          Text(
            formatBingoNumber(number),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: appSpacingXs,
              vertical: appSpacingXxs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: appBorderRadiusMd,
            ),
            child: Text(
              context.t.bingoCount(count: count),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: onDecrement,
            borderRadius: appBorderRadiusLg,
            child: Icon(
              Icons.remove_circle_outline,
              size: appIconSizeSmall,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          InkWell(
            onTap: onIncrement,
            borderRadius: appBorderRadiusLg,
            child: Icon(
              Icons.add_circle_outline,
              size: appIconSizeSmall,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
