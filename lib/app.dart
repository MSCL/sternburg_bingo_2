import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/provider/theme_provider.dart';
import 'features/home/presentation/home_screen.dart';

class SternburgBingoApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    title: 'Sternburg Bingo',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ref.watch(themeModeProvider),
    home: const HomeScreen(),
  );
}
