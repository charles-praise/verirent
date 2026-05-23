// =============================================================================
//  VeriRent NG — Home Screen
//  Nixel Technology Global | May 2026
//
//  Stack-nav pattern applied:
//    Scaffold(resizeToAvoidBottomInset: false) ← keyboard won't push nav
//    body: Stack → Positioned.fill(bottom: navHeight) for content
//                → Positioned(bottom:0) for nav bar
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';
import '../widgets/verirent_bottom_nav.dart';

// ---------------------------------------------------------------------------
//  Data models (replace with real models / Riverpod state)
// ---------------------------------------------------------------------------

class _ListingCard {
  const _ListingCard({
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.agencyName,
    required this.tierLabel,
    required this.tierColor,
    required this.isVerified,
    required this.emoji, // placeholder for image
  });

  final String title;
  final String location;
  final String price;
  final int bedrooms;
  final int bathrooms;
  final String agencyName;
  final String tierLabel;
  final Color tierColor;
  final bool isVerified;
  final String emoji;
}

const List<_ListingCard> _kFeatured = [
  _ListingCard(
    title: 'Executive 3-Bedroom Flat',
    location: 'GRA Phase 2, Port Harcourt',
    price: '₦2,800,000/yr',
    bedrooms: 3,
    bathrooms: 2,
    agencyName: 'Okonkwo & Sons Estate',
    tierLabel: 'Professional Agency',
    tierColor: VeriRentColors.tierProfessional,
    isVerified: true,
    emoji: '🏢',
  ),
  _ListingCard(
    title: 'Modern 2-Bed Self-Contain',
    location: 'Trans Amadi, Port Harcourt',
    price: '₦1,200,000/yr',
    bedrooms: 2,
    bathrooms: 1,
    agencyName: 'Bright Horizons Realty',
    tierLabel: 'Starter Agency',
    tierColor: VeriRentColors.tierStarterAgency,
    isVerified: true,
    emoji: '🏠',
  ),
  _ListingCard(
    title: 'Serviced Studio Apartment',
    location: 'D-Line, Port Harcourt',
    price: '₦900,000/yr',
    bedrooms: 1,
    bathrooms: 1,
    agencyName: 'NovaProp Agency',
    tierLabel: 'Enterprise Agency',
    tierColor: VeriRentColors.tierEnterprise,
    isVerified: true,
    emoji: '🏙️',
  ),
];

const List<_ListingCard> _kRecent = [
  _ListingCard(
    title: '4-Bedroom Detached Duplex',
    location: 'Old GRA, Port Harcourt',
    price: '₦5,500,000/yr',
    bedrooms: 4,
    bathrooms: 3,
    agencyName: 'PH Prime Properties',
    tierLabel: 'Professional Agency',
    tierColor: VeriRentColors.tierProfessional,
    isVerified: true,
    emoji: '🏡',
  ),
  _ListingCard(
    title: 'Mini-flat with BQ',
    location: 'Rumuola, Port Harcourt',
    price: '₦750,000/yr',
    bedrooms: 2,
    bathrooms: 2,
    agencyName: 'Rivers Verified Agent',
    tierLabel: 'Pro Individual',
    tierColor: VeriRentColors.tierPro,
    isVerified: false,
    emoji: '🏘️',
  ),
];

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

const List<_QuickAction> _kActions = [
  _QuickAction(
    label: 'Find Agency',
    icon: Icons.business_outlined,
    color: VeriRentColors.primary500,
  ),
  _QuickAction(
    label: 'Verify Listing',
    icon: Icons.fact_check_outlined,
    color: VeriRentColors.secondary500,
  ),
  _QuickAction(
    label: 'My Documents',
    icon: Icons.folder_outlined,
    color: VeriRentColors.success500,
  ),
  _QuickAction(
    label: 'File Dispute',
    icon: Icons.gavel_outlined,
    color: VeriRentColors.warning700,
  ),
];

// ---------------------------------------------------------------------------
//  HomeScreen
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Total height of bottom nav (bar + safe area)
    final navHeight = VeriRentBottomNav.totalHeight(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        // ── STEP 1: Keyboard will NOT resize the scaffold body ─────────────
        resizeToAvoidBottomInset: false,
        backgroundColor: cs.surfaceVariant,
        body: Stack(
          children: [
            // ── STEP 2: Scrollable content offset by nav height ────────────
            Positioned.fill(
              bottom: navHeight, // leaves room so content isn't hidden
              child: _HomeBody(
                navHeight: navHeight,
                searchController: _searchController,
                searchFocus: _searchFocus,
              ),
            ),

            // ── STEP 3: Nav pinned at bottom — keyboard slides up over it ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VeriRentBottomNav(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Home body (all scrollable content)
// ---------------------------------------------------------------------------

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.navHeight,
    required this.searchController,
    required this.searchFocus,
  });

  final double navHeight;
  final TextEditingController searchController;
  final FocusNode searchFocus;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      slivers: [
        // ── App bar ───────────────────────────────────────────────────────
        SliverToBoxAdapter(child: _HomeAppBar(topPadding: topPad)),

        // ── Search bar ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              VeriRentSpacing.base,
              VeriRentSpacing.sm,
              VeriRentSpacing.base,
              VeriRentSpacing.base,
            ),
            child: _SearchBar(
              controller: searchController,
              focusNode: searchFocus,
            ),
          ),
        ),

        // ── Trust stats strip ─────────────────────────────────────────────
        const SliverToBoxAdapter(child: _TrustStatsStrip()),

        // ── Quick actions ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _SectionHeader(title: 'Quick Actions', onSeeAll: null),
        ),
        const SliverToBoxAdapter(child: _QuickActionsGrid()),

        // ── Featured listings ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _SectionHeader(title: 'Featured Listings', onSeeAll: () {}),
        ),
        const SliverToBoxAdapter(child: _FeaturedListingsRow()),

        // ── Recently Added ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _SectionHeader(title: 'Recently Added', onSeeAll: () {}),
        ),

        // Recent listings as vertical cards
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => Padding(
              padding: const EdgeInsets.fromLTRB(
                VeriRentSpacing.base,
                0,
                VeriRentSpacing.base,
                VeriRentSpacing.sm,
              ),
              child: _RecentListingCard(card: _kRecent[i]),
            ),
            childCount: _kRecent.length,
          ),
        ),

        // Bottom clearance (in case content is taller than expected)
        const SliverToBoxAdapter(child: SizedBox(height: VeriRentSpacing.lg)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  App bar
// ---------------------------------------------------------------------------

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        topPadding + VeriRentSpacing.md,
        VeriRentSpacing.base,
        VeriRentSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VeriRentColors.primary600, VeriRentColors.primary500],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Location pill
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: VeriRentColors.secondary300,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Port Harcourt, Rivers State',
                      style: VeriRentText.labelMedium.copyWith(
                        color: VeriRentColors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: VeriRentColors.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ),

              // Notification icon
              _AppBarIconButton(
                icon: Icons.notifications_none_rounded,
                badgeCount: 3,
                onTap: () {},
              ),

              const SizedBox(width: VeriRentSpacing.sm),

              // Avatar
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: VeriRentColors.secondary500,
                  child: Text(
                    'CP',
                    style: VeriRentText.labelSmall.copyWith(
                      color: VeriRentColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: VeriRentSpacing.md),

          Text(
            'Good morning, Charles 👋',
            style: VeriRentText.bodySmall.copyWith(
              color: VeriRentColors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Find Verified Rentals',
            style: VeriRentText.displaySmall.copyWith(
              color: VeriRentColors.white,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: VeriRentColors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            ),
            child: Icon(icon, size: 20, color: VeriRentColors.white),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: VeriRentColors.secondary500,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: VeriRentText.labelSmall.copyWith(
                      color: VeriRentColors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Search bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
            decoration: InputDecoration(
              hintText: 'Search by location, type…',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) => value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: controller.clear,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: cs.onSurfaceVariant,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              filled: true,
              fillColor: cs.surface,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: VeriRentSpacing.base,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide(color: cs.outlineVariant, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: VeriRentSpacing.sm),

        // Filter button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
          ),
          child: Icon(Icons.tune_rounded, color: cs.primary, size: 20),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Trust stats strip
// ---------------------------------------------------------------------------

class _TrustStatsStrip extends StatelessWidget {
  const _TrustStatsStrip();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        0,
        VeriRentSpacing.base,
        VeriRentSpacing.base,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: VeriRentSpacing.base,
        vertical: VeriRentSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          _StatItem(label: 'Agencies', value: '800+'),
          _StatDivider(),
          _StatItem(label: 'Verified Listings', value: '2,400'),
          _StatDivider(),
          _StatItem(label: 'Tenants Protected', value: '12K+'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: VeriRentText.headlineSmall.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 36,
      color: cs.outlineVariant,
      margin: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.xs),
    );
  }
}

// ---------------------------------------------------------------------------
//  Quick actions grid
// ---------------------------------------------------------------------------

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        0,
        VeriRentSpacing.base,
        VeriRentSpacing.sm,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: VeriRentSpacing.sm,
        mainAxisSpacing: VeriRentSpacing.sm,
        childAspectRatio: 0.85,
        children: _kActions.map((a) => _QuickActionTile(action: a)).toList(),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(
                color: action.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(action.icon, size: 22, color: action.color),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            style: VeriRentText.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        VeriRentSpacing.base,
        VeriRentSpacing.sm,
        VeriRentSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                ),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                'See all',
                style: VeriRentText.labelMedium.copyWith(color: cs.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Featured listings horizontal row
// ---------------------------------------------------------------------------

class _FeaturedListingsRow extends StatelessWidget {
  const _FeaturedListingsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
        itemCount: _kFeatured.length,
        separatorBuilder: (_, __) => const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (context, i) => _FeaturedCard(card: _kFeatured[i]),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.card});

  final _ListingCard card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area (emoji placeholder)
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primaryContainer, cs.secondaryContainer],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(VeriRentRadius.lg),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      card.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  if (card.isVerified)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: VeriRentColors.success500,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 10,
                              color: VeriRentColors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: VeriRentText.labelSmall.copyWith(
                                color: VeriRentColors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(VeriRentSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _RoomChip(
                          icon: Icons.bed_rounded,
                          label: '${card.bedrooms}bd',
                        ),
                        const SizedBox(width: 4),
                        _RoomChip(
                          icon: Icons.bathtub_outlined,
                          label: '${card.bathrooms}bth',
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card.price,
                          style: VeriRentText.titleSmall.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _TierBadge(
                          label: card.tierLabel
                              .replaceAll(' Agency', '')
                              .replaceAll(' Individual', ''),
                          color: card.tierColor,
                        ),
                      ],
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

// ---------------------------------------------------------------------------
//  Recent listing card (vertical)
// ---------------------------------------------------------------------------

class _RecentListingCard extends StatelessWidget {
  const _RecentListingCard({required this.card});

  final _ListingCard card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primaryContainer, cs.secondaryContainer],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(VeriRentRadius.lg),
                ),
              ),
              child: Center(
                child: Text(card.emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _TierBadge(
                          label: card.tierLabel
                              .replaceAll(' Agency', '')
                              .replaceAll(' Individual', ''),
                          color: card.tierColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          card.price,
                          style: VeriRentText.labelMedium.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _RoomChip(
                              icon: Icons.bed_rounded,
                              label: '${card.bedrooms}bd',
                            ),
                            const SizedBox(width: 4),
                            _RoomChip(
                              icon: Icons.bathtub_outlined,
                              label: '${card.bathrooms}bth',
                            ),
                          ],
                        ),
                      ],
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

// ---------------------------------------------------------------------------
//  Shared small widgets
// ---------------------------------------------------------------------------

class _RoomChip extends StatelessWidget {
  const _RoomChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(VeriRentRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: cs.onSurfaceVariant),
          const SizedBox(width: 2),
          Text(
            label,
            style: VeriRentText.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 9),
      ),
    );
  }
}
