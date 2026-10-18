import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/i18n/strings.g.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/bingo_repository.dart';
import '../../domain/bingo_card.dart';
import '../../domain/bingo_game_state.dart';
import '../bingo_constants.dart';
import '../bingo_provider.dart';

final class BingoGridSection extends ConsumerWidget {
  const new({required this.selectedCardTypeIndex, super.key});

  final int selectedCardTypeIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<BingoCard> availableCardTypes = ref
        .watch(bingoRepositoryProvider)
        .getAvailableCardTypes();

    if (availableCardTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    final int safeIndex = selectedCardTypeIndex.clamp(
      0,
      availableCardTypes.length - 1,
    );
    final BingoCard card = availableCardTypes[safeIndex];
    final String cardName = context.t.bingoCardName(id: card.id.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: appSpacingMd,
      children: <Widget>[
        Text(
          cardName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: bingoGridCrossAxisCount,
            crossAxisSpacing: appGridSpacing,
            mainAxisSpacing: appGridSpacing,
          ),
          itemCount: card.numbers.length,
          itemBuilder: (BuildContext context, int index) =>
              _BingoTileWidget(number: card.numbers[index]),
        ),
      ],
    );
  }
}

final class _BingoTileWidget extends ConsumerWidget {
  const new({required this.number});

  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isChecked = ref.watch(
      bingoProvider.select(
        (BingoGameState state) => (state.collectedNumbers[number] ?? 0) > 0,
      ),
    );

    final Color backgroundColor = isChecked
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final Color textColor = isChecked
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return AnimatedContainer(
      duration: appAnimationDuration,
      padding: const EdgeInsets.all(appSpacingXs),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: appBorderRadiusMd,
        border: Border.all(
          color: isChecked
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.outlineVariant,
          width: appBorderWidth,
        ),
      ),
      child: Center(
        child: Text(
          formatBingoNumber(number),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
