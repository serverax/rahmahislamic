class IconAssets {
  IconAssets._();

  static const String mosque = 'assets/icons/mosque.png';
  static const String mosque3D = 'assets/icons/mosque_3d.png';
  static const String quran = 'assets/icons/quran.png';
  static const String quran3D = 'assets/icons/quran_3d.png';
  static const String tasbih = 'assets/icons/tasbih.png';
  static const String tasbih3D = 'assets/icons/tasbih_3d.png';
  static const String duaHands = 'assets/icons/dua_hands.png';
  static const String dua3D = 'assets/icons/dua_3d.png';

  /// Source file is JPG (no alpha). Renders a checker pattern outside the
  /// compass disc; consume via ClipOval to hide the corners.
  static const String qibla3D = 'assets/icons/qibla_3d.jpg';

  /// Reserved for the Ask Sheikh feature (Slice 7). Not yet wired into UI.
  static const String sheikh3D = 'assets/icons/sheikh_3d.png';

  static const String books3D = 'assets/icons/books_3d.png';

  /// Reserved for the Dream Interpretation feature (Phase 2, post-MVP).
  /// See DREAM_INTERPRETATION_PLAN.md. Note: this icon has "RAHMAH" branding
  /// and Arabic title "تفسير الأحلام" baked into the artwork — Arabic-only
  /// feature, brand-suffix mismatch with current "Rahma" wordmark elsewhere.
  static const String dream3D = 'assets/icons/dream_3d.png';
}
