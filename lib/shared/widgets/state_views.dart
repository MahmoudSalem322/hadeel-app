import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/context_x.dart';
import 'buttons.dart';

/// Calm, centered message for "nothing here yet" situations.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      icon: icon,
      iconColor: context.colors.primary,
      iconBackground: context.colors.primaryContainer,
      title: title,
      message: message,
      action: actionLabel == null
          ? null
          : PrimaryButton(label: actionLabel!, onPressed: onAction, expand: false),
    );
  }
}

/// Recoverable error with a clear next step. Never a dead end.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.info_outline_rounded,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      icon: icon,
      iconColor: context.colors.error,
      iconBackground: context.colors.error.withValues(alpha: 0.12),
      title: title,
      message: message,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (actionLabel != null)
            PrimaryButton(label: actionLabel!, onPressed: onAction, expand: false),
          if (secondaryActionLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            TextButton(onPressed: onSecondaryAction, child: Text(secondaryActionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // Scrolls when space is short (landscape, large text) instead of
    // overflowing; sizes to content when placed inside another scrollable.
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = _content(context);
        if (!constraints.hasBoundedHeight) return content;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: content,
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: iconBackground, shape: BoxShape.circle),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message!,
                  style: context.text.bodyMedium!.copyWith(color: context.brand.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
