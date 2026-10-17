import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../../../core/theme/theme_provider.dart';

@RoutePage()
final class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.appName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(t.welcome),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final ThemeMode newMode = currentThemeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                ref.read(themeModeProvider.notifier).setThemeMode(newMode);
              },
              child: Text(
                currentThemeMode == ThemeMode.dark
                    ? t.switchToLight
                    : t.switchToDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
