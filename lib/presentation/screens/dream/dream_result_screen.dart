import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dream_symbol.dart';
import '../../widgets/rahma_app_bar.dart';
import '../../widgets/share_sheet.dart';
import 'dream_input_screen.dart';

class DreamResultScreen extends StatelessWidget {
  const DreamResultScreen({super.key, required this.interpretation});
  final DreamInterpretation interpretation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasMatches = interpretation.matchedSymbols.isNotEmpty;

    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.dreamResultTitle,
        actions: [
          IconButton(
            tooltip: l10n.share,
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final body = _shareBody(interpretation);
              ShareSheet.show(context, ShareContent(text: body));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    interpretation.disclaimer,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: AppColors.lightGold,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DreamTextCard(text: interpretation.dreamText),
          const SizedBox(height: 20),
          Text(
            l10n.dreamPossibleMeanings,
            style: GoogleFonts.inter(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          if (!hasMatches)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                l10n.dreamNoMatch,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  height: 1.5,
                ),
                textDirection: TextDirection.rtl,
              ),
            )
          else
            ...interpretation.matchedSymbols.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SymbolCard(symbol: s),
                )),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.newDream),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DreamInputScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

String _shareBody(DreamInterpretation i) {
  final lines = <String>[];
  lines.add('— تفسير الأحلام —');
  lines.add('');
  for (final s in i.matchedSymbols) {
    lines.add('• ${s.meaningGeneralAr}');
    if (s.meaningSafeAr.isNotEmpty) {
      lines.add('  (${s.meaningSafeAr})');
    }
    lines.add('');
  }
  lines.add(i.disclaimer);
  return lines.join('\n').trim();
}

class _DreamTextCard extends StatelessWidget {
  const _DreamTextCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.18),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          text,
          style: GoogleFonts.amiri(
            fontSize: 16,
            height: 1.8,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}

class _SymbolCard extends StatelessWidget {
  const _SymbolCard({required this.symbol});
  final DreamSymbol symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardGreen, AppColors.secondaryGreen],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  symbol.category,
                  style: GoogleFonts.cairo(
                    color: AppColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              symbol.meaningGeneralAr,
              style: GoogleFonts.cairo(
                color: AppColors.textWhite,
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ),
          if (symbol.meaningSafeAr.isNotEmpty) ...[
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                symbol.meaningSafeAr,
                style: GoogleFonts.cairo(
                  color: AppColors.lightGold,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
          if (symbol.sourceAttribution.isNotEmpty) ...[
            const SizedBox(height: 6),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                symbol.sourceAttribution,
                style: GoogleFonts.cairo(
                  color: AppColors.mutedText,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
