import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/quran_bookmark.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import 'quran_reader_screen.dart';

const _kPopularQueries = [
  'mercy',
  'patience',
  'gratitude',
  'forgiveness',
  'reliance',
  'remembrance',
];

class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  void _setQuery(String value) {
    _ctrl.text = value;
    _ctrl.selection = TextSelection.fromPosition(TextPosition(offset: value.length));
    ref.read(searchQueryProvider.notifier).state = value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: RahmaAppBar(title: l10n.searchQuran),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _ctrl,
              onChanged: _onChanged,
              autofocus: true,
              style: const TextStyle(color: AppColors.textWhite),
              cursorColor: AppColors.gold,
              decoration: InputDecoration(
                hintText: l10n.searchQuran,
                hintStyle: const TextStyle(color: AppColors.mutedText),
                filled: true,
                fillColor: AppColors.cardGreen,
                prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: AppColors.mutedText),
                        onPressed: () {
                          _ctrl.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: query.trim().length < 2
                ? _PopularSection(onTap: _setQuery)
                : results.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(e.toString(), textAlign: TextAlign.center),
                      ),
                    ),
                    data: (hits) {
                      if (hits.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.noResults,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: hits.length,
                        separatorBuilder: (ctx, i) => Divider(
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.08),
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (ctx, i) {
                          final h = hits[i];
                          return _SearchResultTile(hit: h);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PopularSection extends StatelessWidget {
  const _PopularSection({required this.onTap});
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          l10n.popularSearches,
          style: GoogleFonts.inter(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _kPopularQueries
              .map((q) => ActionChip(
                    label: Text(q),
                    onPressed: () => onTap(q),
                    backgroundColor: AppColors.cardGreen,
                    labelStyle: GoogleFonts.inter(color: AppColors.lightGold),
                    side: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            l10n.searchTooShort,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.hit});
  final QuranSearchHit hit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.gold.withValues(alpha: 0.12),
        child: Text(
          hit.verseKey,
          style: GoogleFonts.inter(
            color: AppColors.gold,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          hit.snippet,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: GoogleFonts.amiri(
            color: AppColors.textWhite,
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ),
      subtitle: hit.translationSnippet.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                hit.translationSnippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: AppColors.lightGold,
                  fontSize: 12,
                ),
              ),
            ),
      onTap: () async {
        // Find surah name from chapters provider, fall back to "Surah N".
        final chaptersAsync = ref.read(chaptersProvider);
        final name = chaptersAsync.maybeWhen(
          data: (list) => list
              .firstWhere(
                (s) => s.number == hit.surahNumber,
                orElse: () => list.first,
              )
              .nameSimple,
          orElse: () => 'Surah ${hit.surahNumber}',
        );
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuranReaderScreen(
              surahNumber: hit.surahNumber,
              surahName: name,
              initialVerse: hit.verseNumber,
            ),
          ),
        );
      },
    );
  }
}
