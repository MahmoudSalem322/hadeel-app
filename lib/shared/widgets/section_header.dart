import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;

  /// Optional trailing action, e.g. a TextButton.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: context.text.titleMedium),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
