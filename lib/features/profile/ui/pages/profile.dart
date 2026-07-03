// =============================================================================
//  VeriRent NG — Profile Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/profile/ui/pages/change_password.dart';
import 'package:verirent/features/profile/ui/pages/edit_profile.dart';
import 'package:verirent/features/profile/ui/pages/my_listing.dart';
import 'package:verirent/features/profile/ui/pages/search_alerts.dart';
import 'package:verirent/features/profile/ui/pages/subscription.dart';
import 'package:verirent/features/profile/ui/pages/verification.dart';
import 'package:verirent/features/settings/ui/pages/help_center.dart';
import 'package:verirent/features/settings/ui/pages/rate.dart';

import '../../../../core/theme/agents_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── Hero Header ────────────────────────────────────────────
            SliverToBoxAdapter(child: _ProfileHero(topPad: topPad)),
            // ── Stats Row ──────────────────────────────────────────────
            const SliverToBoxAdapter(child: _StatsRow()),
            // ── Verification Banner ────────────────────────────────────
            // const SliverToBoxAdapter(child: _VerificationBanner()),
            // ── Account Section ────────────────────────────────────────
            SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Account',
                items: [
                  _MenuItem(
                    icon: Icons.person_outlined,
                    iconColor: cs.primary,
                    label: 'Edit Profile',
                    subtitle: 'Name, photo, bio',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.verified_user_outlined,
                    iconColor: VeriRentColors.green,
                    label: 'Verification Status',
                    subtitle: 'KYC · NIN · CAC',
                    trailing: _StatusChip(
                      label: 'Verified',
                      color: VeriRentColors.green,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerificationKycPage(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.lock_outlined,
                    label: 'Change Password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.workspace_premium_outlined,
                    iconColor: VeriRentColors.gold,
                    label: 'Subscription PLan',
                    subtitle: 'Pro Member · Renews Jun 2026',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlanPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Listings Section ───────────────────────────────────────
            SliverToBoxAdapter(
              child: _MenuSection(
                title: 'My Properties',
                items: [
                  _MenuItem(
                    icon: Icons.home_work_outlined,
                    label: 'My Listings',
                    subtitle: '0 active properties',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyListingsPage()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.search_rounded,
                    label: 'Search Alerts',
                    subtitle: '2 active alerts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchAlertsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Preferences Section ────────────────────────────────────
            // SliverToBoxAdapter(
            //   child: _MenuSection(
            //     title: 'Preferences',
            //     items: [
            //       _MenuItem(
            //         icon: Icons.notifications_outlined,
            //         label: 'Notifications',
            //         onTap: () {},
            //       ),
            //       _MenuItem(
            //         icon: Icons.palette_outlined,
            //         label: 'Appearance',
            //         subtitle: 'Theme · Language',
            //         onTap: () {},
            //       ),
            //       _MenuItem(
            //         icon: Icons.payment_outlined,
            //         label: 'Payment Methods',
            //         onTap: () {},
            //       ),
            //     ],
            //   ),
            // ),
            // ── Support Section ────────────────────────────────────────
            SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help Centre',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpCentrePage()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.star_border_rounded,
                    label: 'Rate VeriRent NG',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RateAppPage()),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutDialog()),
                    ),
                  ),
                ],
              ),
            ),

            // ── Danger zone ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _MenuSection(
                title: 'Danger zone',
                items: [
                  _MenuItem(
                    icon: Icons.delete_outline_rounded,
                    iconColor: VeriRentColors.red,
                    label: 'Delete Account',
                    onTap: () => _showDeleteConfirm(context),
                  ),
                ],
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: cs.surface,
            //         borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            //         border: Border.all(color: cs.outlineVariant),
            //       ),
            //       child: ListTile(
            //         onTap: () => _showDeleteConfirm(context),
            //         leading: Container(
            //           width: 34,
            //           height: 34,
            //           decoration: BoxDecoration(
            //             color: VeriRentColors.red.withOpacity(0.10),
            //             borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            //           ),
            //           child: const Icon(
            //             Icons.delete_outline_rounded,
            //             size: 16,
            //             color: VeriRentColors.red,
            //           ),
            //         ),
            //         title: Text(
            //           'Delete Account',
            //           style: VeriRentText.bodyMedium.copyWith(
            //             color: VeriRentColors.red,
            //           ),
            //         ),
            //         subtitle: Text(
            //           'Permanently remove your account and data',
            //           style: VeriRentText.bodySmall.copyWith(
            //             color: cs.onSurfaceVariant,
            //           ),
            //         ),
            //         trailing: const Icon(
            //           Icons.chevron_right_rounded,
            //           size: 18,
            //           color: VeriRentColors.red,
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 4,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            // ── Sign Out ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: VeriRentColors.red,
                  ),
                  label: Text(
                    'Sign Out',
                    style: VeriRentText.labelLarge.copyWith(
                      color: VeriRentColors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: VeriRentColors.red, width: 1),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ),
            // ── Nixel branding ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                child: Center(
                  child: Text(
                    'A Nixel Technology Global Product',
                    style: VeriRentText.bodySmall.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDeleteConfirm(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Account?'),
      content: const Text(
        'This will permanently delete your Agent NG account, '
        'all your listings, saved properties, and personal data. '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Delete', style: TextStyle(color: VeriRentColors.red)),
        ),
      ],
    ),
  );
}

// ── Profile Hero ──────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.topPad});
  final double topPad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        topPad + VeriRentSpacing.md,
        VeriRentSpacing.base,
        VeriRentSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VeriRentColors.primary700, VeriRentColors.primary500],
        ),
      ),
      child: Column(
        children: [
          // Back / Settings row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: VeriRentColors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: VeriRentColors.white,
                    size: 18,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Profile',
                style: VeriRentText.titleLarge.copyWith(
                  color: VeriRentColors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.push("/settings");
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: VeriRentColors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: VeriRentColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Avatar ring
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: VeriRentColors.secondary400,
                    width: 3,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      VeriRentColors.secondary400,
                      VeriRentColors.secondary600,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    'CP',
                    style: VeriRentText.headlineMedium.copyWith(
                      color: VeriRentColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: VeriRentColors.success500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: VeriRentColors.primary600,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  size: 13,
                  color: VeriRentColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Charles Praise',
            style: VeriRentText.headlineSmall.copyWith(
              color: VeriRentColors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Tenant  ·  Member since 2025',
            style: VeriRentText.bodySmall.copyWith(
              color: VeriRentColors.white.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 10),

          // Tier badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: VeriRentColors.goldDim,
              borderRadius: BorderRadius.circular(VeriRentRadius.full),
              border: Border.all(color: VeriRentColors.gold.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 13,
                  color: VeriRentColors.gold,
                ),
                const SizedBox(width: 5),
                Text(
                  'Pro Member',
                  style: VeriRentText.labelSmall.copyWith(
                    color: VeriRentColors.gold,
                    fontSize: 11,
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

// ── Stats Row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(value: '4', label: 'Saved'),
            VerticalDivider(color: cs.outlineVariant, width: 1),
            _StatItem(value: '23', label: 'Viewed'),
            VerticalDivider(color: cs.outlineVariant, width: 1),
            _StatItem(value: '2', label: 'Enquiries'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: VeriRentText.headlineMedium.copyWith(color: cs.primary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Verification Banner ───────────────────────────────────────────────────────
class _VerificationBanner extends StatelessWidget {
  const _VerificationBanner();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VeriRentColors.primaryDim,
        borderRadius: BorderRadius.circular(VeriRentRadius.md),
        border: Border.all(color: VeriRentColors.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: VeriRentColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 18,
              color: VeriRentColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identity Verified',
                  style: VeriRentText.titleSmall.copyWith(
                    color: VeriRentColors.primary,
                  ),
                ),
                Text(
                  'NIN · BVN confirmed  ·  KYC passed',
                  style: VeriRentText.bodySmall.copyWith(
                    color: VeriRentColors.primary.withOpacity(0.70),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: VeriRentColors.primary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

// ── Menu Section ──────────────────────────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: VeriRentText.labelMedium.copyWith(
                color: cs.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isLast = i == items.length - 1;
                return Column(
                  children: [
                    item,
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: cs.outlineVariant,
                        indent: 54,
                        endIndent: 0,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.iconColor,
  });
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(VeriRentRadius.sm),
        ),
        child: Icon(icon, size: 18, color: iconColor ?? cs.onSurfaceVariant),
      ),
      title: Text(
        label,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: cs.onSurfaceVariant,
          ),
    );
  }
}

// ── Status Chip ───────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(VeriRentRadius.full),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Text(
      label,
      style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 10),
    ),
  );
}
