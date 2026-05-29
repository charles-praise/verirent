import 'package:flutter/material.dart';

import '../../../core/theme/agents_theme.dart';
import '../domain/entities/home_listing_card.dart';
import '../domain/entities/home_quick_action.dart';

const List<QuickAction> kActions = [
  QuickAction(
    label: 'Find Agency',
    icon: Icons.business_outlined,
    color: VeriRentColors.primary500,
  ),
  QuickAction(
    label: 'Verify Listing',
    icon: Icons.fact_check_outlined,
    color: VeriRentColors.secondary500,
  ),
  QuickAction(
    label: 'My Documents',
    icon: Icons.folder_outlined,
    color: VeriRentColors.success500,
  ),
  QuickAction(
    label: 'File Dispute',
    icon: Icons.gavel_outlined,
    color: VeriRentColors.warning700,
  ),
];

const List<ListingCard> kFeatured = [
  ListingCard(
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
    reviewCount: 1,
    areaSqm: "2",
    agentAvatarUrl: "",
    rating: 1,
    agentInitials: "",
  ),
  // ListingCard(
  //   title: 'Modern 2-Bed Self-Contain',
  //   location: 'Trans Amadi, Port Harcourt',
  //   price: '₦1,200,000/yr',
  //   bedrooms: 2,
  //   bathrooms: 1,
  //   agencyName: 'Bright Horizons Realty',
  //   tierLabel: 'Starter Agency',
  //   tierColor: VeriRentColors.tierStarterAgency,
  //   isVerified: true,
  //   emoji: '🏠',
  // ),
  // ListingCard(
  //   title: 'Serviced Studio Apartment',
  //   location: 'D-Line, Port Harcourt',
  //   price: '₦900,000/yr',
  //   bedrooms: 1,
  //   bathrooms: 1,
  //   agencyName: 'NovaProp Agency',
  //   tierLabel: 'Enterprise Agency',
  //   tierColor: VeriRentColors.tierEnterprise,
  //   isVerified: true,
  //   emoji: '🏙️',
  // ),
];

const List<ListingCard> kRecent = [
  ListingCard(
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
  ListingCard(
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
  ListingCard(
    title: 'Mini-flat with BQ',
    location: 'Rumuola, Port Harcourt',
    price: '₦750,000/yr',
    bedrooms: 2,
    bathrooms: 2,
    agencyName: 'Rivers Verified Agent',
    tierLabel: 'Basic Individual',
    tierColor: VeriRentColors.tierBasic,
    isVerified: false,
    emoji: '🏘️',
  ),
];
