import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/bingo_game_state.dart';
import 'bingo_constants.dart';
import 'bingo_provider.dart';
import 'widgets/bingo_card_list.dart';
import 'widgets/bingo_collected_numbers.dart';
import 'widgets/bingo_grid.dart';
import 'widgets/bingo_input.dart';
import 'widgets/bingo_win_banner.dart';

@RoutePage()
final class BingoScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BingoScreen> createState() => _BingoScreenState();
}

final class _BingoScreenState extends ConsumerState<BingoScreen> {
  int _selectedCardTypeIndex = 0;
  bool _isWinDialogShowing = false;

  Future<void> _showWinDialog() async {
    if (_isWinDialogShowing || !mounted) {
      return;
    }

    final BingoWinningCombo? combo = ref.read(bingoProvider).winningCombo;
    if (combo == null) {
      return;
    }

    final String cardName = context.t.bingoCardName(id: combo.card.id.id);
    final String numbers = combo.winningNumbers
        .map(formatBingoNumber)
        .join(', ');

    _isWinDialogShowing = true;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(context.t.bingoWinDialogTitle),
        content: Text(
          context.t.bingoWinDialogMessage(cardName: cardName, numbers: numbers),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => unawaited(dialogContext.router.maybePop()),
            child: Text(context.t.bingoWinDialogOk),
          ),
          FilledButton(
            onPressed: () {
              unawaited(dialogContext.router.maybePop());
              unawaited(
                ref.read(bingoProvider.notifier).removeWinningCombo(combo),
              );
            },
            child: Text(context.t.bingoWinDialogRemove),
          ),
        ],
      ),
    );
    _isWinDialogShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(
      bingoProvider.select((BingoGameState state) => state.isWon),
      (bool? previous, bool next) {
        if ((previous == null || !previous) && next) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            unawaited(_showWinDialog());
          });
        }
      },
    );

    final bool isWon = ref.watch(
      bingoProvider.select((BingoGameState state) => state.isWon),
    );

    return AppScaffold(
      title: context.t.bingoTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(appSpacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: appSpacingXl,
          children: <Widget>[
            if (isWon) BingoWinBanner(onTap: () => unawaited(_showWinDialog())),
            BingoCardListSection(
              selectedCardTypeIndex: _selectedCardTypeIndex,
              onSelectCardType: (int index) =>
                  setState(() => _selectedCardTypeIndex = index),
            ),
            BingoGridSection(selectedCardTypeIndex: _selectedCardTypeIndex),
            const BingoNumberInputCard(),
            const BingoCollectedNumbersSection(),
          ],
        ),
      ),
    );
  }
}
