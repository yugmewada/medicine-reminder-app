import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/router/app_router.gr.dart';
import '../../core/l10n/l10n.dart';
import '../../core/navigation/app_transitions.dart';

/// Signed-in shell with the persistent bottom navigation bar.
///
/// Tabs are an auto_route [AutoTabsRouter]: each tab keeps its own stack and
/// state, and switching fades through ([AnimatedBranchContainer]). Tapping
/// the active tab returns it to its first screen. System back on another tab
/// returns to Today before leaving the app.
@RoutePage(name: 'HomeShellRoute')
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const tabs = [TodayRoute(), InventoryTabRoute(), ProfileRoute()];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.builder(
      routes: tabs,
      builder: (context, children, tabsRouter) {
        final l10n = context.l10n;
        final index = tabsRouter.activeIndex;
        void select(int i) {
          if (i == index) {
            tabsRouter.stackRouterOfIndex(i)?.popUntilRoot();
          } else {
            tabsRouter.setActiveIndex(i);
          }
        }

        return PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) tabsRouter.setActiveIndex(0);
          },
          child: Scaffold(
            body: AnimatedBranchContainer(
              currentIndex: index,
              children: children,
            ),
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: NavigationBar(
                selectedIndex: index,
                onDestinationSelected: select,
                destinations: [
                  NavigationDestination(
                    key: const ValueKey('nav-today'),
                    icon: const Icon(Icons.today_outlined),
                    selectedIcon: const Icon(Icons.today_rounded),
                    label: l10n.navToday,
                  ),
                  NavigationDestination(
                    key: const ValueKey('nav-inventory'),
                    icon: const Icon(Icons.inventory_2_outlined),
                    selectedIcon: const Icon(Icons.inventory_2_rounded),
                    label: l10n.navInventory,
                  ),
                  NavigationDestination(
                    key: const ValueKey('nav-profile'),
                    icon: const Icon(Icons.person_outline_rounded),
                    selectedIcon: const Icon(Icons.person_rounded),
                    label: l10n.navProfile,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
