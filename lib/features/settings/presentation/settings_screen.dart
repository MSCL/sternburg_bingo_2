import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/analytics/analytics_provider.dart';
import '../../../core/i18n/strings.g.dart';
import '../../../core/info/app_info.dart';
import '../../../core/info/package_info_provider.dart';
import '../../../core/notifications/push_notification_provider.dart';
import '../../../core/settings/app_settings_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_tile.dart';
import '../../../gen/assets.gen.dart';

@RoutePage()
final class SettingsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    useSafeArea: false,
    title: context.t.settingsTitle,
    body: ListView(
      children: const <Widget>[
        _ThemeTile(),
        _NotificationsTile(),
        _LanguageTile(),
        _AnalyticsTile(),
        _AboutTile(),
      ],
    ),
  );
}

final class _ThemeTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return AppTile(
      icon: Icons.palette_outlined,
      title: context.t.settingsTheme,
      trailing: DropdownButton<ThemeMode>(
        value: themeMode,
        onChanged: (ThemeMode? newMode) async {
          if (newMode != null) {
            await ref.read(themeModeProvider.notifier).setThemeMode(newMode);
          }
        },
        items: <DropdownMenuItem<ThemeMode>>[
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.system,
            child: Text(context.t.settingsThemeSystem),
          ),
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.light,
            child: Text(context.t.settingsThemeLight),
          ),
          DropdownMenuItem<ThemeMode>(
            value: ThemeMode.dark,
            child: Text(context.t.settingsThemeDark),
          ),
        ],
      ),
    );
  }
}

final class _NotificationsTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> isPermissionGranted = ref.watch(
      isNotificationPermissionGrantedProvider,
    );

    return AppTile(
      icon: Icons.notifications_outlined,
      title: context.t.settingsNotifications,
      subtitle: isPermissionGranted.when(
        data: (bool granted) =>
            granted ? context.t.commonEnabled : context.t.commonDisabled,
        loading: () => context.t.commonLoading,
        error: (Object _, StackTrace _) => context.t.commonUnknown,
      ),
      trailing: TextButton(
        onPressed: () =>
            ref.read(appSettingsServiceProvider).openNotificationSettings(),
        child: Text(context.t.settingsOsNotificationSettings),
      ),
    );
  }
}

final class _LanguageTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocale currentLocale = TranslationProvider.of(context).locale;

    return AppTile(
      icon: Icons.language_outlined,
      title: context.t.settingsLanguage,
      subtitle: currentLocale.languageCode.toUpperCase(),
      trailing: TextButton(
        // on iOS an OS language change kills the app, on Android not. if BE
        // calls return localized data, this advanced logic needs to be added
        onPressed: () =>
            ref.read(appSettingsServiceProvider).openLanguageSettings(),
        child: Text(context.t.settingsOsLanguageSettings),
      ),
    );
  }
}

final class _AnalyticsTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool analyticsEnabled = ref.watch(analyticsEnabledProvider);

    return AppSwitchTile(
      icon: Icons.analytics_outlined,
      title: context.t.settingsAnalytics,
      value: analyticsEnabled,
      onChanged: (bool value) => ref
          .read(analyticsEnabledProvider.notifier)
          .setAnalyticsEnabled(enabled: value),
    );
  }
}

final class _AboutTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppInfo appInfo = ref.watch(appInfoProvider);

    return AppTile(
      icon: Icons.info_outline,
      title: context.t.settingsAbout,
      onTap: () {
        final String name = appInfo.appName;
        showAboutDialog(
          context: context,
          applicationName: name,
          applicationVersion: '${appInfo.version} (${appInfo.buildNumber})',
          applicationIcon: Assets.appIcon.image(width: 48, height: 48),
          applicationLegalese: context.t.settingsLegals(
            year: DateTime.now().year.toString(),
            appName: name,
          ),
        );
      },
    );
  }
}
