import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/prayer_countdown_bar.dart';
import '../../widgets/rahma_app_bar.dart';
import 'quran_reader_screen.dart';
import 'quran_search_screen.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/surah_list_tile.dart';

class QuranHomeScreen extends ConsumerStatefulWidget {
  const QuranHomeScreen({super.key, this.embedded = false});

  /// When true, omits its own scaffold/appbar so it can render inside the
  /// home bottom-nav scaffold. When false, renders standalone.
  final bool embedded;

  @override
  ConsumerState<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends ConsumerState<QuranHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = Column(
      children: [
        const PrayerCountdownBar(),
        Material(
          color: AppColors.primaryDarkGreen,
          child: TabBar(
            controller: _tabs,
            indicatorColor: AppColors.gold,
            indicatorWeight: 3,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.mutedText,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              Tab(text: l10n.read),
              Tab(text: l10n.listen),
              Tab(text: l10n.bookmarksTab),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _ReadTab(),
              _ListenTab(),
              _BookmarksTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.quran,
        actions: [
          IconButton(
            tooltip: l10n.search,
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QuranSearchScreen()),
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _ReadTab extends ConsumerWidget {
  const _ReadTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final chapters = ref.watch(chaptersProvider);

    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () async => ref.invalidate(chaptersProvider),
      child: chapters.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e, onRetry: () => ref.invalidate(chaptersProvider)),
        data: (list) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ContinueReadingCard()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.surahLabel,
                      style: GoogleFonts.inter(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      '${list.length} ${l10n.surahLabel.toLowerCase()}',
                      style: GoogleFonts.inter(
                        color: AppColors.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: list.length,
              separatorBuilder: (ctx, i) => Divider(
                height: 1,
                color: AppColors.gold.withValues(alpha: 0.06),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (ctx, i) {
                final surah = list[i];
                return SurahListTile(
                  surah: surah,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuranReaderScreen(
                        surahNumber: surah.number,
                        surahName: surah.nameSimple,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _ListenTab extends StatelessWidget {
  const _ListenTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: const Icon(
                PhosphorIconsFill.musicNotes,
                color: AppColors.gold,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.audioComingSoon,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarksTab extends ConsumerWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bookmarksControllerProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
        error: e,
        onRetry: () => ref.read(bookmarksControllerProvider.notifier).refresh(),
      ),
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIconsRegular.bookmarkSimple,
                    size: 56,
                    color: AppColors.gold.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noBookmarks,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: bookmarks.length,
          separatorBuilder: (ctx, i) => Divider(
            height: 1,
            color: AppColors.gold.withValues(alpha: 0.08),
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (ctx, i) {
            final b = bookmarks[i];
            return ListTile(
              leading: const Icon(
                PhosphorIconsFill.bookmarkSimple,
                color: AppColors.gold,
              ),
              title: Text(
                b.surahName,
                style: GoogleFonts.inter(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                l10n.verseN(b.verseNumber),
                style: GoogleFonts.inter(color: AppColors.mutedText),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: AppColors.mutedText),
                onPressed: () async {
                  await ref.read(bookmarksControllerProvider.notifier).remove(
                        surahNumber: b.surahNumber,
                        verseNumber: b.verseNumber,
                      );
                },
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuranReaderScreen(
                    surahNumber: b.surahNumber,
                    surahName: b.surahName,
                    initialVerse: b.verseNumber,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
            const SizedBox(height: 12),
            Text(l10n.errorGeneric, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
