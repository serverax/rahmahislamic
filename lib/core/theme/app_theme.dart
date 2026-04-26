import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(bool isArabic) {
    final base = isArabic ? GoogleFonts.cairoTextTheme() : GoogleFonts.interTextTheme();
    return base
        .apply(
          bodyColor: AppColors.textWhite,
          displayColor: AppColors.textWhite,
        )
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
          displayMedium: base.displayMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: 16,
            color: AppColors.textWhite,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 14,
            color: AppColors.mutedText,
          ),
          labelLarge: base.labelLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDarkGreen,
          ),
        );
  }

  static ThemeData darkGreenTheme(bool isArabic) {
    final textTheme = _textTheme(isArabic);
    final titleFont = isArabic ? GoogleFonts.cairo() : GoogleFonts.inter();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryDarkGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.primaryDarkGreen,
        secondary: AppColors.lightGold,
        onSecondary: AppColors.primaryDarkGreen,
        surface: AppColors.cardGreen,
        onSurface: AppColors.textWhite,
        error: AppColors.error,
        onError: AppColors.textWhite,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.cardGreen,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDarkGreen,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.gold),
        titleTextStyle: titleFont.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.gold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.primaryDarkGreen,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: titleFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: titleFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightGold,
          textStyle: titleFont.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryGreen,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.mutedText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: titleFont.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: titleFont.copyWith(fontSize: 12),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
      ),
    );
  }
}
