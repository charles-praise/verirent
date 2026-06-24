// =============================================================================
//  VeriRent NG — Agency / Practitioner View Profile Page
//  File: features/profile/ui/pages/view_profile.dart
//
//  Sections:
//   ① Sliver hero header   — avatar, name, tier badge, quick stats
//   ② Verification panel   — ESVARBON / NIESV credential strip
//   ③ About                — bio / description
//   ④ Contact              — phone, email, address tap-to-action tiles
//   ⑤ Active Listings      — horizontally scrolling property cards (placeholder)
//   ⑥ Reviews              — star breakdown + recent review cards
//   ⑦ Sticky bottom CTA    — "Send Enquiry" primary, "Call" secondary
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/models/property_model.dart';
import '../../../../core/theme/agents_theme.dart';

// =============================================================================
//  PAGE
// =============================================================================

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key, required this.agency});
  final AgencyModel agency;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  AgencyModel get _a => widget.agency;

  // ── Derived helpers ────────────────────────────────────────────────────────
  Color get _tierColor {
    switch (_a.verificationTier) {
      case VerificationTier.enterprise:
        return VeriRentColors.tierEnterprise;
      case VerificationTier.professional:
        return VeriRentColors.tierProfessional;
      case VerificationTier.starter:
        return VeriRentColors.tierStarterAgency;
      default:
        return VeriRentColors.tierBasic;
    }
  }

  String get _tierLabel {
    switch (_a.verificationTier) {
      case VerificationTier.enterprise:
        return 'Enterprise Agency';
      case VerificationTier.professional:
        return 'Professional Agency';
      case VerificationTier.starter:
        return 'Starter Agency';
      default:
        return 'Basic';
    }
  }

  IconData get _tierIcon {
    switch (_a.verificationTier) {
      case VerificationTier.enterprise:
        return Icons.domain_rounded;
      case VerificationTier.professional:
        return Icons.workspace_premium_rounded;
      default:
        return Icons.verified_rounded;
    }
  }

  String get _initials {
    final words = (_a.name ?? 'VR').trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words[0].substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // hero is always dark
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        // ── Sticky bottom CTA ───────────────────────────────────────────────
        bottomNavigationBar: _BottomCta(agency: _a, bottomPad: bPad),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _HeroSliver(
              agency: _a,
              initials: _initials,
              tierColor: _tierColor,
              tierLabel: _tierLabel,
              tierIcon: _tierIcon,
              innerBoxIsScrolled: innerBoxIsScrolled,
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // ① Verification strip
              _VerificationStrip(agency: _a, tierColor: _tierColor),
              const SizedBox(height: 14),

              // ② Quick stats row
              _StatsRow(agency: _a, tierColor: _tierColor),
              const SizedBox(height: 14),

              // ③ About
              _AboutCard(agency: _a),
              const SizedBox(height: 14),

              // ④ Contact
              _ContactCard(agency: _a),
              const SizedBox(height: 14),

              // ⑤ Active listings (placeholder strip)
              _ActiveListingsStrip(tierColor: _tierColor),
              const SizedBox(height: 14),

              // ⑥ Reviews
              _ReviewsSection(agency: _a, tierColor: _tierColor),

              // Bottom CTA breathing room
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  ① HERO SLIVER
// =============================================================================

class _HeroSliver extends StatelessWidget {
  const _HeroSliver({
    required this.agency,
    required this.initials,
    required this.tierColor,
    required this.tierLabel,
    required this.tierIcon,
    required this.innerBoxIsScrolled,
  });

  final AgencyModel agency;
  final String initials, tierLabel;
  final Color tierColor;
  final IconData tierIcon;
  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: 256,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: cs.primary,
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.share_outlined,
              size: 16,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background — primary palette
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary,
                    cs.primary.withOpacity(0.88),
                    VeriRentColors.primary700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Subtle pattern overlay
            Positioned.fill(child: CustomPaint(painter: _DotPatternPainter())),

            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar + verification badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: tierColor.withOpacity(0.18),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: VeriRentText.displaySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: tierColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.primary, width: 2),
                          ),
                          child: Icon(tierIcon, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    agency.name ?? '—',
                    style: VeriRentText.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Tier chip + rating
                  Row(
                    children: [
                      _HeroChip(
                        icon: tierIcon,
                        label: tierLabel,
                        color: tierColor,
                      ),
                      const SizedBox(width: 8),
                      _HeroChip(
                        icon: Icons.star_rounded,
                        label:
                            '${agency.rating?.toStringAsFixed(1) ?? '—'} · ${agency.transactions ?? 0} deals',
                        color: VeriRentColors.gold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.18),
      borderRadius: BorderRadius.circular(VeriRentRadius.full),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 10),
        ),
      ],
    ),
  );
}

/// Subtle dot grid to add texture to the hero without being loud.
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// =============================================================================
//  ② VERIFICATION STRIP
// =============================================================================

class _VerificationStrip extends StatelessWidget {
  const _VerificationStrip({required this.agency, required this.tierColor});
  final AgencyModel agency;
  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: VeriRentColors.success500.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: VeriRentColors.success500.withOpacity(0.10),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              size: 18,
              color: VeriRentColors.success500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESVARBON Licensed Practitioner',
                  style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
                ),
                Text(
                  agency.esvarbon ?? 'Licence number not provided',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: VeriRentColors.success500.withOpacity(0.10),
              borderRadius: BorderRadius.circular(VeriRentRadius.full),
              border: Border.all(
                color: VeriRentColors.success500.withOpacity(0.4),
              ),
            ),
            child: Text(
              'Verified',
              style: VeriRentText.labelSmall.copyWith(
                color: VeriRentColors.success500,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  ③ QUICK STATS ROW
// =============================================================================

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.agency, required this.tierColor});
  final AgencyModel agency;
  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        _StatCard(
          value: agency.rating?.toStringAsFixed(1) ?? '—',
          label: 'Rating',
          icon: Icons.star_rounded,
          color: VeriRentColors.gold,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: '${agency.transactions ?? 0}',
          label: 'Transactions',
          icon: Icons.handshake_rounded,
          color: VeriRentColors.success500,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: '7 yrs',
          label: 'Experience',
          icon: Icons.history_rounded,
          color: tierColor,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
  final String value, label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
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

// =============================================================================
//  ④ ABOUT CARD
// =============================================================================

class _AboutCard extends StatefulWidget {
  const _AboutCard({required this.agency});
  final AgencyModel agency;

  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _expanded = false;

  static const _placeholder =
      'Greenfield Estates Ltd is a full-service real estate agency '
      'headquartered in GRA Phase 2, Port Harcourt. With over seven years '
      'of active practice and a team of ESVARBON-licensed estate surveyors, '
      'we specialise in residential lettings, property sales, and commercial '
      'space leasing across Rivers State. Our multi-tier verification approach '
      'ensures that every transaction is transparent, legally compliant, and '
      'stress-free for both landlords and tenants.';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bio = _placeholder; // swap with agency.bio when added to model

    return Container(
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
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: VeriRentColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: VeriRentText.titleSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Text(
              bio,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.65,
              ),
            ),
            secondChild: Text(
              bio,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.65,
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: VeriRentText.labelMedium.copyWith(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  ⑤ CONTACT CARD
// =============================================================================

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.agency});
  final AgencyModel agency;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.contacts_outlined,
                  size: 16,
                  color: VeriRentColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact Information',
                  style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          _ContactTile(
            icon: Icons.phone_outlined,
            iconColor: VeriRentColors.success500,
            label: 'Phone',
            value: agency.phone ?? '—',
            onTap: () {},
          ),
          Divider(height: 1, color: cs.outlineVariant, indent: 54),
          _ContactTile(
            icon: Icons.email_outlined,
            iconColor: VeriRentColors.primary,
            label: 'Email',
            value: agency.email ?? '—',
            onTap: () {},
          ),
          Divider(height: 1, color: cs.outlineVariant, indent: 54),
          _ContactTile(
            icon: Icons.location_on_outlined,
            iconColor: VeriRentColors.red,
            label: 'Office Address',
            value: agency.address ?? '—',
            onTap: () {},
            trailing: false,
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing = true,
  });
  final IconData icon;
  final Color iconColor;
  final String label, value;
  final VoidCallback onTap;
  final bool trailing;

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
        child: Icon(icon, size: 16, color: iconColor),
      ),
      title: Text(
        label,
        style: VeriRentText.labelMedium.copyWith(color: cs.onSurfaceVariant),
      ),
      subtitle: Text(
        value,
        style: VeriRentText.bodySmall.copyWith(color: cs.onSurface),
      ),
      trailing: trailing
          ? Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: cs.onSurfaceVariant,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// =============================================================================
//  ⑥ ACTIVE LISTINGS STRIP  (placeholder — connect to real BLoC in prod)
// =============================================================================

class _ActiveListingsStrip extends StatelessWidget {
  const _ActiveListingsStrip({required this.tierColor});
  final Color tierColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Listings',
              style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: VeriRentText.labelMedium.copyWith(color: cs.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 122,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) =>
                _ListingThumb(index: i, color: tierColor),
          ),
        ),
      ],
    );
  }
}

class _ListingThumb extends StatelessWidget {
  const _ListingThumb({required this.index, required this.color});
  final int index;
  final Color color;

  static const _titles = [
    '3 Bed Flat, GRA Phase 2',
    'Executive Duplex, Trans-Amadi',
    'Office Space, D-Line',
    'Studio Apt, Rumuola',
    'Land 648m², Rumuigbo',
  ];
  static const _prices = [
    '₦1.8M/yr',
    '₦4.5M/yr',
    '₦2.2M/yr',
    '₦550k/yr',
    '₦18.5M',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 168,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(
                child: Icon(Icons.home_rounded, color: color, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _titles[index % _titles.length],
              style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _prices[index % _prices.length],
              style: VeriRentText.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  ⑦ REVIEWS SECTION
// =============================================================================

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.agency, required this.tierColor});
  final AgencyModel agency;
  final Color tierColor;

  static const _reviews = [
    _ReviewData(
      name: 'Chisom A.',
      initials: 'CA',
      rating: 5,
      date: '2 weeks ago',
      text:
          'Greenfield handled my duplex search professionally. Found a verified 4-bed in Trans-Amadi within 3 days.',
    ),
    _ReviewData(
      name: 'Emeka O.',
      initials: 'EO',
      rating: 5,
      date: '1 month ago',
      text:
          'Very transparent about document status. No hidden charges. Would recommend to colleagues.',
    ),
    _ReviewData(
      name: 'Blessing T.',
      initials: 'BT',
      rating: 4,
      date: '2 months ago',
      text:
          'Responsive and knowledgeable. Slight delay with the NIN check but resolved quickly.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rating = agency.rating ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Text(
              'Reviews',
              style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Write a review',
                style: VeriRentText.labelMedium.copyWith(color: cs.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Rating overview card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              // Big number
              Column(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: VeriRentText.displayMedium.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _StarRow(rating: rating, size: 14),
                  const SizedBox(height: 2),
                  Text(
                    '${agency.transactions ?? 0} reviews',
                    style: VeriRentText.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Breakdown bars
              Expanded(
                child: Column(
                  children: [
                    _RatingBar(
                      stars: 5,
                      fill: 0.80,
                      color: VeriRentColors.gold,
                    ),
                    const SizedBox(height: 5),
                    _RatingBar(
                      stars: 4,
                      fill: 0.14,
                      color: VeriRentColors.gold,
                    ),
                    const SizedBox(height: 5),
                    _RatingBar(
                      stars: 3,
                      fill: 0.04,
                      color: VeriRentColors.warning500,
                    ),
                    const SizedBox(height: 5),
                    _RatingBar(stars: 2, fill: 0.01, color: VeriRentColors.red),
                    const SizedBox(height: 5),
                    _RatingBar(stars: 1, fill: 0.01, color: VeriRentColors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Individual review cards
        ..._reviews.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ReviewCard(review: r),
          ),
        ),
      ],
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.stars,
    required this.fill,
    required this.color,
  });
  final int stars;
  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 14,
          child: Text(
            '$stars',
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ),
        const Icon(Icons.star_rounded, size: 10, color: VeriRentColors.gold),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(VeriRentRadius.full),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 6,
              backgroundColor: cs.outlineVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            '${(fill * 100).round()}%',
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewData {
  const _ReviewData({
    required this.name,
    required this.initials,
    required this.rating,
    required this.date,
    required this.text,
  });
  final String name, initials, date, text;
  final int rating;
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final _ReviewData review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
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
              // Avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: VeriRentColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: VeriRentText.labelSmall.copyWith(
                      color: VeriRentColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      review.date,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating.toDouble(), size: 12),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurface,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.size});
  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      final filled = i < rating.floor();
      return Icon(
        filled ? Icons.star_rounded : Icons.star_border_rounded,
        size: size,
        color: VeriRentColors.gold,
      );
    }),
  );
}

// =============================================================================
//  ⑧ STICKY BOTTOM CTA
// =============================================================================

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.agency, required this.bottomPad});
  final AgencyModel agency;
  final double bottomPad;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 10),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Call button (secondary)
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone_rounded, size: 16),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(100, 48),
              side: BorderSide(color: cs.primary),
            ),
          ),
          const SizedBox(width: 12),
          // Enquire button (primary — fills remaining)
          Expanded(
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_rounded, size: 16),
              label: const Text('Send Enquiry'),
              style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            ),
          ),
        ],
      ),
    );
  }
}
