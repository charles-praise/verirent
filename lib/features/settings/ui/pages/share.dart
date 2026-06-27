// =============================================================================
//  10.  SHARE WITH FRIENDS PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

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
              child: SubPageAppBar(title: 'Share with Friends'),
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
            SliverToBoxAdapter(child: SectionLabel('Share Via')),
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
            SliverToBoxAdapter(child: SectionLabel('Your Referrals')),
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
            SliverToBoxAdapter(child: SectionLabel('How It Works')),
            SliverToBoxAdapter(
              child: Group(
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
