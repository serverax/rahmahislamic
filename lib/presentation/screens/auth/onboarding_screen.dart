import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(languageControllerProvider.notifier).completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      _OnboardPage(
        icon: PhosphorIconsFill.bookOpen,
        title: l10n.onboarding1Title,
        body: l10n.onboarding1Body,
      ),
      _OnboardPage(
        icon: PhosphorIconsFill.mosque,
        title: l10n.onboarding2Title,
        body: l10n.onboarding2Body,
      ),
      _OnboardPage(
        icon: PhosphorIconsFill.handsPraying,
        title: l10n.onboarding3Title,
        body: l10n.onboarding3Body,
      ),
    ];
    final isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.skip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: active ? 24 : 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.gold : AppColors.mutedText.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
                child: Text(isLast ? l10n.getStarted : l10n.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardGreen,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  blurRadius: 32,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, size: 72, color: AppColors.gold),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.mutedText,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
