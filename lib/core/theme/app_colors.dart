import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryDarkGreen = Color(0xFF0B2A20);
  static const Color secondaryGreen = Color(0xFF123D2E);
  static const Color cardGreen = Color(0xFF163F31);
  static const Color gold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF5D27A);
  static const Color textWhite = Color(0xFFF8F8F8);
  static const Color mutedText = Color(0xFFA7B0A8);
  static const Color error = Color(0xFFD9534F);
  static const Color success = Color(0xFF4CAF50);

  static Color get goldTint => gold.withValues(alpha: 0.08);
  static Color get goldBorderSoft => gold.withValues(alpha: 0.25);
}
