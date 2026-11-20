import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/navigation/app_transitions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider);
    final isGuest = session.isGuest;
    final version = l10n.versionWithBuild(
      AppInfo.versionName,
      AppInfo.buildNumber,
    );

    // Signed-in users only; guests leave via Sign in in the profile card.
    Future<void> logout() async {
      final confirmed = await AppDialogs.confirm(
        context,
        title: l10n.logoutConfirmTitle,
        message: l10n.logoutConfirmMessage,
        confirmLabel: l10n.logoutTitle,
        icon: Icons.logout_rounded,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      // Shown first: the router replaces this screen once the session resets.
      TopSnackbar.show(context, message: l10n.loggedOut);
      ref.read(sessionProvider.notifier).logout();
    }

    void info(IconData icon, String title, String message) =>
        AppDialogs.info(context, icon: icon, title: title, message: message);

    const divider = Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg);

    return Scaffold(
      appBar: AppToolbar(title: l10n.profileTitle),
      body: ListView(
        // Clear the floating tab bar.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxl + context.bottomBarInset,
        ),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(session: session),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(title: l10n.aboutSection),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Column(
                    children: [
                      ActionRow(
                        key: const ValueKey('row-terms'),
                        icon: Icons.gavel_rounded,
                        title: l10n.termsTitle,
                        subtitle: l10n.termsSubtitle,
                        onTap: () => info(
                          Icons.gavel_rounded,
                          l10n.termsTitle,
                          l10n.termsMessage,
                        ),
                      ),
                      divider,
                      ActionRow(
                        key: const ValueKey('row-privacy'),
                        icon: Icons.privacy_tip_outlined,
                        title: l10n.privacyTitle,
                        subtitle: l10n.privacySubtitle,
                        onTap: () => info(
                          Icons.privacy_tip_outlined,
                          l10n.privacyTitle,
                          l10n.privacyMessage,
                        ),
                      ),
                      divider,
                      ActionRow(
                        key: const ValueKey('row-share'),
                        icon: Icons.share_rounded,
                        title: l10n.shareTitle,
                        subtitle: l10n.shareSubtitle,
                        onTap: () => info(
                          Icons.share_rounded,
                          l10n.shareTitle,
                          l10n.shareMessage,
                        ),
                      ),
                      divider,
                      ActionRow(
                        key: const ValueKey('row-licenses'),
                        icon: Icons.description_outlined,
                        title: l10n.licensesTitle,
                        // Same page and navigator as showLicensePage, but
                        // with the app's screen transition (AppPageRoute).
                        onTap: () => Navigator.of(context).push(
                          AppPageRoute<void>(
                            settings: const RouteSettings(name: 'licenses'),
                            builder: (_) => LicensePage(
                              applicationName: l10n.appTitle,
                              applicationVersion: version,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isGuest) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: ActionRow(
                      key: const ValueKey('row-logout'),
                      icon: Icons.logout_rounded,
                      title: l10n.logoutTitle,
                      subtitle: l10n.logoutSubtitle,
                      destructive: true,
                      showChevron: false,
                      onTap: logout,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.versionLine(l10n.appTitle, version),
                  key: const ValueKey('app-version'),
                  textAlign: TextAlign.center,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Signed-in users see their (fictional) profile; guests see a generic
/// guest identity with a way to sign in.
class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final profile = session.profile;
    final brand = session.method?.brandName;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: profile == null
                ? AppAvatar(
                    icon: Icons.person_outline_rounded,
                    semanticLabel: l10n.guestAvatarLabel,
                  )
                : AppAvatar(
                    initials: profile.initials,
                    semanticLabel: l10n.avatarLabel(profile.fullName),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            profile?.fullName ?? l10n.guestName,
            style: context.text.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            profile?.email ?? l10n.guestSubtitle,
            style: muted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: StatusChip(
              key: const ValueKey('profile-chip'),
              icon: profile == null
                  ? Icons.person_outline_rounded
                  : Icons.science_outlined,
              tone: StatusTone.info,
              label: brand == null
                  ? l10n.guestModeChip
                  : l10n.demoProfileSimulated(brand),
            ),
          ),
          if (session.isGuest) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              key: const ValueKey('profile-sign-in'),
              label: l10n.signIn,
              icon: const Icon(Icons.login_rounded),
              expand: true,
              onPressed: ref.read(sessionProvider.notifier).requestSignIn,
            ),
          ],
        ],
      ),
    );
  }
}
