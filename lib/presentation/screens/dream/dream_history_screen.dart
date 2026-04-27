import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/dream_symbol.dart';
import '../../providers/dream_provider.dart';
import '../../widgets/rahma_app_bar.dart';
import 'dream_result_screen.dart';

class DreamHistoryScreen extends ConsumerStatefulWidget {
  const DreamHistoryScreen({super.key});

  @override
  ConsumerState<DreamHistoryScreen> createState() => _DreamHistoryScreenState();
}

class _DreamHistoryScreenState extends ConsumerState<DreamHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(dreamHistoryStoreProvider).getHistory();
  }

  Future<void> _clear() async {
    await ref.read(dreamHistoryStoreProvider).clear();
    setState(() {
      _future = Future.value(const []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bundleAsync = ref.watch(dreamBundleProvider);

    return Scaffold(
      appBar: RahmaAppBar(
        title: l10n.dreamHistoryTitle,
        actions: [
          Builder(
            builder: (innerCtx) => IconButton(
              tooltip: l10n.dreamClearHistory,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(innerCtx);
                final label = l10n.dreamClearHistory;
                await _clear();
                messenger.showSnackBar(SnackBar(content: Text(label)));
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snap.data ?? const [];
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.dreamHistoryEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          final symbolsById = bundleAsync.maybeWhen(
            data: (b) => {for (final s in b.symbols) s.id: s},
            orElse: () => <String, DreamSymbol>{},
          );
          final disclaimer = bundleAsync.maybeWhen(
            data: (b) => b.requiredDisclaimer,
            orElse: () => '',
          );

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (sepCtx, sepIdx) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final entry = entries[i];
              final timestamp = DateTime.tryParse(
                  entry['timestamp'] as String? ?? '') ??
                  DateTime.now();
              final dreamText =
                  (entry['dreamText'] as String?)?.trim() ?? '';
              final preview = dreamText.length > 100
                  ? '${dreamText.substring(0, 100)}…'
                  : dreamText;
              final matchedIds =
                  ((entry['matchedSymbolIds'] as List<dynamic>?) ?? const [])
                      .cast<String>();

              return Material(
                color: AppColors.cardGreen,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    final interpretation = DreamInterpretation.fromJson(
                      entry,
                      symbolsById,
                      disclaimer,
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DreamResultScreen(
                        interpretation: interpretation,
                      ),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMMd().add_Hm().format(timestamp),
                              style: GoogleFonts.inter(
                                color: AppColors.lightGold,
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${matchedIds.length}',
                              style: GoogleFonts.inter(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            preview,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              color: AppColors.textWhite,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
