import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dhikr.dart';
import '../../providers/adhkar_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import '../../widgets/share_sheet.dart';
import 'adhkar_home_screen.dart';

class AdhkarReaderScreen extends ConsumerStatefulWidget {
  const AdhkarReaderScreen({super.key, required this.category});
  final DhikrCategory category;

  @override
  ConsumerState<AdhkarReaderScreen> createState() => _AdhkarReaderScreenState();
}

class _AdhkarReaderScreenState extends ConsumerState<AdhkarReaderScreen> {
  final _pages = PageController();
  final Map<String, int> _counts = {};
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _tapDhikr(Dhikr d) {
    setState(() {
      final current = _counts[d.id] ?? 0;
      if (current < d.repeat) {
        _counts[d.id] = current + 1;
      }
    });
  }

  void _resetDhikr(Dhikr d) {
    setState(() => _counts[d.id] = 0);
  }

  void _shareDhikr(Dhikr d) {
    final body = '${d.arabic}\n\n${d.transliteration}\n\n${d.translationEn}'
        '${d.source.isNotEmpty ? '\n\n— ${d.source}' : ''}';
    ShareSheet.show(context, ShareContent(text: body));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bundle = ref.watch(adhkarBundleProvider);
    final categoryName =
        AdhkarHomeScreen.localizedCategoryName(context, widget.category);

    final items = bundle.maybeWhen(
      data: (data) => data.forCategory(widget.category.id),
      orElse: () => const <Dhikr>[],
    );

    return Scaffold(
      appBar: RahmaAppBar(
        title: categoryName,
        actions: [
          if (_index < items.length)
            IconButton(
              tooltip: l10n.share,
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _shareDhikr(items[_index]),
            ),
        ],
      ),
      body: bundle.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          final items = data.forCategory(widget.category.id);
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.errorGeneric, textAlign: TextAlign.center),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.dhikrOfTotal(_index + 1, items.length),
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: items.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (ctx, i) {
                    final d = items[i];
                    final count = _counts[d.id] ?? 0;
                    final isComplete = count >= d.repeat;
                    return _DhikrPage(
                      dhikr: d,
                      count: count,
                      isComplete: isComplete,
                      onTap: () => _tapDhikr(d),
                      onReset: () => _resetDhikr(d),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _index == 0
                            ? null
                            : () => _pages.previousPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                ),
                        icon: const Icon(Icons.arrow_back_ios, size: 14),
                        label: Text(l10n.previous),
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _index >= items.length - 1
                            ? null
                            : () => _pages.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                ),
                        icon: const Icon(Icons.arrow_forward_ios, size: 14),
                        label: Text(l10n.next),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DhikrPage extends StatelessWidget {
  const _DhikrPage({
    required this.dhikr,
    required this.count,
    required this.isComplete,
    required this.onTap,
    required this.onReset,
  });

  final Dhikr dhikr;
  final int count;
  final bool isComplete;
  final VoidCallback onTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = dhikr.repeat == 0 ? 0.0 : (count / dhikr.repeat).clamp(0.0, 1.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.cardGreen, AppColors.secondaryGreen],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    dhikr.arabic,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(
                      fontSize: 22,
                      height: 2,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (dhikr.transliteration.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    dhikr.transliteration,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.lightGold,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
                if (dhikr.translationEn.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    dhikr.translationEn,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textWhite,
                      height: 1.6,
                    ),
                  ),
                ],
                if (dhikr.source.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.bookOpen,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${l10n.source}: ${dhikr.source}',
                          style: GoogleFonts.inter(
                            color: AppColors.mutedText,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.repeatN(dhikr.repeat),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.cardGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: isComplete
                ? AppColors.gold.withValues(alpha: 0.18)
                : AppColors.cardGreen,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: isComplete ? null : onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isComplete ? AppColors.gold : AppColors.gold.withValues(alpha: 0.3),
                    width: isComplete ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '$count / ${dhikr.repeat}',
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isComplete ? l10n.complete : l10n.tapToCount,
                      style: GoogleFonts.inter(
                        color: AppColors.lightGold,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(l10n.resetCounter),
            ),
          ),
        ],
      ),
    );
  }
}
