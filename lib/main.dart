import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWithValue(
          SharedPreferencesAppPreferences(sharedPreferences),
        ),
      ],
      child: const SternburgBingoApp(),
    ),
  );
}
