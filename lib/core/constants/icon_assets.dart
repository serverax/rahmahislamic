class IconAssets {
  IconAssets._();

  /// 8 premium 3D icons, exported as 512x512 WebP (quality 90, method 6).
  /// Source PNGs/JPGs ranged 130KB-2.3MB each; WebPs are 24-50KB.
  /// Optimization run: tools/optimize_icons.py
  static const String mosque3D = 'assets/icons/mosque_3d.webp';
  static const String quran3D = 'assets/icons/quran_3d.webp';
  static const String tasbih3D = 'assets/icons/tasbih_3d.webp';
  static const String dua3D = 'assets/icons/dua_3d.webp';

  /// qibla_3d.webp inherits the AI-generator's checker pattern from the
  /// original JPG source (alpha-as-checker). Consume via ClipOval to hide
  /// the corners; the compass disc is centered.
  static const String qibla3D = 'assets/icons/qibla_3d.webp';

  /// Reserved for the Ask Sheikh feature (Slice 7). Not yet wired into UI.
  static const String sheikh3D = 'assets/icons/sheikh_3d.webp';

  static const String books3D = 'assets/icons/books_3d.webp';

  /// Reserved for the Dream Interpretation feature (Phase 2, post-MVP).
  /// See DREAM_INTERPRETATION_PLAN.md. Note: artwork has "RAHMAH" branding
  /// + Arabic title baked in.
  static const String dream3D = 'assets/icons/dream_3d.webp';
}
