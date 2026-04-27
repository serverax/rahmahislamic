import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/rahma_app_bar.dart';
import '../adhkar/adhkar_home_screen.dart';
import '../quran/quran_home_screen.dart';
import '../quran/quran_search_screen.dart';
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
        title: l10n.appName,
        icon: PhosphorIconsRegular.house,
        activeIcon: PhosphorIconsFill.house,
        body: const HomeTab(),
      ),
      _TabSpec(
        label: l10n.quran,
        title: l10n.quran,
        icon: PhosphorIconsRegular.bookOpen,
        activeIcon: PhosphorIconsFill.bookOpen,
        body: const QuranHomeScreen(embedded: true),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.search,
            onPressed: () {
              final ctx = _appBarKey.currentContext ?? context;
              Navigator.of(ctx).push(
                MaterialPageRoute(builder: (_) => const QuranSearchScreen()),
              );
            },
          ),
        ],
      ),
      _TabSpec(
        label: l10n.adhkar,
        title: l10n.adhkar,
        icon: PhosphorIconsRegular.handsPraying,
        activeIcon: PhosphorIconsFill.handsPraying,
        body: const AdhkarHomeScreen(embedded: true),
      ),
      _TabSpec(
        label: l10n.dua,
        title: l10n.dua,
        icon: PhosphorIconsRegular.handHeart,
        activeIcon: PhosphorIconsFill.handHeart,
        body: _Placeholder(icon: PhosphorIconsFill.handHeart, message: l10n.duaComingSoon),
      ),
      _TabSpec(
        label: l10n.more,
        title: l10n.more,
        icon: PhosphorIconsRegular.dotsThreeOutline,
        activeIcon: PhosphorIconsFill.dotsThreeOutline,
        body: _Placeholder(icon: PhosphorIconsFill.dotsThreeOutline, message: l10n.moreComingSoon),
      ),
    ];

    final current = tabs[_index];

    return Scaffold(
      appBar: RahmaAppBar(
        key: _appBarKey,
        title: current.title,
        actions: current.actions,
      ),
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

  final GlobalKey _appBarKey = GlobalKey();
}

class _TabSpec {
  const _TabSpec({
    required this.label,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.body,
    this.actions,
  });

  final String label;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget body;
  final List<Widget>? actions;
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
