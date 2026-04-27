import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/adhkar_provider.dart';
import '../../widgets/rahma_app_bar.dart';

class TasbihCounterScreen extends ConsumerWidget {
  const TasbihCounterScreen({super.key});

  void _showPhraseSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectPhrase,
                style: GoogleFonts.inter(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              for (final p in TasbihPhrases.all)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      p.arabic,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    '${p.transliteration} — ${p.translationEn}',
                    style: GoogleFonts.inter(
                      color: AppColors.lightGold,
                      fontSize: 12,
                    ),
                  ),
                  trailing: p.target != null
                      ? Text(
                          '×${p.target}',
                          style: GoogleFonts.inter(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                  onTap: () async {
                    await ref.read(tasbihControllerProvider.notifier).selectPhrase(p);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(tasbihControllerProvider);
    final ctrl = ref.read(tasbihControllerProvider.notifier);
    final phrase = state.phrase;
    final target = phrase.target ?? 33;
    final progress = (state.count % target) / target;
    final completedRounds = state.count ~/ target;

    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.tasbihCounter,
        actions: [
          IconButton(
            tooltip: l10n.selectPhrase,
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => _showPhraseSelector(context, ref),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: state.loading
            ? null
            : () {
                HapticFeedback.lightImpact();
                ctrl.increment();
              },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        phrase.arabic,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${phrase.transliteration} — ${phrase.translationEn}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.lightGold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: AppColors.cardGreen,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardGreen,
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.count.toString(),
                            style: GoogleFonts.inter(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 56,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.count % target} / $target',
                            style: GoogleFonts.inter(
                              color: AppColors.lightGold,
                              fontSize: 12,
                            ),
                          ),
                          if (completedRounds > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              '×$completedRounds',
                              style: GoogleFonts.inter(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.tapAnywhereToCount,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(l10n.resetCounter),
                      onPressed: () => ctrl.reset(),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(PhosphorIconsFill.circlesThreePlus, size: 18),
                      label: Text(l10n.selectPhrase),
                      onPressed: () => _showPhraseSelector(context, ref),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
