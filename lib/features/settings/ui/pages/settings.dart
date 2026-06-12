// =============================================================================
//  VeriRent NG — Settings Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/agents_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Notification toggles
  bool _pushNotifs = true;
  bool _emailNotifs = true;
  bool _smsNotifs = false;
  bool _newListingAlerts = true;
  bool _priceDropAlerts = true;

  // Appearance
  ThemeMode _themeMode = ThemeMode.system;

  // Privacy
  bool _shareSearchData = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: cs.surface,
                padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 12),
                child: Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () => Navigator.maybePop(context),
                    //   child: Container(
                    //     width: 38,
                    //     height: 38,
                    //     decoration: BoxDecoration(
                    //       color: cs.surfaceVariant,
                    //       borderRadius: BorderRadius.circular(
                    //         VeriRentRadius.sm,
                    //       ),
                    //       border: Border.all(color: cs.outlineVariant),
                    //     ),
                    //     child: Icon(
                    //       Icons.arrow_back_rounded,
                    //       size: 18,
                    //       color: cs.onSurface,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: VeriRentText.titleLarge.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Account ────────────────────────────────────────────
            _SectionHeader(label: 'Account'),
            _SettingsGroup(
              items: [
                _SettingsTile(
                  icon: Icons.person_outlined,
                  iconColor: cs.primary,
                  title: 'Edit Profile',
                  subtitle: 'Name · Photo · Bio',
                  onTap: () {
                    context.push('/profile');
                  },
                ),
                _SettingsTile(
                  icon: Icons.verified_user_outlined,
                  iconColor: VeriRentColors.green,
                  title: 'Verification & KYC',
                  subtitle: 'Identity · NIN · CAC',
                  trailing: _Badge(
                    label: 'Verified',
                    color: VeriRentColors.green,
                  ),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.lock_outlined,
                  iconColor: VeriRentColors.gold,
                  title: 'Change Password',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  iconColor: VeriRentColors.gold,
                  title: 'Subscription Plan',
                  subtitle: 'Pro Member · Renews Jun 2026',
                  onTap: () {},
                ),
              ],
            ),

            // ── Notifications ──────────────────────────────────────
            _SectionHeader(label: 'Notifications'),
            _SettingsGroup(
              items: [
                _ToggleTile(
                  icon: Icons.notifications_outlined,
                  iconColor: cs.primary,
                  title: 'Push Notifications',
                  subtitle: 'In-app alerts',
                  value: _pushNotifs,
                  onChanged: (v) => setState(() => _pushNotifs = v),
                ),
                _ToggleTile(
                  icon: Icons.email_outlined,
                  iconColor: VeriRentColors.primary300,
                  title: 'Email Notifications',
                  value: _emailNotifs,
                  onChanged: (v) => setState(() => _emailNotifs = v),
                ),
                _ToggleTile(
                  icon: Icons.sms_outlined,
                  iconColor: VeriRentColors.primary200,
                  title: 'SMS Alerts',
                  value: _smsNotifs,
                  onChanged: (v) => setState(() => _smsNotifs = v),
                ),
                _ToggleTile(
                  icon: Icons.home_outlined,
                  iconColor: VeriRentColors.gold,
                  title: 'New Listing Alerts',
                  subtitle: 'Matching your search filters',
                  value: _newListingAlerts,
                  onChanged: (v) => setState(() => _newListingAlerts = v),
                ),
                _ToggleTile(
                  icon: Icons.trending_down_rounded,
                  iconColor: VeriRentColors.green,
                  title: 'Price Drop Alerts',
                  value: _priceDropAlerts,
                  onChanged: (v) => setState(() => _priceDropAlerts = v),
                ),
              ],
            ),

            // ── Appearance ─────────────────────────────────────────
            _SectionHeader(label: 'Appearance'),
            _SettingsGroup(
              items: [
                _ThemeSelectorTile(
                  current: _themeMode,
                  onChanged: (v) => setState(() => _themeMode = v),
                ),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: cs.primary,
                  title: 'Language',
                  subtitle: 'English (Nigeria)',
                  onTap: () {},
                ),
              ],
            ),

            // ── Privacy ────────────────────────────────────────────
            _SectionHeader(label: 'Privacy & Data'),
            _SettingsGroup(
              items: [
                _ToggleTile(
                  icon: Icons.location_on_outlined,
                  iconColor: VeriRentColors.red,
                  title: 'Location Services',
                  subtitle: 'Used to show nearby listings',
                  value: _locationEnabled,
                  onChanged: (v) => setState(() => _locationEnabled = v),
                ),
                _ToggleTile(
                  icon: Icons.bar_chart_rounded,
                  iconColor: cs.primary,
                  title: 'Share Usage Analytics',
                  subtitle: 'Help us improve the app',
                  value: _shareSearchData,
                  onChanged: (v) => setState(() => _shareSearchData = v),
                ),
                _SettingsTile(
                  icon: Icons.policy_outlined,
                  iconColor: cs.primary,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  iconColor: cs.primary,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
              ],
            ),

            // ── Support ────────────────────────────────────────────
            _SectionHeader(label: 'Support'),
            _SettingsGroup(
              items: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  iconColor: cs.primary,
                  title: 'Help Centre',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: cs.primary,
                  title: 'Contact Support',
                  subtitle: 'support@verirent.ng',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.star_border_rounded,
                  iconColor: VeriRentColors.gold,
                  title: 'Rate VeriRent NG',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.share_outlined,
                  iconColor: cs.primary,
                  title: 'Share with Friends',
                  onTap: () {},
                ),
              ],
            ),

            // ── Sign Out ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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

            // ── Footer ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 88),
                child: Column(
                  children: [
                    Text(
                      'VeriRent NG  v1.0.0',
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A Nixel Technology Global Product',
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant.withOpacity(0.35),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sliver Helpers ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 6),
          child: Text(
            label.toUpperCase(),
            style: VeriRentText.labelSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1.0,
              fontSize: 11,
            ),
          ),
        ),
      );
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final isLast = i == items.length - 1;
            return Column(
              children: [
                items[i],
                if (!isLast)
                  Divider(height: 1, color: cs.outlineVariant, indent: 54),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ── Settings Tile ─────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(VeriRentRadius.sm),
        ),
        child: Icon(icon, size: 17, color: iconColor),
      ),
      title: Text(
        title,
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
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: cs.onSurfaceVariant,
                )
              : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ── Toggle Tile ───────────────────────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(VeriRentRadius.sm),
        ),
        child: Icon(icon, size: 17, color: iconColor),
      ),
      title: Text(
        title,
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ── Theme Selector ────────────────────────────────────────────────────────────
class _ThemeSelectorTile extends StatelessWidget {
  const _ThemeSelectorTile({required this.current, required this.onChanged});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  size: 17,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Theme',
                style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemeOption(
                label: 'Light',
                icon: Icons.light_mode_rounded,
                selected: current == ThemeMode.light,
                onTap: () => onChanged(ThemeMode.light),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
                selected: current == ThemeMode.dark,
                onTap: () => onChanged(ThemeMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'System',
                icon: Icons.settings_brightness_rounded,
                selected: current == ThemeMode.system,
                onTap: () => onChanged(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.brightness == Brightness.dark
                    ? cs.primary
                    : cs.surface
                : cs.surfaceVariant,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(
              color: selected ? VeriRentColors.primary : cs.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? VeriRentColors.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: VeriRentText.labelSmall.copyWith(
                  color:
                      selected ? VeriRentColors.primary : cs.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
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
