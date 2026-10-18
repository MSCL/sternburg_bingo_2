import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/i18n/strings.g.dart';
import '../../../../core/theme/app_theme.dart';

final class BingoWinBanner extends ConsumerWidget {
  const new({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: appBorderRadiusLg,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(appSpacingLg),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: appBorderRadiusLg,
          ),
          child: Text(
            context.t.bingoWonMessage,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
