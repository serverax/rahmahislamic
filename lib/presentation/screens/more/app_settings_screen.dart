import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../widgets/rahma_app_bar.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(languageControllerProvider);

    return Scaffold(
      appBar: RahmaAppBar(title: l10n.appSettings),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(text: l10n.language),
          Card(
            child: RadioGroup<String>(
              groupValue: state.locale.languageCode,
              onChanged: (code) async {
                if (code == null) return;
                await ref
                    .read(languageControllerProvider.notifier)
                    .setLanguage(code);
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.languageEnglish),
                    value: 'en',
                  ),
                  const Divider(height: 1, color: AppColors.primaryDarkGreen),
                  RadioListTile<String>(
                    title: Text(l10n.languageArabic),
                    value: 'ar',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(text: l10n.theme),
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined,
                  color: AppColors.gold),
              title: Text(l10n.themeDark),
              subtitle: Text(
                l10n.themeOnlyDarkNote,
                style: GoogleFonts.inter(
                  color: AppColors.mutedText,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.check_circle, color: AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
