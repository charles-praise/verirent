// =============================================================================
//  VeriRent NG — Category Detail Pages
//  Each property category gets a layout tuned to its key buying signals.
//
//  Factory usage:
//    ListingDetailsFactory.build(context, listing)
//
//  | Category    | Page                   | Layout emphasis               |
//  | ----------- | ---------------------- | ----------------------------- |
//  | Residential | ResidentialDetailsPage | Rooms, furnishing, lifestyle  |
//  | Land        | LandDetailsPage        | Docs, dimensions, zoning      |
//  | Commercial  | CommercialDetailsPage  | Sqm, floor, facilities        |
//  | Estate      | EstateDetailsPage      | Units, security, communal     |
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../domain/entities/property_model.dart';

// =============================================================================
//  DISPATCHER
// =============================================================================

abstract final class ListingDetailsFactory {
  static Widget build(BuildContext context, PropertyModel listing) {
    switch (listing.category) {
      case PropertyCategory.land:
        return LandDetailsPage(listing: listing);
      case PropertyCategory.commercial:
        return CommercialDetailsPage(listing: listing);
      case PropertyCategory.estate:
        return EstateDetailsPage(listing: listing);
      case PropertyCategory.residential:
      default:
        return ResidentialDetailsPage(listing: listing);
    }
  }
}

// =============================================================================
//  SHARED SECTION WIDGETS
//  All detail pages compose from these building blocks.
// =============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
    child: Text(
      text,
      style: VeriRentText.titleMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.accentColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accentColor ?? cs.primary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(icon, size: 15, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  style: VeriRentText.labelMedium.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: cs.outlineVariant,
            indent: 58,
            endIndent: 14,
          ),
      ],
    );
  }
}

class _BoolRow extends StatelessWidget {
  const _BoolRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.trueColor,
  });
  final IconData icon;
  final String label;
  final bool value;
  final bool isLast;
  final Color? trueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final okColor = trueColor ?? VeriRentColors.success500;
    return _InfoRow(
              icon: icon,
              label: label,
              value: '',
              isLast: isLast,
              accentColor: value ? okColor : cs.onSurfaceVariant,
            ).build ==
            null // force override trailing
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (value ? okColor : cs.onSurfaceVariant)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      ),
                      child: Icon(
                        icon,
                        size: 15,
                        color: value ? okColor : cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      value ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 18,
                      color: value ? okColor : cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: cs.outlineVariant,
                  indent: 58,
                  endIndent: 14,
                ),
            ],
          );
  }
}

/// Horizontal stats bar (3-4 hero metrics side by side).
class _HeroStatsBar extends StatelessWidget {
  const _HeroStatsBar({required this.stats, this.accentColor});
  final List<_StatItem> stats;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accentColor ?? cs.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: List.generate(stats.length, (i) {
          final isLast = i == stats.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      children: [
                        Icon(stats[i].icon, size: 20, color: color),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stats[i].value,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stats[i].label,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Container(width: 1, height: 48, color: cs.outlineVariant),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
}

/// Shared image gallery + CTA scaffold that wraps all detail pages.
class _DetailScaffold extends StatefulWidget {
  const _DetailScaffold({
    required this.listing,
    required this.accentColor,
    required this.categoryLabel,
    required this.categoryIcon,
    required this.body,
  });
  final PropertyModel listing;
  final Color accentColor;
  final String categoryLabel;
  final IconData categoryIcon;
  final List<Widget> body; // slivers

  @override
  State<_DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<_DetailScaffold> {
  int _imgIndex = 0;
  bool _isSaved = false;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final listing = widget.listing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── App Bar ─────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: cs.surface,
              foregroundColor: cs.onSurface,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: cs.onSurface,
                    size: 18,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.categoryIcon,
                            size: 12,
                            color: widget.accentColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.categoryLabel,
                              maxLines: 1,
                              style: VeriRentText.labelSmall.copyWith(
                                color: widget.accentColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      listing.area ?? "_",
                      style: VeriRentText.labelMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isSaved = !_isSaved);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _isSaved
                          ? VeriRentColors.red.withOpacity(0.15)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      _isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _isSaved ? VeriRentColors.red : cs.onSurface,
                      size: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.share_rounded,
                      color: cs.onSurface,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(color: cs.outlineVariant, height: 1),
              ),
            ),

            // ── Image gallery ────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.black,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageCtrl,
                      onPageChanged: (i) => setState(() => _imgIndex = i),
                      children: listing.imageUrls!
                          .map(
                            (img) => Container(
                              color: Colors.grey[900],
                              child: CustomNetworkImage(imgUrl: img),
                            ),
                          )
                          .toList(),
                    ),
                    // Accent-colored category overlay strip
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(height: 3, color: widget.accentColor),
                    ),
                    // Badges
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          if (listing.isFeatured!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: VeriRentColors.gold.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.full,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Featured',
                                      style: VeriRentText.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const Spacer(),
                          if (listing.isVerified!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: VeriRentColors.success500.withOpacity(
                                  0.9,
                                ),
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.full,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: VeriRentText.labelSmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Counter + dots
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Text(
                          '${_imgIndex + 1} / ${listing.imageUrls!.length}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            listing.imageUrls!.length,
                            (i) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: i == _imgIndex
                                    ? Colors.white
                                    : Colors.white30,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Quick Info Bar ───────────────────────────────────
            SliverToBoxAdapter(
              child: _QuickInfoBar(
                listing: listing,
                accentColor: widget.accentColor,
              ),
            ),

            // ── Title + Location ─────────────────────────────────
            SliverToBoxAdapter(child: _TitleBlock(listing: listing)),

            // ── CTA ──────────────────────────────────────────────
            // SliverToBoxAdapter(child: _CTARow(accentColor: widget.accentColor)),

            // ── Shared: Agency ───────────────────────────────────
            if (listing.agency != null)
              SliverToBoxAdapter(
                child: _AgencyBlock(
                  listing: listing,
                  accent: widget.accentColor,
                ),
              ),
            // ── Pricing ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _PricingBlock(
                listing: listing,
                accent: VeriRentColors.primary,
              ),
            ),

            // ── Category-specific body ────────────────────────────
            ...widget.body,

            // ── Shared: Description ──────────────────────────────
            SliverToBoxAdapter(child: _DescriptionBlock(listing: listing)),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

// ── Shared inner widgets ──────────────────────────────────────────────────────

class _QuickInfoBar extends StatelessWidget {
  const _QuickInfoBar({required this.listing, required this.accentColor});
  final PropertyModel listing;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₦ ${listing.price}',
                  style: VeriRentText.headlineMedium.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  listing.priceUnit!,
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  (listing.isVerified!
                          ? VeriRentColors.success500
                          : VeriRentColors.warning500)
                      .withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(
                color:
                    (listing.isVerified!
                            ? VeriRentColors.success500
                            : VeriRentColors.warning500)
                        .withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  listing.isVerified!
                      ? Icons.verified_rounded
                      : Icons.warning_amber_rounded,
                  size: 14,
                  color: listing.isVerified!
                      ? VeriRentColors.success500
                      : VeriRentColors.warning500,
                ),
                const SizedBox(width: 4),
                Text(
                  listing.isVerified! ? 'Verified' : 'Pending',
                  style: VeriRentText.labelSmall.copyWith(
                    color: listing.isVerified!
                        ? VeriRentColors.success500
                        : VeriRentColors.warning500,
                    fontSize: 10,
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

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.title ?? "",
            overflow: TextOverflow.ellipsis,
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  '${listing.address}, ${listing.area}, ${listing.lga}',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CTARow extends StatelessWidget {
  const _CTARow({required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Schedule Visit'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {},
              child: const Text('Request Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionBlock extends StatelessWidget {
  const _DescriptionBlock({required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Property',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            listing.description!,
            style: VeriRentText.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgencyBlock extends StatelessWidget {
  const _AgencyBlock({required this.listing, required this.accent});
  final PropertyModel listing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final agency = listing.agency!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Listed By',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(VeriRentRadius.md),
                  border: Border.all(color: accent.withOpacity(0.3)),
                ),
                child: Icon(Icons.business_rounded, size: 24, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agency.name ?? "",
                      maxLines: 2,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: VeriRentColors.gold,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${agency.rating}',
                            style: VeriRentText.labelSmall.copyWith(
                              color: cs.onSurface,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Text(
                          ' · ${agency.transactions} sales',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined, size: 16),
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: const Text('Call'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  1. RESIDENTIAL DETAILS PAGE
//  Focus: Rooms, furnishing, utilities, lifestyle amenities
// =============================================================================

class ResidentialDetailsPage extends StatelessWidget {
  const ResidentialDetailsPage({super.key, required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final res = listing.asResidential; // typed subclass accessor
    return _DetailScaffold(
      listing: listing,
      accentColor: VeriRentColors.primary,
      categoryLabel: listing.propertyType!,
      categoryIcon: Icons.home_rounded,
      body: [
        // ── Key Specs ──────────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Key Specs'),
              _HeroStatsBar(
                accentColor: VeriRentColors.primary,
                stats: [
                  _StatItem(
                    icon: Icons.bed_rounded,
                    value: '${listing.bedrooms}',
                    label: 'Bed',
                  ),
                  _StatItem(
                    icon: Icons.bathtub_outlined,
                    value: '${listing.bathrooms}',
                    label: 'Bath',
                  ),
                  if (listing.toilets != null)
                    _StatItem(
                      icon: Icons.wc_rounded,
                      value: '${listing.toilets}',
                      label: 'WC',
                    ),
                  _StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Furnishing & Condition ──────────────────────────
        if (res != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Furnishing & Condition'),
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.chair_rounded,
                      label: 'Furnishing',
                      value: res.furnishing ?? "_",
                    ),
                    _InfoRow(
                      icon: Icons.build_rounded,
                      label: 'Condition',
                      value: res.residentialCondition!.name!.replaceAll(
                        '_',
                        ' ',
                      ),
                    ),
                    _InfoRow(
                      icon: Icons.water_drop_rounded,
                      label: 'Water Supply',
                      value: res.waterSupply ?? "_",
                    ),
                    _InfoRow(
                      icon: Icons.bolt_rounded,
                      label: 'Power Supply',
                      value: res.powerSupply ?? "_",
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Security & Features ─────────────────────────────
        if (res != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Security & Features'),
                _InfoCard(
                  children: [
                    _BoolRowSimple(
                      icon: Icons.ac_unit_rounded,
                      label: 'Air Conditioning',
                      value: res.hasAC ?? false,
                    ),
                    _BoolRowSimple(
                      icon: Icons.local_parking_rounded,
                      label: 'Parking Space',
                      value: res.hasParking ?? false,
                    ),
                    _BoolRowSimple(
                      icon: Icons.park_rounded,
                      label: 'Garden',
                      value: res.hasGarden ?? false,
                    ),
                    _BoolRowSimple(
                      icon: Icons.fence_rounded,
                      label: 'Fenced',
                      value: res.isFenced ?? false,
                    ),
                    _BoolRowSimple(
                      icon: Icons.security_rounded,
                      label: 'Security Guard',
                      value: res.hasSecurityGuard ?? false,
                    ),
                    _BoolRowSimple(
                      icon: Icons.videocam_rounded,
                      label: 'CCTV',
                      value: res.hasCCTV ?? false,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Amenities ───────────────────────────────────────
        if (listing.amenities!.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Amenities'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities!
                        .map((a) => _AmenityPill(label: a))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

        // ── Pricing ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: _PricingBlock(
            listing: listing,
            accent: VeriRentColors.primary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  2. LAND DETAILS PAGE
//  Focus: Legal docs, dimensions, zoning, infrastructure
// =============================================================================

class LandDetailsPage extends StatelessWidget {
  const LandDetailsPage({super.key, required this.listing});
  final PropertyModel listing;

  static const _green = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final land = listing.asLand;
    return _DetailScaffold(
      listing: listing,
      accentColor: _green,
      categoryLabel: 'Land',
      categoryIcon: Icons.landscape_rounded,
      body: [
        // ── Plot Dimensions ─────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Plot Details'),
              _HeroStatsBar(
                accentColor: _green,
                stats: [
                  _StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  if (land != null) ...[
                    _StatItem(
                      icon: Icons.straighten_rounded,
                      value: land.dimensions ?? "_",
                      label: 'Dimensions',
                    ),
                    _StatItem(
                      icon: Icons.grass_rounded,
                      value: land.landUse ?? "_",
                      label: 'Land Use',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // ── Legal Documents ─────────────────────────────────
        if (land != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Legal Documents'),
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.description_rounded,
                      label: 'Document Type',
                      value: land.documentType ?? "_",
                      accentColor: _green,
                    ),
                    _InfoRow(
                      icon: Icons.assignment_rounded,
                      label: 'Survey Plan No.',
                      value: land.surveyPlanNumber!.isNotEmpty
                          ? land.surveyPlanNumber!
                          : 'Pending',
                      accentColor: _green,
                    ),
                    _InfoRow(
                      icon: Icons.folder_rounded,
                      label: 'Registry Reference',
                      value: land.landRegistryReference!.isNotEmpty
                          ? land.landRegistryReference!
                          : 'Pending',
                      accentColor: _green,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Infrastructure ──────────────────────────────────
        if (land != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Infrastructure'),
                _InfoCard(
                  children: [
                    _BoolRowSimple(
                      icon: Icons.bolt_rounded,
                      label: 'Electricity Poles',
                      value: land.hasElectricityPoles ?? false,
                      trueColor: _green,
                    ),
                    _BoolRowSimple(
                      icon: Icons.water_rounded,
                      label: 'Water Line',
                      value: land.hasWaterLine ?? false,
                      trueColor: _green,
                    ),
                    _BoolRowSimple(
                      icon: Icons.drag_handle_sharp,
                      label: 'Drainage',
                      value: land.hasDrainage ?? false,
                      trueColor: _green,
                    ),
                    _BoolRowSimple(
                      icon: Icons.add_road_rounded,
                      label: 'Tarred Road Access',
                      value: land.hasTarredRoad ?? false,
                      trueColor: _green,
                    ),
                    _BoolRowSimple(
                      icon: Icons.directions_car_rounded,
                      label: 'Road Access',
                      value: land.isAccessibleByRoad ?? false,
                      trueColor: _green,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Zoning ─────────────────────────────────────────
        if (land != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Zoning & Restrictions'),
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.map_rounded,
                      label: 'Zoning Class',
                      value: land.zoningClassification ?? "_",
                      accentColor: _green,
                    ),
                    _InfoRow(
                      icon: Icons.height_rounded,
                      label: 'Max Building Height',
                      value: land.maxBuildingHeight != null
                          ? '${land.maxBuildingHeight} floors'
                          : 'No limit',
                      accentColor: _green,
                    ),
                    _BoolRowSimple(
                      icon: Icons.store_rounded,
                      label: 'Commercial Use Allowed',
                      value: land.allowsCommercial ?? false,
                      trueColor: _green,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Pricing ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: _PricingBlock(listing: listing, accent: _green),
        ),
      ],
    );
  }
}

// =============================================================================
//  3. COMMERCIAL DETAILS PAGE
//  Focus: Sqm, floors, office facilities, lease terms
// =============================================================================

class CommercialDetailsPage extends StatelessWidget {
  const CommercialDetailsPage({super.key, required this.listing});
  final PropertyModel listing;

  static const _blue = VeriRentColors.info500;

  @override
  Widget build(BuildContext context) {
    final office = listing.asOffice;
    return _DetailScaffold(
      listing: listing,
      accentColor: _blue,
      categoryLabel: listing.propertyType!,
      categoryIcon: Icons.business_center_rounded,
      body: [
        // ── Key Specs ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Space Details'),
              _HeroStatsBar(
                accentColor: _blue,
                stats: [
                  _StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  if (office != null) ...[
                    _StatItem(
                      icon: Icons.layers_rounded,
                      value: office.floorLevel != null
                          ? '${office.floorLevel}F'
                          : 'GF',
                      label: 'Floor',
                    ),
                    _StatItem(
                      icon: Icons.local_parking_rounded,
                      value: '${office.parkingSpaces}',
                      label: 'Parking',
                    ),
                    _StatItem(
                      icon: Icons.people_alt_rounded,
                      value: office.layoutType ?? "_",
                      label: 'Layout',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // ── Office Facilities ───────────────────────────────
        if (office != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Facilities'),
                _InfoCard(
                  children: [
                    _BoolRowSimple(
                      icon: Icons.ac_unit_rounded,
                      label: 'HVAC System',
                      value: office.hasHVAC ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.elevator_rounded,
                      label: 'Elevator',
                      value: office.hasElevator ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.accessible_rounded,
                      label: 'Disabled Access',
                      value: office.hasDisabledAccess ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.kitchen_rounded,
                      label: 'Kitchen',
                      value: office.hasKitchen ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.meeting_room_rounded,
                      label: 'Conference Room',
                      value: office.hasConferenceRoom ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.wifi_rounded,
                      label: 'Internet',
                      value: office.hasInternet ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.bolt_rounded,
                      label: '24hr Power',
                      value: office.has24HourPower ?? false,
                      trueColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.videocam_rounded,
                      label: 'CCTV',
                      value: office.hasCCTV ?? false,
                      trueColor: _blue,
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── Lease Terms ─────────────────────────────────────
        if (office != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Lease Terms'),
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_month_rounded,
                      label: 'Minimum Lease',
                      value: '${office.minLeaseMonths ?? 0} months',
                      accentColor: _blue,
                    ),
                    _BoolRowSimple(
                      icon: Icons.autorenew_rounded,
                      label: 'Renewal Option',
                      value: office.hasRenewalOption ?? false,
                      trueColor: _blue,
                    ),
                    if (office.escalationPercentage != null)
                      _InfoRow(
                        icon: Icons.trending_up_rounded,
                        label: 'Annual Escalation',
                        value: '${office.escalationPercentage}%',
                        accentColor: _blue,
                        isLast: true,
                      )
                    else
                      _InfoRow(
                        icon: Icons.trending_flat_rounded,
                        label: 'Annual Escalation',
                        value: 'Negotiable',
                        accentColor: _blue,
                        isLast: true,
                      ),
                  ],
                ),
              ],
            ),
          ),

        // ── Pricing ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: _PricingBlock(listing: listing, accent: _blue),
        ),
      ],
    );
  }
}

// =============================================================================
//  4. ESTATE DETAILS PAGE
//  Focus: Unit count, communal amenities, security, developer info
// =============================================================================

class EstateDetailsPage extends StatelessWidget {
  const EstateDetailsPage({super.key, required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      listing: listing,
      accentColor: VeriRentColors.gold,
      categoryLabel: 'Estate',
      categoryIcon: Icons.domain_rounded,
      body: [
        // ── Estate Overview ─────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Estate Overview'),
              _HeroStatsBar(
                accentColor: VeriRentColors.gold,
                stats: [
                  _StatItem(
                    icon: Icons.domain_rounded,
                    value: '${listing.unitCount ?? '—'}',
                    label: 'Units',
                  ),
                  _StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  _StatItem(
                    icon: Icons.bed_rounded,
                    value: '${listing.bedrooms}bd',
                    label: 'Per Unit',
                  ),
                  _StatItem(
                    icon: Icons.bathtub_outlined,
                    value: '${listing.bathrooms}bth',
                    label: 'Per Unit',
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Security & Facilities ───────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Security & Communal'),
              _InfoCard(
                children: [
                  _BoolRowSimple(
                    icon: Icons.security_rounded,
                    label: 'Gated Community',
                    value: true,
                    trueColor: VeriRentColors.gold,
                  ),
                  _BoolRowSimple(
                    icon: Icons.videocam_rounded,
                    label: 'CCTV Surveillance',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('cctv'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  _BoolRowSimple(
                    icon: Icons.pool_rounded,
                    label: 'Swimming Pool',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('pool'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  _BoolRowSimple(
                    icon: Icons.fitness_center_rounded,
                    label: 'Gym / Fitness',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('gym'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  _BoolRowSimple(
                    icon: Icons.local_parking_rounded,
                    label: 'Visitor Parking',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('parking'),
                    ),
                    trueColor: VeriRentColors.gold,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── All Amenities ───────────────────────────────────
        if (listing.amenities!.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Estate Amenities'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities!
                        .map(
                          (a) => _AmenityPill(
                            label: a,
                            accentColor: VeriRentColors.gold,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

        // ── Pricing ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: _PricingBlock(listing: listing, accent: VeriRentColors.gold),
        ),
      ],
    );
  }
}

// =============================================================================
//  SHARED DETAIL WIDGETS
// =============================================================================

class _BoolRowSimple extends StatelessWidget {
  const _BoolRowSimple({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.trueColor,
  });
  final IconData icon;
  final String label;
  final bool value;
  final bool isLast;
  final Color? trueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final okColor = trueColor ?? VeriRentColors.success500;
    final activeColor = value ? okColor : cs.onSurfaceVariant;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(icon, size: 15, color: activeColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                ),
              ),
              Icon(
                value ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 18,
                color: value ? okColor : cs.outlineVariant,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: cs.outlineVariant,
            indent: 58,
            endIndent: 14,
          ),
      ],
    );
  }
}

class _AmenityPill extends StatelessWidget {
  const _AmenityPill({required this.label, this.accentColor});
  final String label;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: accentColor ?? VeriRentColors.success500,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              label,
              maxLines: 2,
              style: VeriRentText.bodySmall.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingBlock extends StatelessWidget {
  const _PricingBlock({required this.listing, required this.accent});
  final PropertyModel listing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing & Terms',
            style: VeriRentText.titleSmall.copyWith(color: accent),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '₦${listing.price}',
                  style: VeriRentText.headlineMedium.copyWith(color: accent),
                ),
              ),
              Flexible(
                child: Text(
                  listing.priceUnit!,
                  style: VeriRentText.labelMedium.copyWith(color: accent),
                ),
              ),
            ],
          ),
          if (listing.paymentTerms!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(VeriRentRadius.xs),
              ),
              child: Text(
                listing.paymentTerms!,
                style: VeriRentText.bodySmall.copyWith(color: accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
