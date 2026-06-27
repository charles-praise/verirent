// =============================================================================
//  1.  VERIFICATION & KYC PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

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
        backgroundColor: cs.surfaceContainerHighest,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SubPageAppBar(title: 'Verification & KYC'),
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
            SliverToBoxAdapter(child: SectionLabel('Identity Documents')),
            SliverToBoxAdapter(
              child: Group(
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
            SliverToBoxAdapter(child: SectionLabel('Professional Credentials')),
            SliverToBoxAdapter(
              child: Group(
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
            SliverToBoxAdapter(child: SectionLabel('Address Verification')),
            SliverToBoxAdapter(
              child: Group(
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
      leading: profileIconBox(icon, iconColor),
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
