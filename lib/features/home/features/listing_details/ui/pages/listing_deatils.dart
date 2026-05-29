// =============================================================================
//  VeriRent NG — Listing Details Page (Multi-Property Type)
//
//  Displays comprehensive property information for:
//  - Residential (House, Apartment, Duplex)
//  - Land & Plots
//  - Office & Commercial
//  - Residential Estates
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/agents_theme.dart';

class ListingDetailsPage extends StatefulWidget {
  const ListingDetailsPage({super.key, required this.listing});

  final PropertyListing listing;

  @override
  State<ListingDetailsPage> createState() => _ListingDetailsPageState();
}

class PropertyListing {
  final String id;
  final String propertyType; // House, Apartment, Duplex, Land, Office, Estate
  final String listingType; // Rent, Sale

  final String title;
  final String address;
  final String area;
  final String lga;
  final String state;

  final double price;
  final String priceUnit; // "per year" / "per month" / "one-time"
  final String paymentTerms; // "Lump sum" / "Installments available"

  final int? bedrooms;
  final int? bathrooms;
  final int? toilets;
  final double areaSqm;
  final String condition; // "New" / "Renovated" / "Good"

  final bool isVerified;
  final bool isFeatured;
  final double rating;
  final int reviewCount;

  final List<String> imageUrls;
  final String description;

  final AgencyProfile agency;
  final DocumentStatus documents;

  final List<String> amenities;
  final List<String> features;
  final Map<String, String> utilities;

  final List<NearbyFacility> nearbyFacilities;

  PropertyListing({
    required this.id,
    required this.propertyType,
    required this.listingType,
    required this.title,
    required this.address,
    required this.area,
    required this.lga,
    required this.state,
    required this.price,
    required this.priceUnit,
    required this.paymentTerms,
    this.bedrooms,
    this.bathrooms,
    this.toilets,
    required this.areaSqm,
    required this.condition,
    required this.isVerified,
    required this.isFeatured,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.description,
    required this.agency,
    required this.documents,
    required this.amenities,
    required this.features,
    required this.utilities,
    required this.nearbyFacilities,
  });
}

class AgencyProfile {
  final String id;
  final String name;
  final String logo;
  final String
  verificationTier; // Basic, Verified, Pro, Professional, Enterprise
  final int yearsInBusiness;
  final double rating;
  final int transactions;
  final String phone;
  final String email;
  final String address;

  AgencyProfile({
    required this.id,
    required this.name,
    required this.logo,
    required this.verificationTier,
    required this.yearsInBusiness,
    required this.rating,
    required this.transactions,
    required this.phone,
    required this.email,
    required this.address,
  });
}

class DocumentStatus {
  final bool hasOwnershipDoc;
  final bool hasLandRegistry;
  final bool hasCompletionCert;
  final bool hasLandUseCert;
  final bool hasBuiltingApproval;
  final String overallStatus; // Verified, Pending, Unverified

  DocumentStatus({
    required this.hasOwnershipDoc,
    required this.hasLandRegistry,
    required this.hasCompletionCert,
    required this.hasLandUseCert,
    required this.hasBuiltingApproval,
    required this.overallStatus,
  });
}

class NearbyFacility {
  final String name;
  final String type; // School, Hospital, Market, Bank, etc.
  final String distance;

  NearbyFacility({
    required this.name,
    required this.type,
    required this.distance,
  });
}

class _ListingDetailsPageState extends State<ListingDetailsPage> {
  int _currentImageIndex = 0;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    final listing = widget.listing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── Sticky Header ──────────────────────────────────
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: cs.surface,
              foregroundColor: cs.onSurface,
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
              actions: [
                GestureDetector(
                  onTap: () => setState(() => _isSaved = !_isSaved),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isSaved
                          ? VeriRentColors.red.withOpacity(0.15)
                          : cs.surfaceVariant,
                      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      border: Border.all(
                        color: _isSaved
                            ? VeriRentColors.red.withOpacity(0.4)
                            : cs.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      _isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _isSaved ? VeriRentColors.red : cs.onSurface,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.surfaceVariant,
                      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Icon(
                      Icons.share_rounded,
                      color: cs.onSurface,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              title: Text(
                listing.area,
                style: VeriRentText.labelMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(color: cs.outlineVariant, height: 1),
              ),
            ),

            // ── Image Gallery ──────────────────────────────────
            SliverToBoxAdapter(
              child: _ImageGallery(
                images: listing.imageUrls,
                onIndexChanged: (i) => setState(() => _currentImageIndex = i),
                currentIndex: _currentImageIndex,
                isFeatured: listing.isFeatured,
                isVerified: listing.isVerified,
              ),
            ),

            // ── Quick Info ─────────────────────────────────────
            SliverToBoxAdapter(child: _QuickInfoBar(listing: listing)),

            // ── Title & Location ───────────────────────────────
            SliverToBoxAdapter(child: _TitleSection(listing: listing)),

            // ── Key Specs ──────────────────────────────────────
            if (listing.bedrooms != null ||
                listing.bathrooms != null ||
                listing.areaSqm > 0)
              SliverToBoxAdapter(child: _KeySpecsSection(listing: listing)),

            // ── Price & Terms ─────────────────────────────────
            SliverToBoxAdapter(child: _PriceSection(listing: listing)),

            // ── Amenities Grid ────────────────────────────────
            if (listing.amenities.isNotEmpty)
              SliverToBoxAdapter(child: _AmenitiesSection(listing: listing)),

            // ── Features ───────────────────────────────────────
            if (listing.features.isNotEmpty)
              SliverToBoxAdapter(child: _FeaturesSection(listing: listing)),

            // ── Utilities ──────────────────────────────────────
            if (listing.utilities.isNotEmpty)
              SliverToBoxAdapter(child: _UtilitiesSection(listing: listing)),

            // ── Nearby Facilities ──────────────────────────────
            if (listing.nearbyFacilities.isNotEmpty)
              SliverToBoxAdapter(
                child: _NearbyFacilitiesSection(listing: listing),
              ),

            // ── Description ────────────────────────────────────
            SliverToBoxAdapter(child: _DescriptionSection(listing: listing)),

            // ── Documents & Verification ───────────────────────
            SliverToBoxAdapter(child: _DocumentsSection(listing: listing)),

            // ── Agent Profile ─────────────────────────────────
            SliverToBoxAdapter(child: _AgentSection(listing: listing)),

            // ── CTA Buttons ────────────────────────────────────
            SliverToBoxAdapter(child: _CTASection(listing: listing)),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ── Image Gallery ─────────────────────────────────────────────────────────────
class _ImageGallery extends StatefulWidget {
  const _ImageGallery({
    required this.images,
    required this.onIndexChanged,
    required this.currentIndex,
    required this.isFeatured,
    required this.isVerified,
  });
  final List<String> images;
  final ValueChanged<int> onIndexChanged;
  final int currentIndex;
  final bool isFeatured;
  final bool isVerified;

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 320,
      child: Stack(
        children: [
          // Pages
          PageView(
            controller: _pageController,
            onPageChanged: widget.onIndexChanged,
            children: widget.images
                .map(
                  (img) => Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.image_rounded,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                )
                .toList(),
          ),

          // Badges
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                if (widget.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: VeriRentColors.gold.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    ),
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
                const Spacer(),
                if (widget.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: VeriRentColors.success500.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
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

          // Counter
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(VeriRentRadius.full),
              ),
              child: Text(
                '${widget.currentIndex + 1} / ${widget.images.length}',
                style: VeriRentText.labelSmall.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          // Dots
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (i) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == widget.currentIndex
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
    );
  }
}

// ── Quick Info Bar ────────────────────────────────────────────────────────────
class _QuickInfoBar extends StatelessWidget {
  const _QuickInfoBar({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₦${(listing.price / 1000000).toStringAsFixed(1)}M',
                style: VeriRentText.headlineMedium.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                listing.priceUnit,
                style: VeriRentText.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: listing.isVerified
                  ? VeriRentColors.success500.withOpacity(0.12)
                  : VeriRentColors.warning500.withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(
                color: listing.isVerified
                    ? VeriRentColors.success500.withOpacity(0.4)
                    : VeriRentColors.warning500.withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  listing.isVerified
                      ? Icons.verified_rounded
                      : Icons.warning_amber_rounded,
                  size: 14,
                  color: listing.isVerified
                      ? VeriRentColors.success500
                      : VeriRentColors.warning500,
                ),
                const SizedBox(width: 4),
                Text(
                  listing.isVerified ? 'Verified' : 'Pending',
                  style: VeriRentText.labelSmall.copyWith(
                    color: listing.isVerified
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

// ── Title Section ─────────────────────────────────────────────────────────────
class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: VeriRentText.headlineSmall.copyWith(
                        color: cs.onSurface,
                      ),
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
                            '${listing.address}, ${listing.area}',
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _RatingChip(
                icon: Icons.star_rounded,
                label: '${listing.rating.toStringAsFixed(1)}',
                value: '${listing.reviewCount} reviews',
                color: VeriRentColors.gold,
              ),
              const SizedBox(width: 8),
              _RatingChip(
                icon: Icons.location_on_rounded,
                label: listing.lga,
                value: listing.state,
                color: VeriRentColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(VeriRentRadius.md),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: VeriRentText.labelSmall.copyWith(
                  color: color,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Key Specs ─────────────────────────────────────────────────────────────────
class _KeySpecsSection extends StatelessWidget {
  const _KeySpecsSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          if (listing.bedrooms != null)
            Expanded(
              child: _SpecItem(
                icon: Icons.bed_rounded,
                value: '${listing.bedrooms}',
                label: 'Bed',
              ),
            ),
          if (listing.bathrooms != null)
            Container(width: 1, color: cs.outlineVariant),
          if (listing.bathrooms != null)
            Expanded(
              child: _SpecItem(
                icon: Icons.bathtub_outlined,
                value: '${listing.bathrooms}',
                label: 'Bath',
              ),
            ),
          Container(width: 1, color: cs.outlineVariant),
          Expanded(
            child: _SpecItem(
              icon: Icons.square_foot_rounded,
              value: '${listing.areaSqm.toInt()}',
              label: 'sqm',
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
          ),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Price Section ─────────────────────────────────────────────────────────────
class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VeriRentColors.primaryDim,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: VeriRentColors.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing & Terms',
            style: VeriRentText.titleSmall.copyWith(
              color: VeriRentColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦${listing.price.toStringAsFixed(0)}',
                style: VeriRentText.headlineMedium.copyWith(
                  color: VeriRentColors.primary,
                ),
              ),
              Text(
                listing.priceUnit,
                style: VeriRentText.labelMedium.copyWith(
                  color: VeriRentColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: VeriRentColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(VeriRentRadius.xs),
            ),
            child: Text(
              listing.paymentTerms,
              style: VeriRentText.bodySmall.copyWith(
                color: VeriRentColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amenities Section ─────────────────────────────────────────────────────────
class _AmenitiesSection extends StatelessWidget {
  const _AmenitiesSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: listing.amenities
                .map(
                  (a) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
                          color: VeriRentColors.success500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          a,
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Features Section ──────────────────────────────────────────────────────────
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: List.generate(listing.features.length, (i) {
                final isLast = i == listing.features.length - 1;
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                        ),
                        child: Icon(
                          Icons.info_rounded,
                          size: 14,
                          color: cs.primary,
                        ),
                      ),
                      title: Text(
                        listing.features[i],
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, color: cs.outlineVariant, indent: 54),
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

// ── Utilities Section ─────────────────────────────────────────────────────────
class _UtilitiesSection extends StatelessWidget {
  const _UtilitiesSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Utilities & Services',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: listing.utilities.entries
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.key,
                          style: VeriRentText.labelSmall.copyWith(
                            color: cs.primary,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          e.value,
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurface,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Nearby Facilities ─────────────────────────────────────────────────────────
class _NearbyFacilitiesSection extends StatelessWidget {
  const _NearbyFacilitiesSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nearby Facilities',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: List.generate(listing.nearbyFacilities.length, (i) {
                final isLast = i == listing.nearbyFacilities.length - 1;
                final f = listing.nearbyFacilities[i];
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: VeriRentColors.primaryDim,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: VeriRentColors.primary,
                        ),
                      ),
                      title: Text(
                        f.name,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        f.type,
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      trailing: Text(
                        f.distance,
                        style: VeriRentText.labelSmall.copyWith(
                          color: cs.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, color: cs.outlineVariant, indent: 54),
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

// ── Description Section ───────────────────────────────────────────────────────
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.listing});
  final PropertyListing listing;

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
            listing.description,
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

// ── Documents Section ─────────────────────────────────────────────────────────
class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification & Documents',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: listing.documents.overallStatus == 'Verified'
                  ? VeriRentColors.success500.withOpacity(0.12)
                  : VeriRentColors.warning500.withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(
                color: listing.documents.overallStatus == 'Verified'
                    ? VeriRentColors.success500.withOpacity(0.4)
                    : VeriRentColors.warning500.withOpacity(0.4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  listing.documents.overallStatus == 'Verified'
                      ? Icons.verified_rounded
                      : Icons.warning_amber_rounded,
                  color: listing.documents.overallStatus == 'Verified'
                      ? VeriRentColors.success500
                      : VeriRentColors.warning500,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.documents.overallStatus == 'Verified'
                            ? 'All Documents Verified'
                            : 'Pending Verification',
                        style: VeriRentText.titleSmall.copyWith(
                          color: listing.documents.overallStatus == 'Verified'
                              ? VeriRentColors.success500
                              : VeriRentColors.warning500,
                        ),
                      ),
                      Text(
                        'Title deed · Land registry · Building approval',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
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

// ── Agent Section ─────────────────────────────────────────────────────────────
class _AgentSection extends StatelessWidget {
  const _AgentSection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final agency = listing.agency;
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(VeriRentRadius.md),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Icon(
                  Icons.business_rounded,
                  size: 28,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            agency.name,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (agency.verificationTier == 'Professional')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: VeriRentColors.info500.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(
                                VeriRentRadius.xs,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 8,
                                  color: VeriRentColors.info500,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Pro',
                                  style: VeriRentText.labelSmall.copyWith(
                                    color: VeriRentColors.info500,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: VeriRentColors.gold,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${agency.rating}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: cs.onSurface,
                            fontSize: 10,
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

// ── CTA Section ───────────────────────────────────────────────────────────────
class _CTASection extends StatelessWidget {
  const _CTASection({required this.listing});
  final PropertyListing listing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
              onPressed: () {},
              child: const Text('Request Details'),
            ),
          ),
        ],
      ),
    );
  }
}
