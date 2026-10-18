import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// A reusable card component with standard app padding and theme styling.
final class AppCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.color,
    this.padding = appEdgeInsetsAllLg,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: Padding(padding: padding, child: child),
  );
}
