import 'package:material_ui/material_ui.dart';

final class AppTile extends StatelessWidget {
  const new({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle!) : null,
    trailing: trailing,
    onTap: onTap,
  );
}

final class AppSwitchTile extends StatelessWidget {
  const new({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    secondary: Icon(icon),
    title: Text(title),
    value: value,
    onChanged: onChanged,
  );
}
