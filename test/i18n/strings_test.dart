import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/i18n/strings.g.dart';

void main() {
  group('i18n', () {
    test('Should compile', () async {
      final Translations de = await AppLocale.de.build();
      expect(de.appName, 'Sternbingo');
    });

    test('All locales should be supported by Flutter', () {
      for (final AppLocale locale in AppLocale.values) {
        expect(kMaterialSupportedLanguages, contains(locale.languageCode));
      }
    });
  });
}
