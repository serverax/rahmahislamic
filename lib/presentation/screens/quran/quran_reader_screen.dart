import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/ayah.dart';
import '../../../domain/entities/quran_bookmark.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import '../../widgets/share_sheet.dart';

class QuranReaderScreen extends ConsumerStatefulWidget {
  const QuranReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.initialVerse,
  });

  final int surahNumber;
  final String surahName;
  final int? initialVerse;

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  bool _showTranslation = true;
  double _arabicFontSize = 24;
  final ScrollController _scroll = ScrollController();
  final Map<int, GlobalKey> _verseKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(lastReadControllerProvider.notifier).set(
            QuranLastRead(
              surahNumber: widget.surahNumber,
              verseNumber: widget.initialVerse ?? 1,
              surahName: widget.surahName,
              timestamp: DateTime.now(),
            ),
          );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _maybeScrollToInitial(List<Ayah> verses) {
    final initial = widget.initialVerse;
    if (initial == null || initial <= 1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _verseKeys[initial];
      final ctx = key?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          alignment: 0.05,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final versesAsync = ref.watch(surahVersesProvider(widget.surahNumber));
    final bookmarksAsync = ref.watch(bookmarksControllerProvider);
    final bookmarkSet = bookmarksAsync.when(
      data: (b) => b
          .where((bm) => bm.surahNumber == widget.surahNumber)
          .map((bm) => bm.verseNumber)
          .toSet(),
      loading: () => <int>{},
      error: (e, st) => <int>{},
    );

    return Scaffold(
      appBar: RahmaAppBar(
        title: widget.surahName,
        actions: [
          IconButton(
            tooltip: l10n.fontSize,
            icon: const Icon(Icons.text_decrease),
            onPressed: () => setState(() => _arabicFontSize = (_arabicFontSize - 2).clamp(16, 36)),
          ),
          IconButton(
            tooltip: l10n.fontSize,
            icon: const Icon(Icons.text_increase),
            onPressed: () => setState(() => _arabicFontSize = (_arabicFontSize + 2).clamp(16, 36)),
          ),
          IconButton(
            tooltip: l10n.showTranslation,
            icon: Icon(_showTranslation ? Icons.translate : Icons.translate_outlined),
            onPressed: () => setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
      body: versesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                const SizedBox(height: 12),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(surahVersesProvider(widget.surahNumber)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (verses) {
          _maybeScrollToInitial(verses);
          return ListView.separated(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: verses.length,
            separatorBuilder: (ctx, i) => Divider(
              height: 1,
              color: AppColors.gold.withValues(alpha: 0.08),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (ctx, i) {
              final v = verses[i];
              final key = _verseKeys.putIfAbsent(v.verseNumber, () => GlobalKey());
              final isBookmarked = bookmarkSet.contains(v.verseNumber);
              return Padding(
                key: key,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            v.verseKey,
                            style: GoogleFonts.inter(
                              color: AppColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: l10n.share,
                          icon: const Icon(Icons.share_outlined, color: AppColors.gold),
                          onPressed: () {
                            final body = '${v.textArabic}\n\n${v.translation}\n\n— Quran ${v.verseKey}';
                            ShareSheet.show(context, ShareContent(text: body));
                          },
                        ),
                        IconButton(
                          tooltip: isBookmarked ? l10n.bookmarkRemoved : l10n.bookmarkAdded,
                          icon: Icon(
                            isBookmarked
                                ? PhosphorIconsFill.bookmarkSimple
                                : PhosphorIconsRegular.bookmarkSimple,
                            color: AppColors.gold,
                          ),
                          onPressed: () async {
                            final ctrl = ref.read(bookmarksControllerProvider.notifier);
                            if (isBookmarked) {
                              await ctrl.remove(
                                surahNumber: widget.surahNumber,
                                verseNumber: v.verseNumber,
                              );
                            } else {
                              await ctrl.add(QuranBookmark(
                                surahNumber: widget.surahNumber,
                                verseNumber: v.verseNumber,
                                surahName: widget.surahName,
                                createdAt: DateTime.now(),
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        v.textArabic,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: _arabicFontSize,
                          height: 2,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_showTranslation && v.translation.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        v.translation,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.lightGold,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
