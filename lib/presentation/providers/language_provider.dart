import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLanguageKey = 'app_language_code';
const _kOnboardingDoneKey = 'onboarding_done';

class LanguageState {
  const LanguageState({
    required this.locale,
    required this.hasSelectedLanguage,
    required this.onboardingDone,
  });

  final Locale locale;
  final bool hasSelectedLanguage;
  final bool onboardingDone;

  bool get isArabic => locale.languageCode == 'ar';
  TextDirection get textDirection => isArabic ? TextDirection.rtl : TextDirection.ltr;

  LanguageState copyWith({
    Locale? locale,
    bool? hasSelectedLanguage,
    bool? onboardingDone,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      hasSelectedLanguage: hasSelectedLanguage ?? this.hasSelectedLanguage,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}

class LanguageController extends StateNotifier<LanguageState> {
  LanguageController()
      : super(const LanguageState(
          locale: Locale('en'),
          hasSelectedLanguage: false,
          onboardingDone: false,
        ));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLanguageKey);
    final onboarded = prefs.getBool(_kOnboardingDoneKey) ?? false;
    state = LanguageState(
      locale: Locale(code ?? 'en'),
      hasSelectedLanguage: code != null,
      onboardingDone: onboarded,
    );
  }

  Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, code);
    state = state.copyWith(
      locale: Locale(code),
      hasSelectedLanguage: true,
    );
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingDoneKey, true);
    state = state.copyWith(onboardingDone: true);
  }
}

final languageControllerProvider =
    StateNotifierProvider<LanguageController, LanguageState>((ref) {
  return LanguageController();
});
