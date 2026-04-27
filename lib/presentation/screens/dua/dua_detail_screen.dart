import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dua.dart';
import '../../widgets/rahma_app_bar.dart';
import '../../widgets/share_sheet.dart';
import 'dua_list_screen.dart';

class DuaDetailScreen extends StatefulWidget {
  const DuaDetailScreen({
    super.key,
    required this.category,
    required this.duas,
  });

  final DuaCategory category;
  final List<Dua> duas;

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _share(Dua d) {
    final body = '${d.arabic}\n\n${d.transliteration}\n\n${d.translationEn}\n\n— ${d.source}';
    ShareSheet.show(context, ShareContent(text: body));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryName = DuaListScreen.localizedCategoryName(context, widget.category);

    return Scaffold(
      appBar: RahmaAppBar(
        title: categoryName,
        actions: [
          IconButton(
            tooltip: l10n.share,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _share(widget.duas[_index]),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_index + 1} / ${widget.duas.length}',
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
              itemCount: widget.duas.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (ctx, i) => _DuaPage(
                dua: widget.duas[i],
                onShare: () => _share(widget.duas[i]),
              ),
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
                    onPressed: _index >= widget.duas.length - 1
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
      ),
    );
  }
}

class _DuaPage extends StatelessWidget {
  const _DuaPage({required this.dua, required this.onShare});
  final Dua dua;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    dua.arabic,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(
                      fontSize: 24,
                      height: 2,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (dua.transliteration.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    dua.transliteration,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.lightGold,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ],
                if (dua.translationEn.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    dua.translationEn,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textWhite,
                      height: 1.6,
                    ),
                  ),
                ],
                if (dua.source.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        PhosphorIconsRegular.bookOpen,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${l10n.source}: ${dua.source}',
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
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.share_outlined, size: 16),
              label: Text(AppLocalizations.of(context)!.share),
            ),
          ),
        ],
      ),
    );
  }
}
