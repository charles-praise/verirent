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

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../domain/entities/property_model.dart';
import '../../domain/entities/statItems.dart';
import '../../widgets/aminityPill.dart';
import '../../widgets/boolRow.dart';
import '../../widgets/shared/detailScaffold.dart';
import '../../widgets/shared/heroStatBar.dart';
import '../../widgets/shared/infoCard.dart';
import '../../widgets/shared/infoRow.dart';
import '../../widgets/shared/pricing.dart';
import '../../widgets/shared/sectionTitle.dart';

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
//  1. RESIDENTIAL DETAILS PAGE
//  Focus: Rooms, furnishing, utilities, lifestyle amenities
// =============================================================================

class ResidentialDetailsPage extends StatelessWidget {
  const ResidentialDetailsPage({super.key, required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final res = listing.asResidential; // typed subclass accessor
    return DetailScaffold(
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
              const SectionTitle('Key Specs'),
              HeroStatsBar(
                accentColor: VeriRentColors.primary,
                stats: [
                  StatItem(
                    icon: Icons.bed_rounded,
                    value: '${listing.bedrooms}',
                    label: 'Bed',
                  ),
                  StatItem(
                    icon: Icons.bathtub_outlined,
                    value: '${listing.bathrooms}',
                    label: 'Bath',
                  ),
                  if (listing.toilets != null)
                    StatItem(
                      icon: Icons.wc_rounded,
                      value: '${listing.toilets}',
                      label: 'WC',
                    ),
                  StatItem(
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
                const SectionTitle('Furnishing & Condition'),
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Icons.chair_rounded,
                      label: 'Furnishing',
                      value: res.furnishing ?? "_",
                    ),
                    InfoRow(
                      icon: Icons.build_rounded,
                      label: 'Condition',
                      value: res.residentialCondition!.name.replaceAll(
                        '_',
                        ' ',
                      ),
                    ),
                    InfoRow(
                      icon: Icons.water_drop_rounded,
                      label: 'Water Supply',
                      value: res.waterSupply ?? "_",
                    ),
                    InfoRow(
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
                const SectionTitle('Security & Features'),
                InfoCard(
                  children: [
                    BoolRowSimple(
                      icon: Icons.ac_unit_rounded,
                      label: 'Air Conditioning',
                      value: res.hasAC ?? false,
                    ),
                    BoolRowSimple(
                      icon: Icons.local_parking_rounded,
                      label: 'Parking Space',
                      value: res.hasParking ?? false,
                    ),
                    BoolRowSimple(
                      icon: Icons.park_rounded,
                      label: 'Garden',
                      value: res.hasGarden ?? false,
                    ),
                    BoolRowSimple(
                      icon: Icons.fence_rounded,
                      label: 'Fenced',
                      value: res.isFenced ?? false,
                    ),
                    BoolRowSimple(
                      icon: Icons.security_rounded,
                      label: 'Security Guard',
                      value: res.hasSecurityGuard ?? false,
                    ),
                    BoolRowSimple(
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
                const SectionTitle('Amenities'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities!
                        .map((a) => AmenityPill(label: a))
                        .toList(),
                  ),
                ),
              ],
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
    return DetailScaffold(
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
              const SectionTitle('Plot Details'),
              HeroStatsBar(
                accentColor: _green,
                stats: [
                  StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  if (land != null) ...[
                    StatItem(
                      icon: Icons.straighten_rounded,
                      value: land.dimensions ?? "_",
                      label: 'Dimensions',
                    ),
                    StatItem(
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
                const SectionTitle('Legal Documents'),
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Icons.description_rounded,
                      label: 'Document Type',
                      value: land.documentType ?? "_",
                      accentColor: _green,
                    ),
                    InfoRow(
                      icon: Icons.assignment_rounded,
                      label: 'Survey Plan No.',
                      value: land.surveyPlanNumber!.isNotEmpty
                          ? land.surveyPlanNumber!
                          : 'Pending',
                      accentColor: _green,
                    ),
                    InfoRow(
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
                const SectionTitle('Infrastructure'),
                InfoCard(
                  children: [
                    BoolRowSimple(
                      icon: Icons.bolt_rounded,
                      label: 'Electricity Poles',
                      value: land.hasElectricityPoles ?? false,
                      trueColor: _green,
                    ),
                    BoolRowSimple(
                      icon: Icons.water_rounded,
                      label: 'Water Line',
                      value: land.hasWaterLine ?? false,
                      trueColor: _green,
                    ),
                    BoolRowSimple(
                      icon: Icons.drag_handle_sharp,
                      label: 'Drainage',
                      value: land.hasDrainage ?? false,
                      trueColor: _green,
                    ),
                    BoolRowSimple(
                      icon: Icons.add_road_rounded,
                      label: 'Tarred Road Access',
                      value: land.hasTarredRoad ?? false,
                      trueColor: _green,
                    ),
                    BoolRowSimple(
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
                const SectionTitle('Zoning & Restrictions'),
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Icons.map_rounded,
                      label: 'Zoning Class',
                      value: land.zoningClassification ?? "_",
                      accentColor: _green,
                    ),
                    InfoRow(
                      icon: Icons.height_rounded,
                      label: 'Max Building Height',
                      value: land.maxBuildingHeight != null
                          ? '${land.maxBuildingHeight} floors'
                          : 'No limit',
                      accentColor: _green,
                    ),
                    BoolRowSimple(
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
    return DetailScaffold(
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
              const SectionTitle('Space Details'),
              HeroStatsBar(
                accentColor: _blue,
                stats: [
                  StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  if (office != null) ...[
                    StatItem(
                      icon: Icons.layers_rounded,
                      value: office.floorLevel != null
                          ? '${office.floorLevel}F'
                          : 'GF',
                      label: 'Floor',
                    ),
                    StatItem(
                      icon: Icons.local_parking_rounded,
                      value: '${office.parkingSpaces}',
                      label: 'Parking',
                    ),
                    StatItem(
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
                const SectionTitle('Facilities'),
                InfoCard(
                  children: [
                    BoolRowSimple(
                      icon: Icons.ac_unit_rounded,
                      label: 'HVAC System',
                      value: office.hasHVAC ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.elevator_rounded,
                      label: 'Elevator',
                      value: office.hasElevator ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.accessible_rounded,
                      label: 'Disabled Access',
                      value: office.hasDisabledAccess ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.kitchen_rounded,
                      label: 'Kitchen',
                      value: office.hasKitchen ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.meeting_room_rounded,
                      label: 'Conference Room',
                      value: office.hasConferenceRoom ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.wifi_rounded,
                      label: 'Internet',
                      value: office.hasInternet ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.bolt_rounded,
                      label: '24hr Power',
                      value: office.has24HourPower ?? false,
                      trueColor: _blue,
                    ),
                    BoolRowSimple(
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
                const SectionTitle('Lease Terms'),
                InfoCard(
                  children: [
                    InfoRow(
                      icon: Icons.calendar_month_rounded,
                      label: 'Minimum Lease',
                      value: '${office.minLeaseMonths ?? 0} months',
                      accentColor: _blue,
                    ),
                    BoolRowSimple(
                      icon: Icons.autorenew_rounded,
                      label: 'Renewal Option',
                      value: office.hasRenewalOption ?? false,
                      trueColor: _blue,
                    ),
                    if (office.escalationPercentage != null)
                      InfoRow(
                        icon: Icons.trending_up_rounded,
                        label: 'Annual Escalation',
                        value: '${office.escalationPercentage}%',
                        accentColor: _blue,
                        isLast: true,
                      )
                    else
                      InfoRow(
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
          child: PricingBlock(listing: listing, accent: _blue),
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
    return DetailScaffold(
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
              const SectionTitle('Estate Overview'),
              HeroStatsBar(
                accentColor: VeriRentColors.gold,
                stats: [
                  StatItem(
                    icon: Icons.domain_rounded,
                    value: '${listing.unitCount ?? '—'}',
                    label: 'Units',
                  ),
                  StatItem(
                    icon: Icons.square_foot_rounded,
                    value: listing.area!,
                    label: 'sqm',
                  ),
                  StatItem(
                    icon: Icons.bed_rounded,
                    value: '${listing.bedrooms}bd',
                    label: 'Per Unit',
                  ),
                  StatItem(
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
              const SectionTitle('Security & Communal'),
              InfoCard(
                children: [
                  BoolRowSimple(
                    icon: Icons.security_rounded,
                    label: 'Gated Community',
                    value: true,
                    trueColor: VeriRentColors.gold,
                  ),
                  BoolRowSimple(
                    icon: Icons.videocam_rounded,
                    label: 'CCTV Surveillance',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('cctv'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  BoolRowSimple(
                    icon: Icons.pool_rounded,
                    label: 'Swimming Pool',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('pool'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  BoolRowSimple(
                    icon: Icons.fitness_center_rounded,
                    label: 'Gym / Fitness',
                    value: listing.amenities!.any(
                      (a) => a.toLowerCase().contains('gym'),
                    ),
                    trueColor: VeriRentColors.gold,
                  ),
                  BoolRowSimple(
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
                const SectionTitle('Estate Amenities'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: listing.amenities!
                        .map(
                          (a) => AmenityPill(
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
          child: PricingBlock(listing: listing, accent: VeriRentColors.gold),
        ),
      ],
    );
  }
}

// =============================================================================
//  SHARED DETAIL WIDGETS
// =============================================================================
