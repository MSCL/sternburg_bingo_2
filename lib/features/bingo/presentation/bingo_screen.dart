import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../data/bingo_repository.dart';
import '../domain/bingo_card.dart';
import '../domain/bingo_game_state.dart';
import 'bingo_provider.dart';

String _getCardName(BuildContext context, int cardTypeIndex) =>
    switch (cardTypeIndex) {
      0 => context.t.bingoCard1Name,
      1 => context.t.bingoCard2Name,
      _ => 'Bingo-Karte #${cardTypeIndex + 1}',
    };

@RoutePage()
final class BingoScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BingoScreen> createState() => _BingoScreenState();
}

final class _BingoScreenState extends ConsumerState<BingoScreen> {
  int _selectedCardTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final BingoGameState gameState = ref.watch(bingoProvider);
    final List<BingoCard> availableCardTypes = ref
        .watch(bingoRepositoryProvider)
        .getAvailableCardTypes();

    final int safeSelectedTypeIndex = availableCardTypes.isEmpty
        ? 0
        : _selectedCardTypeIndex.clamp(0, availableCardTypes.length - 1);

    final BingoCard? selectedCard = availableCardTypes.isNotEmpty
        ? availableCardTypes[safeSelectedTypeIndex]
        : null;

    final int ownedCountOfSelected = selectedCard != null
        ? (gameState.cardCounts[selectedCard.id] ?? 0)
        : 0;

    return Scaffold(
      appBar: AppBar(title: Text(context.t.bingoTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (gameState.isWon) ...<Widget>[
                const _WinBannerWidget(),
                const SizedBox(height: 16),
              ],
              _CardTypesListWidget(
                availableCardTypes: availableCardTypes,
                cardCounts: gameState.cardCounts,
                selectedCardTypeIndex: safeSelectedTypeIndex,
                onSelectCardType: (int index) =>
                    setState(() => _selectedCardTypeIndex = index),
              ),
              const SizedBox(height: 24),
              if (selectedCard != null) ...<Widget>[
                _BingoGridWidget(
                  cardName: _getCardName(context, safeSelectedTypeIndex),
                  card: selectedCard,
                  ownedCount: ownedCountOfSelected,
                  collectedNumbers: gameState.collectedNumbers,
                ),
                const SizedBox(height: 24),
              ],
              const _NumberInputCard(),
              const SizedBox(height: 24),
              _CollectedNumbersWidget(
                collectedNumbers: gameState.collectedNumbers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WinBannerWidget extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red.shade700,
      borderRadius: BorderRadius.circular(12),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.red.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      context.t.bingoWonMessage,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

final class _CardTypesListWidget extends ConsumerWidget {
  const new({
    required this.availableCardTypes,
    required this.cardCounts,
    required this.selectedCardTypeIndex,
    required this.onSelectCardType,
  });

  final List<BingoCard> availableCardTypes;
  final Map<CardId, int> cardCounts;
  final int selectedCardTypeIndex;
  final ValueChanged<int> onSelectCardType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              context.t.bingoCardTypesTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: List<Widget>.generate(availableCardTypes.length, (
                int index,
              ) {
                final BingoCard card = availableCardTypes[index];
                final int count = cardCounts[card.id] ?? 0;
                final bool isSelected = selectedCardTypeIndex == index;
                final String cardName = _getCardName(context, index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onSelectCardType(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              isSelected
                                  ? Icons.grid_on
                                  : Icons.grid_on_outlined,
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  iconSize: 20,
                                  onPressed: count > 0
                                      ? () => unawaited(
                                          ref
                                              .read(bingoProvider.notifier)
                                              .decrementCardCount(card.id),
                                        )
                                      : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${count}x',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  iconSize: 20,
                                  onPressed: () => unawaited(
                                    ref
                                        .read(bingoProvider.notifier)
                                        .incrementCardCount(card.id),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

final class _NumberInputCard extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_NumberInputCard> createState() => _NumberInputCardState();
}

final class _NumberInputCardState extends ConsumerState<_NumberInputCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitNumber() {
    final String rawInput = _controller.text.trim();
    final int? parsedNumber = int.tryParse(rawInput);

    if (parsedNumber == null || parsedNumber < 1 || parsedNumber > 99) {
      setState(() => _errorMessage = context.t.bingoInputError);
      return;
    }

    setState(() => _errorMessage = null);
    unawaited(ref.read(bingoProvider.notifier).addNumber(parsedNumber));
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              context.t.bingoInputTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: context.t.bingoInputHint,
                      errorText: _errorMessage,
                      counterText: '',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _submitNumber(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _submitNumber,
                    icon: const Icon(Icons.add),
                    label: Text(context.t.bingoAdd),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _BingoGridWidget extends StatelessWidget {
  const new({
    required this.cardName,
    required this.card,
    required this.ownedCount,
    required this.collectedNumbers,
  });

  final String cardName;
  final BingoCard card;
  final int ownedCount;
  final Map<int, int> collectedNumbers;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              cardName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ownedCount > 0
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${ownedCount}x im Besitz',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ownedCount > 0
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: card.numbers.length,
          itemBuilder: (BuildContext context, int index) {
            final int number = card.numbers[index];
            final bool isChecked = (collectedNumbers[number] ?? 0) > 0;
            return _BingoTileWidget(number: number, isChecked: isChecked);
          },
        ),
      ],
    );
  }
}

final class _BingoTileWidget extends StatelessWidget {
  const new({required this.number, required this.isChecked});

  final int number;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = isChecked
        ? Colors.red.shade800
        : theme.colorScheme.surfaceContainerHighest;
    final Color textColor = isChecked
        ? Colors.white
        : theme.colorScheme.onSurface;
    final String formattedNumber = number.toString().padLeft(2, '0');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked
              ? Colors.red.shade900
              : theme.colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          formattedNumber,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

final class _CollectedNumbersWidget extends ConsumerWidget {
  const new({required this.collectedNumbers});

  final Map<int, int> collectedNumbers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final List<MapEntry<int, int>> sortedEntries =
        collectedNumbers.entries.toList()..sort(
          (MapEntry<int, int> a, MapEntry<int, int> b) =>
              a.key.compareTo(b.key),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Badge(
                label: Text('${sortedEntries.length}'),
                backgroundColor: theme.colorScheme.primary,
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (sortedEntries.isEmpty)
          Card(
            color: theme.colorScheme.surfaceContainerLowest,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
            spacing: 8,
            runSpacing: 8,
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
    final String formattedNumber = number.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            formattedNumber,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${count}x',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDecrement,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.remove_circle_outline,
              size: 18,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.add_circle_outline,
              size: 18,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
