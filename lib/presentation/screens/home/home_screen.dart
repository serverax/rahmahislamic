import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/home_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final tabs = <_TabSpec>[
      _TabSpec(
        label: l10n.home,
        icon: PhosphorIconsRegular.house,
        activeIcon: PhosphorIconsFill.house,
        body: const HomeTab(),
      ),
      _TabSpec(
        label: l10n.quran,
        icon: PhosphorIconsRegular.bookOpen,
        activeIcon: PhosphorIconsFill.bookOpen,
        body: _Placeholder(icon: PhosphorIconsFill.bookOpen, message: l10n.quranComingSoon),
      ),
      _TabSpec(
        label: l10n.adhkar,
        icon: PhosphorIconsRegular.handsPraying,
        activeIcon: PhosphorIconsFill.handsPraying,
        body: _Placeholder(icon: PhosphorIconsFill.handsPraying, message: l10n.adhkarComingSoon),
      ),
      _TabSpec(
        label: l10n.more,
        icon: PhosphorIconsRegular.dotsThreeOutline,
        activeIcon: PhosphorIconsFill.dotsThreeOutline,
        body: _Placeholder(icon: PhosphorIconsFill.dotsThreeOutline, message: l10n.moreComingSoon),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: IndexedStack(
        index: _index,
        children: tabs.map((t) => t.body).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          for (final t in tabs)
            BottomNavigationBarItem(
              icon: Icon(t.icon),
              activeIcon: Icon(t.activeIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.body,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget body;
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardGreen,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 56, color: AppColors.gold),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
