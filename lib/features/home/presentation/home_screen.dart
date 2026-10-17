import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/i18n/strings.g.dart';
import '../../../core/widgets/app_scaffold.dart';

@RoutePage()
final class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppScaffold(
    title: t.appName,
    body: const Center(child: Placeholder()),
  );
}
