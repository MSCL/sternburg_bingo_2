import 'package:material_ui/material_ui.dart';

final class AppScaffold extends StatelessWidget {
  const new({
    required this.body,
    super.key,
    this.title,
    this.useSafeArea = true,
  });

  final Widget body;
  final String? title;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: title != null ? AppBar(title: Text(title!)) : null,
    body: useSafeArea ? SafeArea(child: body) : body,
  );
}
