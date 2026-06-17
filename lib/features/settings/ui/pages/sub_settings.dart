// =============================================================================
//  VeriRent NG — Settings Sub-Pages
//  All pages referenced from SettingsPage navigation taps.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import '../../../../core/theme/agents_theme.dart';

// =============================================================================
//  SHARED HELPERS
// =============================================================================

/// Standard app-bar for settings sub-pages.
class _SubPageAppBar extends StatelessWidget {
  const _SubPageAppBar({required this.title, this.actions});
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: cs.surface,
      padding: EdgeInsets.fromLTRB(4, topPad + 4, 8, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Text(
              title,
              style: VeriRentText.titleLarge.copyWith(color: cs.onSurface),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/// Grouped card container consistent with SettingsPage.
class _Group extends StatelessWidget {
  const _Group({required this.children, this.margin});
  final List<Widget> children;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          final isLast = i == children.length - 1;
          return Column(
            children: [
              children[i],
              if (!isLast)
                Divider(height: 1, color: cs.outlineVariant, indent: 54),
            ],
          );
        }),
      ),
    );
  }
}

/// Section label, same as SettingsPage's _SectionHeader.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 16, 6),
    child: Text(
      label.toUpperCase(),
      style: VeriRentText.labelSmall.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.0,
        fontSize: 11,
      ),
    ),
  );
}

/// Coloured icon container.
Widget _iconBox(IconData icon, Color color) => Container(
  width: 34,
  height: 34,
  decoration: BoxDecoration(
    color: color.withOpacity(0.10),
    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
  ),
  child: Icon(icon, size: 17, color: color),
);

// =============================================================================
//  1.  VERIFICATION & KYC PAGE
// =============================================================================

class VerificationKycPage extends StatelessWidget {
  const VerificationKycPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(title: 'Verification & KYC'),
            ),

            // ── Status Banner ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VeriRentColors.success500,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Identity Verified',
                            style: VeriRentText.titleMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your account has full verification status.',
                            style: VeriRentText.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Identity ──────────────────────────────────────────
            SliverToBoxAdapter(child: _SectionLabel('Identity Documents')),
            SliverToBoxAdapter(
              child: _Group(
                children: [
                  _KycTile(
                    icon: Icons.badge_outlined,
                    iconColor: cs.primary,
                    title: 'National ID (NIN)',
                    subtitle: 'Verified · ****  ****  3782',
                    status: _KycStatus.verified,
                  ),
                  _KycTile(
                    icon: Icons.credit_card_outlined,
                    iconColor: VeriRentColors.tierVerified,
                    title: 'BVN Linkage',
                    subtitle: 'Verified · Bank: GTBank',
                    status: _KycStatus.verified,
                  ),
                  _KycTile(
                    icon: Icons.portrait_outlined,
                    iconColor: VeriRentColors.gold,
                    title: 'Selfie / Liveness Check',
                    subtitle: 'Completed · Jun 2025',
                    status: _KycStatus.verified,
                  ),
                ],
              ),
            ),

            // ── Professional ──────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionLabel('Professional Credentials'),
            ),
            SliverToBoxAdapter(
              child: _Group(
                children: [
                  _KycTile(
                    icon: Icons.workspace_premium_outlined,
                    iconColor: VeriRentColors.tierPro,
                    title: 'ESVARBON License',
                    subtitle: 'Valid · Expires Dec 2026',
                    status: _KycStatus.verified,
                  ),
                  _KycTile(
                    icon: Icons.apartment_outlined,
                    iconColor: VeriRentColors.tierProfessional,
                    title: 'NIESV Membership',
                    subtitle: 'Active member',
                    status: _KycStatus.verified,
                  ),
                  _KycTile(
                    icon: Icons.business_outlined,
                    iconColor: VeriRentColors.tierStarterAgency,
                    title: 'CAC Registration',
                    subtitle: 'Not submitted',
                    status: _KycStatus.pending,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ── Address ───────────────────────────────────────────
            SliverToBoxAdapter(child: _SectionLabel('Address Verification')),
            SliverToBoxAdapter(
              child: _Group(
                children: [
                  _KycTile(
                    icon: Icons.location_on_outlined,
                    iconColor: VeriRentColors.red,
                    title: 'Utility Bill / Proof of Address',
                    subtitle: 'Not submitted',
                    status: _KycStatus.pending,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ── CTA ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: const Text('Submit Remaining Documents'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
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

enum _KycStatus { verified, pending, failed }

class _KycTile extends StatelessWidget {
  const _KycTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final _KycStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget badge;
    switch (status) {
      case _KycStatus.verified:
        badge = _StatusBadge(
          label: 'Verified',
          color: VeriRentColors.success500,
        );
        break;
      case _KycStatus.pending:
        badge = _StatusBadge(label: 'Pending', color: VeriRentColors.gold);
        break;
      case _KycStatus.failed:
        badge = _StatusBadge(label: 'Failed', color: VeriRentColors.red);
        break;
    }
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon, iconColor),
      title: Text(
        title,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: badge,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
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

// =============================================================================
//  2.  CHANGE PASSWORD PAGE
// =============================================================================

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;

  // Strength checks
  bool get _hasLength => _newCtrl.text.length >= 8;
  bool get _hasUpper => _newCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _newCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newCtrl.text.contains(RegExp(r'[!@#\$&*~]'));
  int get _strength =>
      [_hasLength, _hasUpper, _hasNumber, _hasSpecial].where((b) => b).length;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SubPageAppBar(title: 'Change Password')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current password
                      _SectionLabel('Current Password'),
                      _PasswordField(
                        controller: _currentCtrl,
                        label: 'Current password',
                        show: _showCurrent,
                        onToggle: () =>
                            setState(() => _showCurrent = !_showCurrent),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter your current password'
                            : null,
                      ),

                      const SizedBox(height: 20),
                      _SectionLabel('New Password'),

                      // New password
                      _PasswordField(
                        controller: _newCtrl,
                        label: 'New password',
                        show: _showNew,
                        onToggle: () => setState(() => _showNew = !_showNew),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter a new password';
                          }
                          if (v.length < 8) {
                            return 'At least 8 characters required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Strength meter
                      _StrengthMeter(strength: _strength),

                      const SizedBox(height: 8),
                      _StrengthChecks(
                        hasLength: _hasLength,
                        hasUpper: _hasUpper,
                        hasNumber: _hasNumber,
                        hasSpecial: _hasSpecial,
                      ),

                      const SizedBox(height: 16),

                      // Confirm password
                      _PasswordField(
                        controller: _confirmCtrl,
                        label: 'Confirm new password',
                        show: _showConfirm,
                        onToggle: () =>
                            setState(() => _showConfirm = !_showConfirm),
                        validator: (v) {
                          if (v != _newCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Update Password'),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: VeriRentText.labelMedium.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.show,
    required this.onToggle,
    this.onChanged,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final bool show;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      onChanged: onChanged,
      validator: validator,
      style: VeriRentText.bodyMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outlined, size: 18),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.strength});
  final int strength;

  Color get _color {
    if (strength <= 1) return VeriRentColors.red;
    if (strength == 2) return VeriRentColors.gold;
    if (strength == 3) return VeriRentColors.warning500;
    return VeriRentColors.success500;
  }

  String get _label {
    if (strength <= 1) return 'Weak';
    if (strength == 2) return 'Fair';
    if (strength == 3) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(VeriRentRadius.full),
                child: LinearProgressIndicator(
                  value: strength / 4,
                  backgroundColor: cs.outlineVariant,
                  valueColor: AlwaysStoppedAnimation(_color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: VeriRentText.labelSmall.copyWith(color: _color),
            ),
          ],
        ),
      ],
    );
  }
}

class _StrengthChecks extends StatelessWidget {
  const _StrengthChecks({
    required this.hasLength,
    required this.hasUpper,
    required this.hasNumber,
    required this.hasSpecial,
  });
  final bool hasLength, hasUpper, hasNumber, hasSpecial;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _Check(label: '8+ chars', met: hasLength),
        _Check(label: 'Uppercase', met: hasUpper),
        _Check(label: 'Number', met: hasNumber),
        _Check(label: 'Symbol', met: hasSpecial),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.label, required this.met});
  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met
        ? VeriRentColors.success500
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: VeriRentText.bodySmall.copyWith(color: color)),
      ],
    );
  }
}

// =============================================================================
//  3.  SUBSCRIPTION PLAN PAGE
// =============================================================================

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  State<SubscriptionPlanPage> createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  int _selected = 1; // 0=Basic, 1=Pro, 2=Enterprise

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(title: 'Subscription Plan'),
            ),

            // Current plan chip
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    _iconBox(
                      Icons.workspace_premium_rounded,
                      VeriRentColors.gold,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          'Pro Member',
                          style: VeriRentText.titleMedium.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: VeriRentColors.gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                        border: Border.all(
                          color: VeriRentColors.gold.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        'Renews Jun 2026',
                        style: VeriRentText.labelSmall.copyWith(
                          color: VeriRentColors.gold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: _SectionLabel('Available Plans')),

            // Plan cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _PlanCard(
                      index: 0,
                      selected: _selected == 0,
                      name: 'Basic',
                      price: 'Free',
                      priceSub: 'Forever',
                      color: VeriRentColors.tierBasic,
                      features: const [
                        'Up to 3 listings',
                        'Standard search visibility',
                        'Basic verification badge',
                        'Email support',
                      ],
                      onTap: () => setState(() => _selected = 0),
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      index: 1,
                      selected: _selected == 1,
                      name: 'Pro',
                      price: '₦9,500',
                      priceSub: 'per month',
                      badge: 'Current',
                      color: VeriRentColors.gold,
                      features: const [
                        'Unlimited listings',
                        'Priority search ranking',
                        'Pro verified badge',
                        'Price drop alerts',
                        'Analytics dashboard',
                        'Priority support',
                      ],
                      onTap: () => setState(() => _selected = 1),
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      index: 2,
                      selected: _selected == 2,
                      name: 'Enterprise',
                      price: '₦45,000',
                      priceSub: 'per month',
                      badge: 'Best Value',
                      color: VeriRentColors.tierEnterprise,
                      features: const [
                        'Everything in Pro',
                        'Multi-agent accounts',
                        'White-label option',
                        'API access',
                        'Dedicated account manager',
                        'SLA guarantee',
                      ],
                      onTap: () => setState(() => _selected = 2),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: ElevatedButton(
                  onPressed: _selected == 1 ? null : () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    _selected == 1
                        ? 'Current Plan'
                        : _selected == 0
                        ? 'Downgrade to Basic'
                        : 'Upgrade to Enterprise',
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    side: BorderSide(color: VeriRentColors.red),
                    foregroundColor: VeriRentColors.red,
                  ),
                  child: Text(
                    'Cancel Subscription',
                    style: VeriRentText.labelLarge.copyWith(
                      color: VeriRentColors.red,
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.index,
    required this.selected,
    required this.name,
    required this.price,
    required this.priceSub,
    required this.color,
    required this.features,
    required this.onTap,
    this.badge,
  });
  final int index;
  final bool selected;
  final String name;
  final String price;
  final String priceSub;
  final Color color;
  final List<String> features;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: selected ? color : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
                ),
                const SizedBox(width: 8),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Text(
                      badge!,
                      style: VeriRentText.labelSmall.copyWith(
                        color: color,
                        fontSize: 9,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: VeriRentText.headlineMedium.copyWith(color: color),
                    ),
                    Text(
                      priceSub,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: color),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurface,
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

// =============================================================================
//  4.  LANGUAGE PAGE
// =============================================================================

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: GetIt.I<SettingsCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: cs.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();
            return Scaffold(
              backgroundColor: cs.surfaceVariant,
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _SubPageAppBar(title: 'Language')),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        'Choose your preferred language for the Agent NG interface.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionLabel('Interface Language'),
                  ),
                  SliverToBoxAdapter(
                    child: _Group(
                      children: state.languages
                          .map(
                            (l) => LangTile(
                              option: l,
                              selected: state.selectedLanguage == l.code,
                              onTap: () => cubit.updateSelectedLanguage(l.code),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
                      child: FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Save Language'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LangOption {
  const LangOption(this.code, this.name, this.flag);
  final String code, name, flag;
}

class LangTile extends StatelessWidget {
  const LangTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final LangOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Text(option.flag, style: const TextStyle(fontSize: 22)),
      title: Text(
        option.name,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: cs.primary, size: 20)
          : Icon(
              Icons.radio_button_unchecked_rounded,
              color: cs.outlineVariant,
              size: 20,
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// =============================================================================
//  5.  PRIVACY POLICY PAGE
// =============================================================================

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(
                title: 'Privacy Policy',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShareWithFriendsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _iconBox(Icons.policy_outlined, cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VeriRent NG Privacy Policy',
                                style: VeriRentText.titleMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'Last updated: 1 January 2026',
                                style: VeriRentText.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._privacySections.map(
                      (s) => _LegalSection(heading: s.$1, body: s.$2),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.heading, required this.body});
  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

const _privacySections = [
  (
    '1. Data We Collect',
    'We collect information you provide directly, such as your name, NIN, BVN, professional credentials, and contact details. We also collect usage data, device identifiers, and location data when you enable location services.',
  ),
  (
    '2. How We Use Your Data',
    'Your data is used to verify your identity, match you with relevant rental listings, communicate service updates, and improve the platform. We do not sell your personal data to third parties.',
  ),
  (
    '3. NDPR Compliance',
    'VeriRent NG complies fully with the Nigeria Data Protection Regulation (NDPR) 2019. We process your data lawfully, with your consent, and you have the right to access, rectify, or delete your information at any time.',
  ),
  (
    '4. Data Sharing',
    'We share data with licensed estate agents and surveyors as part of the verification process, and with payment processors for subscription billing. All partners are bound by strict data protection agreements.',
  ),
  (
    '5. Data Retention',
    'We retain your data for as long as your account is active, or as required by Nigerian law. You may request deletion of your account and associated data by contacting support@verirent.ng.',
  ),
  (
    '6. Security',
    'We use AES-256 encryption for data at rest, TLS 1.3 for data in transit, and conduct regular third-party security audits. Access to personal data is restricted to authorised personnel only.',
  ),
  (
    '7. Contact',
    'For privacy-related queries, contact our Data Protection Officer at dpo@verirent.ng or write to Nixel Technology Global, Port Harcourt, Rivers State, Nigeria.',
  ),
];

// =============================================================================
//  6.  TERMS OF SERVICE PAGE
// =============================================================================

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(title: 'Terms of Service'),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _iconBox(Icons.description_outlined, cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms of Service',
                                style: VeriRentText.titleMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'Effective: 1 January 2026',
                                style: VeriRentText.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._termsSections.map(
                      (s) => _LegalSection(heading: s.$1, body: s.$2),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

const _termsSections = [
  (
    '1. Acceptance of Terms',
    'By accessing or using VeriRent NG ("the Platform"), you agree to be bound by these Terms of Service and all applicable Nigerian laws and regulations. If you do not agree, please discontinue use immediately.',
  ),
  (
    '2. Platform Purpose',
    'VeriRent NG is a professional certification marketplace for rental property. The platform connects tenants with ESVARBON and NIESV-licensed estate surveyors and valuers in Nigeria.',
  ),
  (
    '3. User Eligibility',
    'You must be at least 18 years of age and a resident or citizen of Nigeria to use the Platform. Professional practitioners must hold valid, current licences from ESVARBON or NIESV.',
  ),
  (
    '4. Verification & Accuracy',
    'All credentials submitted for verification must be genuine. Submitting false documents is a criminal offence under Nigerian law and will result in immediate account termination and referral to relevant authorities.',
  ),
  (
    '5. Fees & Payments',
    'Subscription fees are charged in Nigerian Naira (₦). Payments are processed securely via Paystack. All fees are non-refundable except as required by law.',
  ),
  (
    '6. Prohibited Conduct',
    'You may not use the Platform for fraudulent listings, identity impersonation, harassment of other users, or any activity that violates the Recovery of Premises Law of Rivers State or any applicable Nigerian statute.',
  ),
  (
    '7. Limitation of Liability',
    'Nixel Technology Global is not liable for disputes between landlords and tenants, or for losses arising from reliance on listing information. The Platform provides a verification service, not a tenancy guarantee.',
  ),
  (
    '8. Governing Law',
    'These Terms are governed by the laws of the Federal Republic of Nigeria. Disputes shall be resolved by arbitration in Port Harcourt, Rivers State.',
  ),
];

// =============================================================================
//  7.  HELP CENTRE PAGE
// =============================================================================

class HelpCentrePage extends StatefulWidget {
  const HelpCentrePage({super.key});

  @override
  State<HelpCentrePage> createState() => _HelpCentrePageState();
}

class _HelpCentrePageState extends State<HelpCentrePage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _expandedIndex;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = _faqItems
        .where(
          (f) =>
              _query.isEmpty ||
              f.q.toLowerCase().contains(_query.toLowerCase()) ||
              f.a.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SubPageAppBar(title: 'Help Centre')),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search FAQs...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(child: _SectionLabel('Quick Help')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _QuickHelpChip(
                      icon: Icons.verified_user_outlined,
                      label: 'Verification',
                      onTap: () => setState(() => _query = 'verification'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.home_outlined,
                      label: 'Listings',
                      onTap: () => setState(() => _query = 'listing'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.payment_outlined,
                      label: 'Billing',
                      onTap: () => setState(() => _query = 'payment'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.lock_outlined,
                      label: 'Account',
                      onTap: () => setState(() => _query = 'account'),
                    ),
                  ],
                ),
              ),
            ),

            // FAQs
            SliverToBoxAdapter(
              child: _SectionLabel('Frequently Asked Questions'),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No results for "$_query"',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(filtered.length, (i) {
                          final isLast = i == filtered.length - 1;
                          return Column(
                            children: [
                              _FaqTile(
                                item: filtered[i],
                                expanded: _expandedIndex == i,
                                onTap: () => setState(() {
                                  _expandedIndex = _expandedIndex == i
                                      ? null
                                      : i;
                                }),
                              ),
                              if (!isLast)
                                Divider(height: 1, color: cs.outlineVariant),
                            ],
                          );
                        }),
                      ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: _Group(
                  margin: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: _iconBox(
                        Icons.chat_bubble_outline_rounded,
                        cs.primary,
                      ),
                      title: Text(
                        'Still need help?',
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Contact our support team',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactSupportPage(),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

class _QuickHelpChip extends StatelessWidget {
  const _QuickHelpChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: VeriRentText.labelSmall.copyWith(
                  color: cs.onSurface,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem(this.q, this.a);
  final String q, a;
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.item,
    required this.expanded,
    required this.onTap,
  });
  final _FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(
            item.q,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          ),
          trailing: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              item.a,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.65,
              ),
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
        ),
      ],
    );
  }
}

const _faqItems = [
  _FaqItem(
    'How does verification work on VeriRent NG?',
    'VeriRent NG verifies your identity using NIN and BVN checks, and confirms professional credentials against ESVARBON and NIESV registries. The process is fully automated and typically takes 24–48 hours.',
  ),
  _FaqItem(
    'How do I list a property?',
    'Navigate to the Listings tab, tap the "+" button, and follow the guided process to enter property details, upload photos, set pricing, and submit for review. Listings go live within 2 hours of approval.',
  ),
  _FaqItem(
    'What payment methods are accepted?',
    'We accept all major Nigerian debit cards (Verve, Mastercard, Visa), bank transfers, and USSD payments via Paystack. All transactions are secured with 3DS authentication.',
  ),
  _FaqItem(
    'Can I change or cancel my subscription?',
    'Yes. You can upgrade, downgrade, or cancel your plan at any time from Settings → Subscription Plan. Changes take effect at the start of the next billing cycle.',
  ),
  _FaqItem(
    'How do I reset my password?',
    'Go to Settings → Change Password, or on the login screen tap "Forgot Password". A one-time link will be sent to your registered email address.',
  ),
  _FaqItem(
    'Is my personal data safe?',
    'Yes. All data is encrypted at rest with AES-256 and in transit with TLS 1.3. VeriRent NG is fully NDPR-compliant and undergoes regular third-party security audits.',
  ),
  _FaqItem(
    'How do price drop alerts work?',
    'When a listing matching your saved filters drops in price, you receive an instant push notification. Enable this in Settings → Notifications → Price Drop Alerts.',
  ),
];

// =============================================================================
//  8.  CONTACT SUPPORT PAGE
// =============================================================================

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category = 'General';
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SubPageAppBar(title: 'Contact Support')),
            if (_sent)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: VeriRentColors.success500.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: VeriRentColors.success500,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Message Sent!',
                        style: VeriRentText.headlineMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our team will respond within 24 hours.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Back to Settings'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Contact channels
              SliverToBoxAdapter(child: _SectionLabel('Reach Us')),
              SliverToBoxAdapter(
                child: _Group(
                  children: [
                    _ContactChannelTile(
                      icon: Icons.email_outlined,
                      iconColor: cs.primary,
                      title: 'Email',
                      subtitle: 'support@verirent.ng',
                      onTap: () {},
                    ),
                    _ContactChannelTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: VeriRentColors.tierVerified,
                      title: 'Live Chat',
                      subtitle: 'Mon – Fri, 8 AM – 6 PM WAT',
                      onTap: () {},
                    ),
                    _ContactChannelTile(
                      icon: Icons.phone_outlined,
                      iconColor: VeriRentColors.success500,
                      title: 'Phone',
                      subtitle: '+234 (0) 800 VERIRENT',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Form
              SliverToBoxAdapter(child: _SectionLabel('Send a Message')),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Category chips
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                [
                                      'General',
                                      'Verification',
                                      'Listing',
                                      'Billing',
                                      'Technical',
                                    ]
                                    .map(
                                      (c) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(c),
                                          selected: _category == c,
                                          onSelected: (_) =>
                                              setState(() => _category = c),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _subjectCtrl,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                            prefixIcon: Icon(Icons.title_rounded, size: 18),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter a subject'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageCtrl,
                          maxLines: 5,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            alignLabelWithHint: true,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.message_outlined, size: 18),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 10)
                              ? 'Message too short'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Attach
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file_rounded, size: 16),
                          label: const Text('Attach Screenshot'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FilledButton(
                          onPressed: _loading ? null : _send,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Send Message'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactChannelTile extends StatelessWidget {
  const _ContactChannelTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon, iconColor),
      title: Text(
        title,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: cs.onSurfaceVariant,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// =============================================================================
//  9.  RATE VERIRENT NG PAGE
// =============================================================================

class RateAppPage extends StatefulWidget {
  const RateAppPage({super.key});

  @override
  State<RateAppPage> createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {
  int _rating = 0;
  final _reviewCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap a star to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(title: 'Rate VeriRent NG'),
            ),
            if (_submitted)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 16),
                      Text(
                        'Thank you for your feedback!',
                        style: VeriRentText.headlineMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your review helps us improve VeriRent NG.',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // App icon area
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.lg,
                          ),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.lg,
                                ),
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'VeriRent NG',
                              style: VeriRentText.titleLarge.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                            Text(
                              'How would you rate your experience?',
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final filled = i < _rating;
                                return GestureDetector(
                                  onTap: () => setState(() => _rating = i + 1),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 40,
                                      color: filled
                                          ? VeriRentColors.gold
                                          : cs.outlineVariant,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: Text(
                                _ratingLabel,
                                key: ValueKey(_rating),
                                style: VeriRentText.titleSmall.copyWith(
                                  color: _rating > 0
                                      ? VeriRentColors.gold
                                      : cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Review text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.lg,
                          ),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: TextField(
                          controller: _reviewCtrl,
                          maxLines: 4,
                          style: VeriRentText.bodyMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Share more about your experience (optional)…',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      FilledButton(
                        onPressed: _rating == 0
                            ? null
                            : () {
                                if (_rating >= 4) {
                                  // Direct to store for 4/5 stars
                                  setState(() => _submitted = true);
                                } else {
                                  setState(() => _submitted = true);
                                }
                              },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Submit Review'),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('Maybe Later'),
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

// =============================================================================
//  10.  SHARE WITH FRIENDS PAGE
// =============================================================================

class ShareWithFriendsPage extends StatelessWidget {
  const ShareWithFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _SubPageAppBar(title: 'Share with Friends'),
            ),

            // Hero card
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Invite & Earn',
                      style: VeriRentText.headlineMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Share VeriRent NG with colleagues and earn ₦500 for every verified referral.',
                      textAlign: TextAlign.center,
                      style: VeriRentText.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Referral code box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(VeriRentRadius.md),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Referral Code',
                                  style: VeriRentText.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  'VERIRENT-CPD2026',
                                  style: VeriRentText.titleMedium.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(text: 'VERIRENT-CPD2026'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Code copied!')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.sm,
                                ),
                              ),
                              child: Text(
                                'Copy',
                                style: VeriRentText.labelMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Share via
            SliverToBoxAdapter(child: _SectionLabel('Share Via')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ShareOption(
                      icon: Icons.link_rounded,
                      label: 'Copy Link',
                      color: cs.primary,
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(
                            text: 'https://verirent.ng/ref/CPD2026',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied!')),
                        );
                      },
                    ),
                    _ShareOption(
                      icon: Icons.message_rounded,
                      label: 'SMS',
                      color: VeriRentColors.success500,
                      onTap: () {},
                    ),
                    _ShareOption(
                      icon: Icons.share_rounded,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () {},
                    ),
                    _ShareOption(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      color: VeriRentColors.tierVerified,
                      onTap: () {},
                    ),
                    _ShareOption(
                      icon: Icons.more_horiz_rounded,
                      label: 'More',
                      color: cs.onSurfaceVariant,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(child: _SectionLabel('Your Referrals')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _ReferralStat(label: 'Invited', value: '3'),
                    const SizedBox(width: 10),
                    _ReferralStat(label: 'Verified', value: '1'),
                    const SizedBox(width: 10),
                    _ReferralStat(
                      label: 'Earned',
                      value: '₦500',
                      highlight: true,
                    ),
                  ],
                ),
              ),
            ),

            // How it works
            SliverToBoxAdapter(child: _SectionLabel('How It Works')),
            SliverToBoxAdapter(
              child: _Group(
                children: [
                  _HowItWorksTile(
                    step: '1',
                    title: 'Share your referral code',
                    subtitle: 'Send your unique code or link to colleagues.',
                  ),
                  _HowItWorksTile(
                    step: '2',
                    title: 'They sign up and verify',
                    subtitle: 'Your contact registers and completes KYC.',
                  ),
                  _HowItWorksTile(
                    step: '3',
                    title: 'You earn ₦500',
                    subtitle: 'Credit is added to your wallet within 48 hours.',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ReferralStat extends StatelessWidget {
  const _ReferralStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label, value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = highlight ? VeriRentColors.gold : cs.onSurface;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: highlight
                ? VeriRentColors.gold.withOpacity(0.4)
                : cs.outlineVariant,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: VeriRentText.headlineMedium.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksTile extends StatelessWidget {
  const _HowItWorksTile({
    required this.step,
    required this.title,
    required this.subtitle,
  });
  final String step, title, subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
        child: Center(
          child: Text(
            step,
            style: VeriRentText.labelMedium.copyWith(color: cs.onPrimary),
          ),
        ),
      ),
      title: Text(
        title,
        style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
