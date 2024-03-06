import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key, required this.title, this.trailing
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSecondary)),
          if( trailing != null) const Spacer(),
          if( trailing != null) trailing!,
        ],),
      ),
    );
  }
}