import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router/app_router.gr.dart';
import '../../../core/formatting/app_formats.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/presentation/sign_in_prompt.dart';
import '../../session/session_controller.dart';
import '../domain/dose_schedule.dart';
import 'today_controller.dart';
import 'widgets/date_strip.dart';
import 'widgets/dose_card.dart';
import 'widgets/progress_summary_card.dart';

/// Home: greeting, date selector, progress and the selected day's plan.
@RoutePage()
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  /// Selector for the `greeting` ICU message.
  static String dayPeriod(DateTime now) => switch (now.hour) {
    < 12 => 'morning',
    < 17 => 'afternoon',
    _ => 'evening',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final plan = ref.watch(dayPlanProvider);
    final now = ref.watch(clockProvider)();
    // Guests have no profile, so they are greeted without a name.
    final firstName = ref.watch(
      sessionProvider.select((s) => s.profile?.firstName),
    );
    final days = DayUtils.daysAround(plan.today, dateRangeRadius);
    final occasions = plan.occasions;

    void log(DoseOccasion occasion, DoseStatus status) {
      final logs = ref.read(doseLogProvider.notifier);
      final previous = ref.read(doseLogProvider)[occasion.id];
      logs.log(occasion.id, status);
      HapticFeedback.lightImpact();
      TopSnackbar.show(
        context,
        message: l10n.doseLogged(
          status.name,
          occasion.medicine.name,
          AppFormats.time(context, occasion.time),
        ),
        tone: status == DoseStatus.taken ? SnackTone.success : SnackTone.info,
        actionLabel: l10n.actionUndo,
        onAction: () => logs.restore(occasion.id, previous),
      );
    }

    const gutter = EdgeInsets.symmetric(horizontal: AppSpacing.page);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ContentWidth(
                child: _Header(
                  greeting: firstName == null
                      ? l10n.greetingGuest(dayPeriod(now))
                      : l10n.greeting(dayPeriod(now), firstName),
                  date: plan.date,
                  isToday: plan.isToday,
                  onToday: ref.read(selectedDateProvider.notifier).selectToday,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DateStrip(
                days: days,
                selected: plan.date,
                today: plan.today,
                onSelected: ref.read(selectedDateProvider.notifier).select,
              ),
            ),
            SliverPadding(
              padding: gutter.copyWith(top: AppSpacing.xl),
              sliver: SliverToBoxAdapter(
                child: ContentWidth(
                  child: Column(
                    children: [
                      ProgressSummaryCard(progress: plan.progress),
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(
                        title: plan.isToday
                            ? l10n.todayPlanTitle
                            : l10n.planForDate(plan.date),
                        trailing: occasions.isEmpty
                            ? null
                            : Text(
                                l10n.doseCount(occasions.length),
                                style: context.text.bodySmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (occasions.isEmpty)
              SliverPadding(
                padding: gutter,
                sliver: SliverToBoxAdapter(
                  child: ContentWidth(
                    child: AppCard(
                      child: EmptyState(
                        icon: Icons.event_available_rounded,
                        title: l10n.emptyPlanTitle,
                        message: l10n.emptyPlanMessage(plan.date),
                        action: AppButton.secondary(
                          label: l10n.addMedicine,
                          icon: const Icon(Icons.add_rounded),
                          onPressed: () => runIfCanManageMedicines(
                            context,
                            ref,
                            () => context.router.push(const AddMedicineRoute()),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              // Built lazily: only visible cards are laid out.
              SliverPadding(
                padding: gutter,
                sliver: SliverList.separated(
                  itemCount: occasions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final occasion = occasions[index];
                    return ContentWidth(
                      child: DoseCard(
                        occasion: occasion,
                        canLog: plan.canLog,
                        display: DoseDisplay.of(
                          status: plan.statusOf(occasion),
                          scheduledAt: occasion.scheduledAt,
                          now: now,
                          canLog: plan.canLog,
                        ),
                        onLog: (status) => log(occasion, status),
                        onUndo: () => ref
                            .read(doseLogProvider.notifier)
                            .clear(occasion.id),
                      ),
                    );
                  },
                ),
              ),
            SliverPadding(
              padding: gutter.copyWith(
                top: AppSpacing.xl,
                bottom: AppSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: ContentWidth(
                  child: PrototypeNotice(message: l10n.todayNotice),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.date,
    required this.isToday,
    required this.onToday,
  });

  final String greeting;
  final DateTime date;
  final bool isToday;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    greeting,
                    key: const ValueKey('greeting'),
                    style: context.text.headlineSmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isToday ? l10n.todayWithDate(date) : l10n.longDate(date),
                  key: const ValueKey('selected-date-label'),
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!isToday)
            AppButton.text(
              key: const ValueKey('jump-today'),
              label: l10n.jumpToToday,
              icon: const Icon(Icons.today_rounded),
              compact: true,
              onPressed: onToday,
            ),
        ],
      ),
    );
  }
}
