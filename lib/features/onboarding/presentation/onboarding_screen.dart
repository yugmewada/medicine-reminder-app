import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';

class OnboardingPage {
  const OnboardingPage({
    required this.art,
    required this.title,
    required this.body,
  });

  final FeatureArtKind art;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;
}

/// Three-page walkthrough. Skippable at any point; asks for no permissions
/// and creates no account.
@RoutePage()
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static final pages = [
    OnboardingPage(
      art: FeatureArtKind.inventory,
      title: (l) => l.onboardingInventoryTitle,
      body: (l) => l.onboardingInventoryBody,
    ),
    OnboardingPage(
      art: FeatureArtKind.plan,
      title: (l) => l.onboardingPlanTitle,
      body: (l) => l.onboardingPlanBody,
    ),
    OnboardingPage(
      art: FeatureArtKind.progress,
      title: (l) => l.onboardingProgressTitle,
      body: (l) => l.onboardingProgressBody,
    ),
  ];

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == OnboardingScreen.pages.length - 1;

  void _finish() => ref.read(sessionProvider.notifier).finishOnboarding();

  void _goTo(int page) {
    final duration = AppMotion.of(context, AppMotion.medium);
    if (duration == Duration.zero) {
      _controller.jumpToPage(page);
    } else {
      _controller.animateToPage(
        page,
        duration: duration,
        curve: AppMotion.emphasized,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingScreen.pages;
    final l10n = context.l10n;
    return PopScope(
      // System back steps to the previous page before leaving.
      canPop: _page == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(_page - 1);
      },
      child: Scaffold(
        body: SafeArea(
          child: ContentWidth(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      0,
                    ),
                    child: AnimatedOpacity(
                      opacity: _isLast ? 0 : 1,
                      duration: AppMotion.of(context, AppMotion.short),
                      child: IgnorePointer(
                        ignoring: _isLast,
                        child: AppButton.text(
                          key: const ValueKey('onboarding-skip'),
                          label: l10n.onboardingSkip,
                          onPressed: _finish,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (page) => setState(() => _page = page),
                    itemBuilder: (context, index) =>
                        _OnboardingPageView(page: pages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.lg,
                    AppSpacing.page,
                    AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      PageDots(count: pages.length, index: _page),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        key: const ValueKey('onboarding-next'),
                        label: _isLast
                            ? l10n.onboardingGetStarted
                            : l10n.onboardingNext,
                        expand: true,
                        onPressed: _isLast ? _finish : () => _goTo(_page + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Art takes about half the space; text scrolls if it needs more.
        final artHeight = (constraints.maxHeight * 0.55).clamp(140.0, 360.0);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: artHeight,
                width: double.infinity,
                child: FeatureArt(kind: page.art),
              ),
              const SizedBox(height: AppSpacing.xl),
              Semantics(
                header: true,
                child: Text(
                  page.title(context.l10n),
                  textAlign: TextAlign.center,
                  style: context.text.headlineSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                page.body(context.l10n),
                textAlign: TextAlign.center,
                style: context.text.bodyLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Page indicator. The active dot is wider, not only a different color.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.onboardingPageLabel(index + 1, count),
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.medium),
              curve: AppMotion.enter,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              width: i == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? colors.primary : colors.outline,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
