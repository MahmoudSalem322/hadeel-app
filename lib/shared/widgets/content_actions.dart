import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers/content_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/library.dart';
import '../extensions/context_x.dart';

/// Style for adhkar, duas and hadith text: a traditional naskh face that
/// renders full tashkeel clearly.
TextStyle contentTextStyle(BuildContext context, {double size = 21}) => TextStyle(
      fontFamily: AppTypography.quranFontAlt,
      fontSize: size,
      height: 1.95,
      color: context.colors.onSurface,
    );

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
}

/// Favorite · copy · share for a piece of content.
class ContentActions extends ConsumerWidget {
  const ContentActions({
    super.key,
    required this.kind,
    required this.favoriteKey,
    required this.shareText,
  });

  final FavoriteKind kind;
  final String favoriteKey;

  /// Text used for copy and share (includes the source reference).
  final String shareText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isFavorite = ref.watch(favoriteKeysProvider(kind).select((s) => s.contains(favoriteKey)));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.ayahActionFavorite,
          isSelected: isFavorite,
          onPressed: () async {
            final added = await ref.read(libraryRepositoryProvider).toggleFavorite(kind, favoriteKey);
            if (context.mounted) {
              showToast(context, added ? l10n.toastFavoriteAdded : l10n.toastFavoriteRemoved);
            }
          },
          icon: AnimatedSwitcher(
            duration: AppMotion.medium,
            transitionBuilder: (child, a) => ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1).animate(CurvedAnimation(parent: a, curve: Curves.easeOutBack)),
              child: child,
            ),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite),
              color: isFavorite ? context.brand.goldText : null,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.ayahActionCopy,
          icon: const Icon(Icons.copy_rounded),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: shareText));
            if (context.mounted) showToast(context, l10n.toastCopiedText);
          },
        ),
        IconButton(
          tooltip: l10n.ayahActionShare,
          icon: const Icon(Icons.ios_share_rounded),
          onPressed: () => SharePlus.instance.share(ShareParams(text: shareText)),
        ),
      ],
    );
  }
}

/// Loading / error wrapper for lazily loaded local content.
class ContentAsync<T> extends StatelessWidget {
  const ContentAsync({super.key, required this.value, required this.data, this.onRetry});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.contentLoadError, style: context.text.titleMedium),
              if (onRetry != null)
                TextButton(onPressed: onRetry, child: Text(context.l10n.actionRetry)),
            ],
          ),
        ),
      ),
    );
  }
}
