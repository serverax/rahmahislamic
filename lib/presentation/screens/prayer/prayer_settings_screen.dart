import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/prayer_settings.dart';
import '../../providers/language_provider.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/prayer_settings_provider.dart';
import '../../widgets/rahma_app_bar.dart';

class PrayerSettingsScreen extends ConsumerWidget {
  const PrayerSettingsScreen({super.key});

  String _methodLabel(AppLocalizations l10n, CalculationMethod m) {
    switch (m) {
      case CalculationMethod.muslimWorldLeague:
        return l10n.method_muslimWorldLeague;
      case CalculationMethod.egyptian:
        return l10n.method_egyptian;
      case CalculationMethod.karachi:
        return l10n.method_karachi;
      case CalculationMethod.ummAlQura:
        return l10n.method_ummAlQura;
      case CalculationMethod.dubai:
        return l10n.method_dubai;
      case CalculationMethod.northAmerica:
        return l10n.method_northAmerica;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(prayerSettingsProvider);
    final ctrl = ref.read(prayerSettingsProvider.notifier);
    final isArabic = ref.watch(languageControllerProvider).isArabic;

    void onChanged() => ref.invalidate(prayerTimesProvider);

    return Scaffold(
      appBar: RahmaAppBar(title: l10n.prayerSettings),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(text: l10n.locationMode),
          Card(
            child: Column(
              children: [
                RadioGroup<LocationMode>(
                  groupValue: settings.locationMode,
                  onChanged: (v) async {
                    if (v == null) return;
                    await ctrl.setLocationMode(v);
                    onChanged();
                  },
                  child: Column(
                    children: [
                      RadioListTile<LocationMode>(
                        title: Text(l10n.locationAuto),
                        value: LocationMode.auto,
                      ),
                      const Divider(height: 1, color: AppColors.primaryDarkGreen),
                      RadioListTile<LocationMode>(
                        title: Text(l10n.locationManual),
                        value: LocationMode.manual,
                      ),
                    ],
                  ),
                ),
                if (settings.locationMode == LocationMode.manual) ...[
                  const Divider(height: 1, color: AppColors.primaryDarkGreen),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: settings.manualCityId,
                      decoration: InputDecoration(
                        labelText: l10n.manualCity,
                        labelStyle: const TextStyle(color: AppColors.mutedText),
                        filled: true,
                        fillColor: AppColors.primaryDarkGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.gold),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.4)),
                        ),
                      ),
                      dropdownColor: AppColors.cardGreen,
                      items: PresetCities.all
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(isArabic ? c.nameAr : c.nameEn),
                              ))
                          .toList(),
                      onChanged: (id) async {
                        if (id == null) return;
                        await ctrl.setManualCity(id);
                        onChanged();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(text: l10n.calculationMethod),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<CalculationMethod>(
                isExpanded: true,
                initialValue: settings.method,
                decoration: const InputDecoration(border: InputBorder.none),
                dropdownColor: AppColors.cardGreen,
                items: CalculationMethod.values
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(_methodLabel(l10n, m), overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (m) async {
                  if (m == null) return;
                  await ctrl.setMethod(m);
                  onChanged();
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(text: l10n.asrSchool),
          Card(
            child: RadioGroup<AsrSchool>(
              groupValue: settings.asrSchool,
              onChanged: (v) async {
                if (v == null) return;
                await ctrl.setAsrSchool(v);
                onChanged();
              },
              child: Column(
                children: [
                  RadioListTile<AsrSchool>(
                    title: Text(l10n.asrShafi),
                    value: AsrSchool.shafi,
                  ),
                  const Divider(height: 1, color: AppColors.primaryDarkGreen),
                  RadioListTile<AsrSchool>(
                    title: Text(l10n.asrHanafi),
                    value: AsrSchool.hanafi,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(text: l10n.notifications),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: Text(l10n.prayerNotifications),
                  value: settings.notificationsEnabled,
                  activeThumbColor: AppColors.gold,
                  onChanged: (v) async {
                    await ctrl.setNotificationsEnabled(v);
                    if (v && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.cardGreen,
                          content: Text(
                            '${l10n.notificationsNoticeTitle}: ${l10n.notificationsNoticeBody}',
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (settings.notificationsEnabled) ...[
                  const Divider(height: 1, color: AppColors.primaryDarkGreen),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.minutesBefore,
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(l10n.minutesValue(settings.minutesBefore),
                            style: const TextStyle(color: AppColors.gold)),
                      ],
                    ),
                  ),
                  Slider(
                    value: settings.minutesBefore.toDouble(),
                    min: 0,
                    max: 60,
                    divisions: 12,
                    activeColor: AppColors.gold,
                    inactiveColor: AppColors.gold.withValues(alpha: 0.25),
                    label: l10n.minutesValue(settings.minutesBefore),
                    onChanged: (v) => ctrl.setMinutesBefore(v.round()),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
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
