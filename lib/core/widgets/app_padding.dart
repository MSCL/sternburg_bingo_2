import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

final class AppPadding extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.padding = appEdgeInsetsAllLg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: child);
}
