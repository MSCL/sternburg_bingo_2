import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(
          SharedPreferencesLocalStorage(
            await SharedPreferencesWithCache.create(
              cacheOptions: const SharedPreferencesWithCacheOptions(),
            ),
          ),
        ),
      ],
      child: const SternburgBingoApp(),
    ),
  );
}
