import 'package:flutter/material.dart';

import '../../shared/extensions/context_x.dart';
import '../../shared/widgets/state_views.dart';

/// Stand-in for sections scheduled in later phases. Every registered route
/// resolves to a real, polished screen — never a crash or blank page.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(
        icon: Icons.hourglass_empty_rounded,
        title: context.l10n.comingSoonTitle,
        message: context.l10n.comingSoonBody,
      ),
    );
  }
}
