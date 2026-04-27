import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dream_symbol.dart';
import '../../providers/dream_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import 'dream_history_screen.dart';
import 'dream_result_screen.dart';

class DreamInputScreen extends ConsumerStatefulWidget {
  const DreamInputScreen({super.key});

  @override
  ConsumerState<DreamInputScreen> createState() => _DreamInputScreenState();
}

class _DreamInputScreenState extends ConsumerState<DreamInputScreen> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final dreamText = _controller.text.trim();

    if (dreamText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dreamEmpty)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final store = ref.read(dreamHistoryStoreProvider);
      if (!await store.canSubmitDream()) {
        if (!mounted) return;
        await _showDialog(l10n.dreamLimitTitle, l10n.dreamLimitBody);
        return;
      }

      final bundle = await ref.read(dreamBundleProvider.future);

      if (isBlocked(dreamText, bundle.blockedKeywords)) {
        if (!mounted) return;
        await _showDialog(l10n.dreamBlockedTitle, l10n.dreamBlockedBody);
        return;
      }

      final matched = interpretDream(dreamText, bundle.symbols);
      final interpretation = DreamInterpretation(
        dreamText: dreamText,
        matchedSymbols: matched,
        disclaimer: bundle.requiredDisclaimer,
        timestamp: DateTime.now(),
      );

      await store.append(interpretation.toJson());
      await store.incrementTodayCount();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DreamResultScreen(interpretation: interpretation),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _showDialog(String title, String body) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardGreen,
        title: Text(title, style: const TextStyle(color: AppColors.textWhite)),
        content: Text(body, style: const TextStyle(color: AppColors.textWhite)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.continueAction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.dreamInputTitle,
        actions: [
          IconButton(
            tooltip: l10n.dreamHistoryTitle,
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DreamHistoryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const Icon(Icons.science_outlined,
                      color: AppColors.gold, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.dreamReviewBanner,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.lightGold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.3),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                maxLines: 8,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 17,
                  height: 1.8,
                  color: AppColors.textWhite,
                ),
                decoration: InputDecoration(
                  hintText: l10n.dreamInputHint,
                  hintStyle: GoogleFonts.amiri(
                    color: AppColors.mutedText,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? l10n.loading : l10n.dreamSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
