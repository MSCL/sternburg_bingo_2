import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/local_storage.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final init = await Future.wait([
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
    LocaleSettings.useDeviceLocale(),
  ]);

  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          localStorageProvider.overrideWithValue(
            SharedPreferencesLocalStorage(
              init.first as SharedPreferencesWithCache,
            ),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
