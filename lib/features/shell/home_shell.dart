import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/router/app_router.gr.dart';
import '../../core/l10n/l10n.dart';
import '../../core/navigation/app_transitions.dart';
import '../../core/widgets/widgets.dart';

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
            // Content scrolls behind the floating glass tab bar; the bar's
            // height is reported in MediaQuery padding (bottomBarInset).
            extendBody: true,
            body: AnimatedBranchContainer(
              currentIndex: index,
              children: children,
            ),
            bottomNavigationBar: AppTabBar(
              selectedIndex: index,
              onSelected: select,
              items: [
                AppTabItem(
                  key: const ValueKey('nav-today'),
                  icon: Icons.today_outlined,
                  selectedIcon: Icons.today_rounded,
                  label: l10n.navToday,
                ),
                AppTabItem(
                  key: const ValueKey('nav-inventory'),
                  icon: Icons.inventory_2_outlined,
                  selectedIcon: Icons.inventory_2_rounded,
                  label: l10n.navInventory,
                ),
                AppTabItem(
                  key: const ValueKey('nav-profile'),
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: l10n.navProfile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
