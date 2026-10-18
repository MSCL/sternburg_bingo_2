import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/i18n/strings.g.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../bingo_constants.dart';
import '../bingo_provider.dart';

final class BingoNumberInputCard extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BingoNumberInputCard> createState() =>
      _BingoNumberInputCardState();
}

final class _BingoNumberInputCardState
    extends ConsumerState<BingoNumberInputCard> {
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

    if (parsedNumber == null ||
        parsedNumber < bingoMinNumber ||
        parsedNumber > bingoMaxNumber) {
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: appSpacingMd,
        children: <Widget>[
          Text(
            context.t.bingoInputTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: appSpacingMd,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: bingoNumberPadLength,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: context.t.bingoInputHint,
                    errorText: _errorMessage,
                    counterText: '',
                  ),
                  onSubmitted: (_) => _submitNumber(),
                ),
              ),
              FilledButton.icon(
                onPressed: _submitNumber,
                icon: const Icon(Icons.add),
                label: Text(context.t.bingoAdd),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
