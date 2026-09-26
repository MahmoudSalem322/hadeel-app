import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/library.dart';
import '../../../domain/entities/quran.dart';
import '../../../shared/extensions/context_x.dart';
import '../../../shared/widgets/hadeel_bottom_sheet.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/quran_providers.dart';
import 'quran_style.dart';

Future<void> showAyahActions(BuildContext context, {required AyahRef ref, required String text}) {
  return showHadeelBottomSheet<void>(
    context: context,
    builder: (_) => AyahActionsSheet(ayah: ref, text: text),
  );
}

/// Actions for a single ayah: bookmark, favorite, copy, share.
class AyahActionsSheet extends ConsumerWidget {
  const AyahActionsSheet({super.key, required this.ayah, required this.text});

  final AyahRef ayah;
  final String text;

  String _citation(BuildContext context, Surah surah) => context.l10n.ayahCitation(
        text,
        surah.nameAr,
        context.formatters.number(ayah.ayah),
      );

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final surah = ref.watch(quranMetaProvider).surah(ayah.surah);
    final bookmarked = ref.watch(bookmarkedRefsProvider).contains(ayah);
    final favorite = ref.watch(favoriteAyahRefsProvider).contains(ayah);
    final settings = ref.watch(quranSettingsProvider);
    final library = ref.read(libraryRepositoryProvider);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.ayahPosition(surah.nameAr, context.formatters.number(ayah.ayah)),
              style: context.text.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3),
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: quranTextStyle(
                    settings.copyWith(fontSize: 22, lineHeight: 1.9),
                    context.colors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                _Action(
                  icon: Icons.bookmark_border_rounded,
                  activeIcon: Icons.bookmark_rounded,
                  active: bookmarked,
                  label: l10n.ayahActionBookmark,
                  onTap: () async {
                    final added = await library.toggleBookmark(ayah);
                    if (context.mounted) {
                      _toast(context, added ? l10n.toastBookmarkAdded : l10n.toastBookmarkRemoved);
                    }
                  },
                ),
                _Action(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  active: favorite,
                  label: l10n.ayahActionFavorite,
                  onTap: () async {
                    final added = await library.toggleFavorite(FavoriteKind.ayah, ayah.key);
                    if (context.mounted) {
                      _toast(context, added ? l10n.toastFavoriteAdded : l10n.toastFavoriteRemoved);
                    }
                  },
                ),
                _Action(
                  icon: Icons.copy_rounded,
                  label: l10n.ayahActionCopy,
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: _citation(context, surah)));
                    if (context.mounted) {
                      _toast(context, l10n.toastCopied);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _Action(
                  icon: Icons.ios_share_rounded,
                  label: l10n.ayahActionShare,
                  onTap: () => SharePlus.instance.share(ShareParams(text: _citation(context, surah))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.activeIcon,
    this.active = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final bool active;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? context.brand.goldText : context.colors.onSurface;
    return Expanded(
      child: Semantics(
        button: true,
        toggled: activeIcon == null ? null : active,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.medium,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: Tween<double>(begin: 0.6, end: 1).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    active ? activeIcon ?? icon : icon,
                    key: ValueKey(active),
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(label, style: context.text.labelMedium!.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
