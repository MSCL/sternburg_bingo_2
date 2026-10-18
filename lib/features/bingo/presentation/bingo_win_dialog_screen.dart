import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../domain/bingo_game_state.dart';
import 'bingo_constants.dart';
import 'bingo_provider.dart';

@RoutePage()
final class BingoWinDialogScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BingoWinningCombo? combo = ref.watch(
      bingoProvider.select((BingoGameState state) => state.winningCombo),
    );

    if (combo == null) {
      return const SizedBox.shrink();
    }

    final String cardName = context.t.bingoCardName(id: combo.card.id.id);
    final String numbers = combo.winningNumbers
        .map(formatBingoNumber)
        .join(', ');

    return AlertDialog(
      title: Text(context.t.bingoWinDialogTitle),
      content: Text(
        context.t.bingoWinDialogMessage(cardName: cardName, numbers: numbers),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => unawaited(context.router.maybePop()),
          child: Text(context.t.bingoWinDialogOk),
        ),
        FilledButton(
          onPressed: () {
            unawaited(context.router.maybePop());
            unawaited(
              ref.read(bingoProvider.notifier).removeWinningCombo(combo),
            );
          },
          child: Text(context.t.bingoWinDialogRemove),
        ),
      ],
    );
  }
}
