// =============================================================================
//  VeriRent NG — Mock / Dummy Data
//  Used for widget testing, UI previews, and development scaffolding.
//
//  Covers all property categories and chat threads:
//    kChatThread    -> list of chat threads
//    kFeatured       → horizontal featured cards (mixed categories)
//    kRecent         → recently added listings (compact cards)
//    kAvailable      → available listings (vertical/masonry)
//    kLandListings   → land/plot only
//    kCommercial     → office/shop/commercial only
//    kEstates        → estate/gated community only
//    kShortlets      → shortlet/per-night only
//    kSaved          → saved listings (for saved page)
//    kAgencies       → agency profiles (for agency banner / agent section)
//    kNearbyFacilities → nearby facilities (for listing detail)
// =============================================================================

// =============================================================================
//  NEARBY FACILITIES
// =============================================================================

import '../../features/message/ui/cubit/message_state.dart';
import '../models/property_model.dart';
import '../theme/agents_theme.dart';

final List<NearbyFacility> kNearbyFacilitiesGRA = [
  NearbyFacility(
    name: 'University of Port Harcourt Teaching Hospital',
    type: 'Hospital',
    distance: '1.2 km',
  ),
  NearbyFacility(
    name: 'GRA Phase 2 Market',
    type: 'Market',
    distance: '0.4 km',
  ),
  NearbyFacility(
    name: 'Rainbow International School',
    type: 'School',
    distance: '0.8 km',
  ),
  NearbyFacility(
    name: 'Shell Filling Station',
    type: 'Fuel Station',
    distance: '0.2 km',
  ),
  NearbyFacility(
    name: 'Garden City Mall',
    type: 'Shopping',
    distance: '2.1 km',
  ),
];

List<NearbyFacility> kNearbyFacilitiesTransAmadi = [
  NearbyFacility(
    name: 'Trans-Amadi Industrial Layout',
    type: 'Industrial Zone',
    distance: '0.3 km',
  ),
  NearbyFacility(
    name: 'Rumuola Road Junction',
    type: 'Transit Hub',
    distance: '1.0 km',
  ),
  NearbyFacility(
    name: 'Port Harcourt Polo Club',
    type: 'Recreation',
    distance: '1.8 km',
  ),
];

List<NearbyFacility> kNearbyFacilitiesDLine = [
  NearbyFacility(name: 'D/Line Market', type: 'Market', distance: '0.1 km'),
  NearbyFacility(
    name: 'Braithwaite Memorial Hospital',
    type: 'Hospital',
    distance: '0.9 km',
  ),
  NearbyFacility(
    name: 'Port Harcourt City LGA Secretariat',
    type: 'Government',
    distance: '1.3 km',
  ),
];

// =============================================================================
//  CHAT THREADS
// =============================================================================
List<ChatThread> mockThreads() {
  final now = DateTime.now();
  // return [
  //   ChatThread(
  //     id: 'thread_1',
  //     participantName: 'Greenfield Estates',
  //     participantRole: 'Agency',
  //     initials: 'GE',
  //     lastMessage:
  //         'The property is available from 1st July. Would you like to arrange a viewing?',
  //     lastMessageTime: now.subtract(const Duration(minutes: 5)),
  //     unreadCount: 2,
  //     isOnline: true,
  //     isVerifiedAgency: true,
  //     propertyTitle: '3 Bedroom Flat, GRA Phase 2',
  //     messages: [
  //       ChatMessage(
  //         id: 'm1',
  //         senderId: 'thread_1',
  //         text:
  //             'Hello! Thank you for your interest in the GRA Phase 2 property.',
  //         timestamp: now.subtract(const Duration(hours: 1)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'm2',
  //         senderId: 'me',
  //         text:
  //             'Hi, I would like to know more about the property. Is it still available?',
  //         timestamp: now.subtract(const Duration(minutes: 50)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'm3',
  //         senderId: 'thread_1',
  //         text:
  //             'Yes, it is still available! The asking rent is ₦1,800,000 per annum.',
  //         timestamp: now.subtract(const Duration(minutes: 45)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'm4',
  //         senderId: 'me',
  //         text: 'Great. Are utilities included?',
  //         timestamp: now.subtract(const Duration(minutes: 20)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'm5',
  //         senderId: 'thread_1',
  //         text:
  //             'The property is available from 1st July. Would you like to arrange a viewing?',
  //         timestamp: now.subtract(const Duration(minutes: 5)),
  //         status: MessageStatus.delivered,
  //       ),
  //     ],
  //   ),
  //   ChatThread(
  //     id: 'thread_2',
  //     participantName: 'Apex Realty NG',
  //     participantRole: 'Agency',
  //     initials: 'AR',
  //     lastMessage:
  //         'Documents are ready. Please visit our office at your convenience.',
  //     lastMessageTime: now.subtract(const Duration(hours: 2)),
  //     unreadCount: 0,
  //     isOnline: false,
  //     isVerifiedAgency: true,
  //     propertyTitle: 'Executive Duplex, Trans-Amadi',
  //     messages: [
  //       ChatMessage(
  //         id: 'a1',
  //         senderId: 'thread_2',
  //         text:
  //             'Good day! This is Apex Realty regarding the Trans-Amadi duplex.',
  //         timestamp: now.subtract(const Duration(hours: 3)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'a2',
  //         senderId: 'me',
  //         text:
  //             'Yes, I\'m very interested. What are the title documents available?',
  //         timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'a3',
  //         senderId: 'thread_2',
  //         text:
  //             'Documents are ready. Please visit our office at your convenience.',
  //         timestamp: now.subtract(const Duration(hours: 2)),
  //         status: MessageStatus.read,
  //       ),
  //     ],
  //   ),
  //   ChatThread(
  //     id: 'thread_3',
  //     participantName: 'HomeFinders NG',
  //     participantRole: 'Agency',
  //     initials: 'HF',
  //     lastMessage:
  //         'We have two other options in Rumuola that match your budget.',
  //     lastMessageTime: now.subtract(const Duration(days: 1)),
  //     unreadCount: 1,
  //     isOnline: true,
  //     isVerifiedAgency: false,
  //     propertyTitle: 'Studio Apartment, Rumuola',
  //     messages: [
  //       ChatMessage(
  //         id: 'h1',
  //         senderId: 'thread_3',
  //         text: 'Hello! We noticed you saved our Rumuola studio listing.',
  //         timestamp: now.subtract(const Duration(days: 1, hours: 2)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'h2',
  //         senderId: 'me',
  //         text: 'Yes, I\'m looking for something around that price range.',
  //         timestamp: now.subtract(const Duration(days: 1, hours: 1)),
  //         status: MessageStatus.read,
  //       ),
  //       ChatMessage(
  //         id: 'h3',
  //         senderId: 'thread_3',
  //         text: 'We have two other options in Rumuola that match your budget.',
  //         timestamp: now.subtract(const Duration(days: 1)),
  //         status: MessageStatus.delivered,
  //       ),
  //     ],
  //   ),
  //   ChatThread(
  //     id: 'thread_4',
  //     participantName: 'VeriRent Support',
  //     participantRole: 'Admin',
  //     initials: 'VR',
  //     lastMessage:
  //         'Your account has been verified. You can now access all features.',
  //     lastMessageTime: now.subtract(const Duration(days: 3)),
  //     unreadCount: 0,
  //     isOnline: true,
  //     isVerifiedAgency: false,
  //     messages: [
  //       ChatMessage(
  //         id: 'sys1',
  //         senderId: 'thread_4',
  //         text: 'Welcome to VeriRent NG! Your account has been created.',
  //         timestamp: now.subtract(const Duration(days: 4)),
  //         status: MessageStatus.read,
  //         isSystem: true,
  //       ),
  //       ChatMessage(
  //         id: 'sys2',
  //         senderId: 'thread_4',
  //         text:
  //             'Your account has been verified. You can now access all features.',
  //         timestamp: now.subtract(const Duration(days: 3)),
  //         status: MessageStatus.read,
  //         isSystem: true,
  //       ),
  //     ],
  //   ),
  // ];
  return [];
}

// =============================================================================
//  AGENCY PROFILES
// =============================================================================

final AgencyModel kAgencyGreenfield = AgencyModel(
  id: 'ag_01',
  name: 'Greenfield Estates Ltd',
  verificationTier: VerificationTier.professional,
  rating: 4.8,
  transactions: 142,
  esvarbon: 'ESVARBON/PH/2019/0341',
  phone: '+234 803 456 7890',
  email: 'info@greenfieldestates.ng',
  address: '14 Aba Road, GRA Phase 2, Port Harcourt',
);

final AgencyModel kAgencyApex = AgencyModel(
  id: 'ag_02',
  name: 'Apex Realty NG',
  verificationTier: VerificationTier.enterprise,
  rating: 4.9,
  transactions: 287,
  esvarbon: 'ESVARBON/PH/2016/0112',
  phone: '+234 701 234 5678',
  email: 'contact@apexrealty.ng',
  address: '3 Rumuola Road, Port Harcourt',
);

final AgencyModel kAgencyHomeFinders = AgencyModel(
  id: 'ag_03',
  name: 'HomeFinders NG',
  verificationTier: VerificationTier.starter,
  rating: 4.2,
  transactions: 38,
  esvarbon: 'ESVARBON/PH/2022/0789',
  phone: '+234 806 789 0123',
  email: 'hello@homefinders.ng',
  address: '7 Rumuola Avenue, Port Harcourt',
);

final AgencyModel kAgencyElite = AgencyModel(
  id: 'ag_04',
  name: 'Elite Property Solutions',
  verificationTier: VerificationTier.professional,
  rating: 4.6,
  transactions: 95,
  esvarbon: 'ESVARBON/PH/2020/0456',
  phone: '+234 802 345 6789',
  email: 'info@eliteproperty.ng',
  address: '22 Trans-Amadi Road, Port Harcourt',
);

// =============================================================================
//  DOCUMENT MODELS
// =============================================================================

final DocumentModel kDocumentsVerified = DocumentModel(
  overallStatus: OverallStatus.verified,
  titleDeed: true,
  landRegistry: true,
  buildingApproval: true,
  surveyPlan: true,
);

final DocumentModel kDocumentsPending = DocumentModel(
  overallStatus: OverallStatus.pending,
  titleDeed: true,
  landRegistry: false,
  buildingApproval: false,
  surveyPlan: true,
);

// =============================================================================
//  RESIDENTIAL LISTINGS
// =============================================================================

final PropertyModel kResidential1 = PropertyModel(
  id: 'res_01',
  category: PropertyCategory.residential,
  type: PropertyType.apartment,
  listingType: ListingType.rent,
  title: '3 Bedroom Flat, GRA Phase 2',
  description:
      'A spacious and well-maintained 3-bedroom flat located in the serene GRA Phase 2 area of Port Harcourt. '
      'The property features quality finishes, prepaid meter, constant water supply via borehole, and a dedicated parking space. '
      'Situated within a secure and well-managed compound, this is ideal for professionals and families seeking comfort in a prime location.',
  price: '1,800,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum or 2 installments',
  address: '14 Aba Road',
  area: 'GRA Phase 2',
  lga: 'Port Harcourt',
  state: 'Rivers',
  areaSqm: 120.0,
  bedrooms: 3,
  bathrooms: 2,
  toilets: 3,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Greenfield Estates Ltd',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '🏠',
  rating: 4.8,
  reviewCount: 24,
  agentInitials: 'GE',
  location: 'GRA Phase 2, Port Harcourt',
  propertyType: 'Apartment',
  imageUrls: [
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
    'https://images.unsplash.com/photo-1554995207-c18c203602cb?w=600',
  ],
  amenities: [
    'Prepaid Meter',
    'Borehole Water',
    'Dedicated Parking',
    'Security Guard',
    'Tiled Floors',
    'POP Ceiling',
  ],
  features: [
    'Air Conditioning in all rooms',
    'Spacious kitchen with modern fittings',
    'Ensuite master bedroom',
    'External laundry room',
  ],
  utilities: {
    'Electricity': 'Prepaid NEPA + Generator',
    'Water': 'Borehole',
    'Internet': 'Fibre-ready',
  },
  nearbyFacilities: kNearbyFacilitiesGRA,
  listedBy: UserType.starter,
  userId: 'user_ag01',
  agencyId: 'ag_01',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyGreenfield,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 4, 10),
  updatedAt: DateTime(2026, 5, 1),
  // ResidentialProperty fields
  asResidential: AsResidential(
    furnishing: 'Unfurnished',
    waterSupply: 'Borehole',
    powerSupply: 'NEPA + Generator',
    hasAC: true,
    hasParking: true,
    hasGarden: false,
    isFenced: true,
    hasSecurityGuard: true,
    hasCCTV: true,
    hasAlarmSystem: false,
    yearBuilt: 2019,
    hasTitleDocument: true,
    hasBuildingApproval: true,
    residentialCondition: PropertyCondition.good,
    condition: '',
  ),
);

final PropertyModel kResidential2 = PropertyModel(
  id: 'res_02',
  category: PropertyCategory.residential,
  type: PropertyType.duplex,
  listingType: ListingType.rent,
  title: 'Executive 4 Bedroom Duplex, Trans-Amadi',
  description:
      'Luxurious 4-bedroom fully detached duplex in the heart of Trans-Amadi, Port Harcourt. '
      'Features an open-plan living area, fitted kitchen, boys quarter, and a beautifully landscaped garden. '
      'Ideal for corporate tenants and expatriates. 24-hour security and standby generator.',
  price: '4,500,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum',
  address: '7 Trans-Amadi Road',
  area: 'Trans-Amadi',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 250.0,
  bedrooms: 4,
  bathrooms: 4,
  toilets: 5,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Apex Realty NG',
  tierLabel: 'Enterprise Agency',
  tierColor: VeriRentColors.tierEnterprise,
  emoji: '🏡',
  rating: 4.9,
  reviewCount: 51,
  agentInitials: 'AR',
  location: 'Trans-Amadi, Port Harcourt',
  propertyType: 'Duplex',
  imageUrls: [
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=600',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600',
  ],
  amenities: [
    '24hr Security',
    'Standby Generator',
    'Swimming Pool',
    'Boys Quarter',
    'CCTV',
    'Fitted Kitchen',
    'Garden',
    'Parking (3 cars)',
  ],
  features: [
    'Open-plan living and dining area',
    'Master bedroom with walk-in wardrobe',
    'Fully fitted modern kitchen with island',
    'Rooftop terrace with city view',
  ],
  utilities: {
    'Electricity': 'NEPA + 25kVA Generator',
    'Water': 'Borehole + Overhead Tank',
    'Internet': '100Mbps Fibre',
    'Gas': 'Cooking Gas Connection',
  },
  nearbyFacilities: kNearbyFacilitiesTransAmadi,
  listedBy: UserType.starter,
  userId: 'user_ag02',
  agencyId: 'ag_02',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyApex,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 3, 15),
  updatedAt: DateTime(2026, 4, 28),
  asResidential: AsResidential(
    furnishing: 'Fully Furnished',
    waterSupply: 'Borehole + Overhead Tank',
    powerSupply: 'NEPA + Generator',
    hasAC: true,
    hasParking: true,
    hasGarden: true,
    isFenced: true,
    hasSecurityGuard: true,
    hasCCTV: true,
    hasAlarmSystem: true,
    yearBuilt: 2021,
    hasTitleDocument: true,
    hasBuildingApproval: true,
    residentialCondition: PropertyCondition.new_property,
  ),
);

final PropertyModel kResidential3 = PropertyModel(
  id: 'res_03',
  category: PropertyCategory.residential,
  type: PropertyType.apartment,
  listingType: ListingType.rent,
  title: 'Studio Apartment, Rumuola',
  description:
      'Compact and affordable studio apartment in Rumuola, perfect for young professionals and students. '
      'Self-contained with a kitchenette, bathroom, and secure access. '
      'Close to major roads and public transport.',
  price: '550,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum',
  address: '9 Rumuola Avenue',
  area: 'Rumuola',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 35.0,
  bedrooms: 1,
  bathrooms: 1,
  toilets: 1,
  isVerified: false,
  isFeatured: false,
  agencyName: 'HomeFinders NG',
  tierLabel: 'Starter Agency',
  tierColor: VeriRentColors.tierStarterAgency,
  emoji: '🛋️',
  rating: 4.1,
  reviewCount: 8,
  agentInitials: 'HF',
  location: 'Rumuola, Port Harcourt',
  propertyType: 'Studio',
  imageUrls: [
    'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=600',
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600',
  ],
  amenities: ['Prepaid Meter', 'Secure Compound', 'Tiled Floors'],
  features: ['Self-contained unit', 'Kitchenette with gas cooker'],
  utilities: {'Electricity': 'Prepaid NEPA', 'Water': 'Public + Tank'},
  nearbyFacilities: [],
  listedBy: UserType.starter,
  userId: 'user_ag03',
  agencyId: 'ag_03',
  verificationStatus: VerificationStatus.pending,
  agency: kAgencyHomeFinders,
  documents: kDocumentsPending,
  createdAt: DateTime(2026, 5, 5),
  updatedAt: DateTime(2026, 5, 20),
  asResidential: AsResidential(
    furnishing: 'Unfurnished',
    waterSupply: 'Public',
    powerSupply: 'Prepaid NEPA',
    hasAC: false,
    hasParking: false,
    hasGarden: false,
    isFenced: true,
    hasSecurityGuard: false,
    hasCCTV: false,
    hasAlarmSystem: false,
    hasTitleDocument: true,
    hasBuildingApproval: false,
    residentialCondition: PropertyCondition.good,
  ),
);

final PropertyModel kResidential4 = PropertyModel(
  id: 'res_04',
  category: PropertyCategory.residential,
  type: PropertyType.house,
  listingType: ListingType.sale,
  title: '5 Bedroom Detached House, Old GRA',
  description:
      'A grand 5-bedroom detached house on a corner plot in Old GRA. '
      'Featuring a spacious compound, double garage, servants quarters, and a mature garden. '
      'Certificate of Occupancy available. Ideal for owner-occupier or high-end rental investment.',
  price: '120,000,000',
  priceUnit: 'asking price',
  paymentTerms: 'Negotiable',
  address: '3 Aggrey Road',
  area: 'Old GRA',
  lga: 'Port Harcourt',
  state: 'Rivers',
  areaSqm: 420.0,
  bedrooms: 5,
  bathrooms: 5,
  toilets: 7,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Elite Property Solutions',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '🏘️',
  rating: 4.7,
  reviewCount: 19,
  agentInitials: 'EP',
  location: 'Old GRA, Port Harcourt, Tombia Street',
  propertyType: 'Detached House Quite Environment',
  imageUrls: [
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=600',
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=600',
    'https://images.unsplash.com/photo-1523217582562-09d0def993a6?w=600',
  ],
  amenities: [
    'Certificate of Occupancy',
    'Double Garage',
    'Servants Quarters',
    'Mature Garden',
    'CCTV',
    '24hr Security',
    'Borehole',
    'Standby Generator',
  ],
  features: [
    'Corner plot with expansive compound',
    'Large master suite with dressing room',
    'Formal dining and sitting rooms',
    'Study / home office',
    'External laundry and utility room',
  ],
  utilities: {
    'Electricity': 'NEPA + 45kVA Generator',
    'Water': 'Borehole + Overhead Tank',
    'Internet': 'Fibre-ready',
  },
  nearbyFacilities: kNearbyFacilitiesGRA,
  listedBy: UserType.starter,
  userId: 'user_ag04',
  agencyId: 'ag_04',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyElite,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 2, 1),
  updatedAt: DateTime(2026, 5, 10),
  asResidential: AsResidential(
    furnishing: 'Unfurnished',
    waterSupply: 'Borehole',
    powerSupply: 'NEPA + Generator',
    hasAC: true,
    hasParking: true,
    hasGarden: true,
    isFenced: true,
    hasSecurityGuard: true,
    hasCCTV: true,
    hasAlarmSystem: true,
    yearBuilt: 2005,
    hasTitleDocument: true,
    hasBuildingApproval: true,
    residentialCondition: PropertyCondition.renovated,
  ),
);

// =============================================================================
//  LAND LISTINGS
// =============================================================================

final PropertyModel kLand1 = PropertyModel(
  id: 'land_01',
  category: PropertyCategory.land,
  type: PropertyType.land,
  listingType: ListingType.sale,
  title: 'Dry Land, 648 sqm — Rumuigbo,nnnn',
  description:
      'A 648 sqm dry land in a fast-developing area of Rumuigbo, Obio-Akpor LGA. '
      'The land is fenced, has boundary demarcation, and road frontage. '
      'Registered survey plan available. Suitable for residential or commercial development.',
  price: '18,500,000,000',
  priceUnit: 'asking price vvvv',
  paymentTerms: 'Outright purchase vvvvv',
  address: 'Rumuigbo Layout, nnnnn',
  area: 'Rumuigbo ll',
  lga: 'Obio-Akpor llll',
  state: 'Rivers lllll',
  areaSqm: 648.0,
  bedrooms: 11111,
  bathrooms: 11111,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Greenfield Estates Ltd vvvvv',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '🌿',
  rating: 4.6,
  reviewCount: 12,
  agentInitials: 'GE',
  location: 'Rumuigbo, Obio-Akpor bbbbb',
  propertyType: 'Residential Land',
  imageUrls: [
    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600',
  ],
  amenities: [
    'Fenced Perimeter kkkkkkkkk',
    'Tarred Road Access kkkkkkkkkkkkk',
    'Electricity Poles Nearby kkkkkkkkkkkkkkk',
    'Drainage',
  ],
  features: ['Survey plan available', 'Boundary clearly demarcated'],
  utilities: {},
  nearbyFacilities: [],
  listedBy: UserType.starter,
  userId: 'user_ag01',
  agencyId: 'ag_01',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyGreenfield,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 4, 2),
  updatedAt: DateTime(2026, 5, 3),
  // LandProperty fields
  asLand: AsLand(
    landUse: 'Residential',
    dimensions: '18m × 36m',
    landCondition: 'Fenced',
    hasStreetFrontage: true,
    streetFrontageMeters: 18,
    isAccessibleByRoad: true,
    surveyPlanNumber: 'SPH/OA/2023/04412',
    landRegistryReference: 'LR/PH/2023/0881',
    documentType: 'C of Ommmmmmmmmmmmmmmmmmm',
    hasBoundaryDemarcation: true,
    hasElectricityPoles: true,
    hasWaterLine: false,
    hasDrainage: true,
    hasTarredRoad: true,
    zoningClassification: 'Residential (R1)',
    maxBuildingHeight: 3,
    allowsCommercial: false,
  ),
);

final PropertyModel kLand2 = PropertyModel(
  id: 'land_02',
  category: PropertyCategory.land,
  type: PropertyType.land,
  listingType: ListingType.sale,
  title: 'Commercial Plot, 1200 sqm — D-Line',
  description:
      'Premium 1200 sqm commercial plot in D/Line with a Deed of Assignment. '
      'Suitable for plaza, office complex, or mixed-use development. '
      'Tarred road access, drainage, and proximity to D/Line market.',
  price: '45,000,000',
  priceUnit: 'asking price',
  paymentTerms: 'Negotiable',
  address: 'D/Line Layout',
  area: 'D-Line',
  lga: 'Port Harcourt',
  state: 'Rivers',
  areaSqm: 1200.0,
  bedrooms: 0,
  bathrooms: 0,
  isVerified: true,
  isFeatured: false,
  agencyName: 'Apex Realty NG',
  tierLabel: 'Enterprise Agency',
  tierColor: VeriRentColors.tierEnterprise,
  emoji: '🏗️',
  rating: 4.5,
  reviewCount: 7,
  agentInitials: 'AR',
  location: 'D-Line, Port Harcourt',
  propertyType: 'Commercial Plot',
  imageUrls: [
    'https://images.unsplash.com/photo-1448630360428-65456885c650?w=600',
    'https://images.unsplash.com/photo-1486325212027-8081e485255e?w=600',
  ],
  amenities: ['Tarred Road', 'Drainage', 'Electricity Poles'],
  features: [
    'Deed of Assignment available',
    'Zoned for commercial use',
    'Strategic location near D/Line Market',
  ],
  utilities: {},
  nearbyFacilities: kNearbyFacilitiesDLine,
  listedBy: UserType.starter,
  userId: 'user_ag02',
  agencyId: 'ag_02',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyApex,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 3, 20),
  updatedAt: DateTime(2026, 4, 15),
  asLand: AsLand(
    landUse: 'Commercial',
    dimensions: '30m × 40m',
    landCondition: 'Undeveloped',
    hasStreetFrontage: true,
    streetFrontageMeters: 30,
    isAccessibleByRoad: true,
    surveyPlanNumber: 'SPH/PHC/2021/00723',
    landRegistryReference: 'LR/PHC/2021/0334',
    documentType: 'Deed of Assignment',
    hasBoundaryDemarcation: false,
    hasElectricityPoles: true,
    hasWaterLine: true,
    hasDrainage: true,
    hasTarredRoad: true,
    zoningClassification: 'Commercial (C2)',
    maxBuildingHeight: null,
    allowsCommercial: true,
  ),
);

final PropertyModel kLand3 = PropertyModel(
  id: 'land_03',
  category: PropertyCategory.land,
  type: PropertyType.land,
  listingType: ListingType.sale,
  title: 'Farm Land, 5 Acres — Igwuruta',
  description:
      'Fertile 5-acre farm land in Igwuruta with good soil quality and access to a seasonal stream. '
      'Suitable for crop farming, poultry, or fish farming. '
      'Survey plan and family receipt available. Negotiable.',
  price: '8,000,000',
  priceUnit: 'asking price',
  paymentTerms: 'Negotiable',
  address: 'Igwuruta Community',
  area: 'Igwuruta',
  lga: 'Ikwerre',
  state: 'Rivers',
  areaSqm: 20234.0,
  bedrooms: 0,
  bathrooms: 0,
  isVerified: false,
  isFeatured: false,
  agencyName: 'HomeFinders NG',
  tierLabel: 'Starter Agency',
  tierColor: VeriRentColors.tierStarterAgency,
  emoji: '🌾',
  rating: 3.9,
  reviewCount: 3,
  agentInitials: 'HF',
  location: 'Igwuruta, Ikwerre LGA',
  propertyType: 'Farm Land',
  imageUrls: [
    'https://images.unsplash.com/photo-1500076656116-558758f7f28c?w=600',
  ],
  amenities: ['Stream Access', 'Cleared Land', 'Road Access'],
  features: ['Fertile red soil', 'Suitable for poultry or crop farming'],
  utilities: {},
  nearbyFacilities: [],
  listedBy: UserType.individual,
  userId: 'user_ind01',
  verificationStatus: VerificationStatus.pending,
  documents: kDocumentsPending,
  createdAt: DateTime(2026, 5, 12),
  updatedAt: DateTime(2026, 5, 12),
  asLand: AsLand(
    landUse: 'Agricultural',
    dimensions: '~200m × ~100m',
    landCondition: 'Cleared',
    hasStreetFrontage: false,
    isAccessibleByRoad: true,
    surveyPlanNumber: 'Pending',
    landRegistryReference: 'Pending',
    documentType: 'Family Receipt',
    hasBoundaryDemarcation: false,
    hasElectricityPoles: false,
    hasWaterLine: false,
    hasDrainage: false,
    hasTarredRoad: false,
    zoningClassification: 'Agricultural',
    allowsCommercial: false,
  ),
);

// =============================================================================
//  COMMERCIAL / OFFICE LISTINGS
// =============================================================================

final PropertyModel kCommercial1 = PropertyModel(
  id: 'com_01',
  category: PropertyCategory.commercial,
  type: PropertyType.office,
  listingType: ListingType.rent,
  title: 'Open-Plan Office Space, 85 sqm — D-Line',
  description:
      'Modern open-plan office space on the ground floor of a commercial building in D/Line. '
      'Fitted with HVAC system, fibre-ready internet, reception area, and 4 dedicated parking spaces. '
      'Ideal for SMEs, tech startups, and professional services firms.',
  price: '2,200,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum or 2 installments',
  address: '45 Stadium Road',
  area: 'D-Line',
  lga: 'Port Harcourt',
  state: 'Rivers',
  areaSqm: 85.0,
  bedrooms: 0,
  bathrooms: 2,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Elite Property Solutions',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '🏢',
  rating: 4.6,
  reviewCount: 17,
  agentInitials: 'EP',
  location: 'D-Line, Port Harcourt',
  propertyType: 'Office',
  imageUrls: [
    'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600',
    'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=600',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600',
  ],
  amenities: [
    'HVAC System',
    'Fibre Internet',
    'Reception Area',
    '4 Parking Spaces',
    '24hr Power',
    'CCTV',
    'Fire Safety',
  ],
  features: [
    'Ground floor unit with signage rights',
    'Open-plan layout easily partitioned',
    '24-hour security access',
  ],
  utilities: {
    'Electricity': '24hr Power + Generator Backup',
    'Internet': '100Mbps Fibre',
    'Water': 'Overhead Tank',
  },
  nearbyFacilities: kNearbyFacilitiesDLine,
  listedBy: UserType.starter,
  userId: 'user_ag04',
  agencyId: 'ag_04',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyElite,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 4, 18),
  updatedAt: DateTime(2026, 5, 2),
  // OfficeProperty fields
  asOffice: AsOffice(
    officeType: 'Office',
    layoutType: 'Open Plan',
    floorLevel: 0,
    parkingSpaces: "4",
    hasHVAC: true,
    hasDisabledAccess: false,
    hasElevator: false,
    hasKitchen: true,
    hasConferenceRoom: false,
    hasReception: true,
    has24HourPower: true,
    hasGenerator: true,
    hasInternet: true,
    has24HourSecurity: true,
    hasCCTV: true,
    hasFireSafety: true,
    hasPestControl: true,
    minLeaseMonths: 12,
    hasRenewalOption: true,
    escalationPercentage: 10.0,
  ),
);

final PropertyModel kCommercial2 = PropertyModel(
  id: 'com_02',
  category: PropertyCategory.commercial,
  type: PropertyType.office,
  listingType: ListingType.rent,
  title: 'Partitioned Office Suite, 3rd Floor — Aba Road',
  description:
      'Well-fitted partitioned office suite with 6 offices, a boardroom, and a reception. '
      'Located on the 3rd floor of a premium office tower on Aba Road. '
      'Elevator access, HVAC, 24-hour power and security.',
  price: '5,500,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum',
  address: '120 Aba Road',
  area: 'Rumuola',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 200.0,
  bedrooms: 0,
  bathrooms: 3,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Apex Realty NG',
  tierLabel: 'Enterprise Agency',
  tierColor: VeriRentColors.tierEnterprise,
  emoji: '🏙️',
  rating: 4.8,
  reviewCount: 22,
  agentInitials: 'AR',
  location: 'Aba Road, Port Harcourt',
  propertyType: 'Office Suite',
  imageUrls: [
    'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=600',
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600',
  ],
  amenities: [
    'Elevator',
    'HVAC',
    'Boardroom',
    '24hr Power',
    'Generator',
    'Fibre Internet',
    'Security Guard',
    'CCTV',
  ],
  features: [
    '6 private offices + boardroom',
    'Reception area with waiting lounge',
    'Floor-to-ceiling windows with city view',
  ],
  utilities: {
    'Electricity': '24hr Power',
    'Internet': '200Mbps Fibre',
    'Water': 'Pressurized supply',
  },
  nearbyFacilities: kNearbyFacilitiesGRA,
  listedBy: UserType.starter,
  userId: 'user_ag02',
  agencyId: 'ag_02',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyApex,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 3, 5),
  updatedAt: DateTime(2026, 4, 20),
  asOffice: AsOffice(
    officeType: 'Office Suite',
    layoutType: 'Partitioned',
    floorLevel: 3,
    parkingSpaces: "6",
    hasHVAC: true,
    hasDisabledAccess: true,
    hasElevator: true,
    hasKitchen: true,
    hasConferenceRoom: true,
    hasReception: true,
    has24HourPower: true,
    hasGenerator: true,
    hasInternet: true,
    has24HourSecurity: true,
    hasCCTV: true,
    hasFireSafety: true,
    hasPestControl: true,
    minLeaseMonths: 12,
    hasRenewalOption: true,
    escalationPercentage: 8.0,
  ),
);

final PropertyModel kCommercial3 = PropertyModel(
  id: 'com_03',
  category: PropertyCategory.commercial,
  type: PropertyType.office,
  listingType: ListingType.rent,
  title: 'Shop Space, 40 sqm — Rumuola Road',
  description:
      'Ground floor shop space suitable for retail, pharmacy, or fast food. '
      'High foot traffic location on Rumuola Road. '
      'No elevator needed — direct street access.',
  price: '900,000',
  priceUnit: 'per year',
  paymentTerms: 'Lump sum',
  address: '33 Rumuola Road',
  area: 'Rumuola',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 40.0,
  bedrooms: 0,
  bathrooms: 1,
  isVerified: false,
  isFeatured: false,
  agencyName: 'HomeFinders NG',
  tierLabel: 'Starter Agency',
  tierColor: VeriRentColors.tierStarterAgency,
  emoji: '🛒',
  rating: 4.0,
  reviewCount: 5,
  agentInitials: 'HF',
  location: 'Rumuola Road, Port Harcourt',
  propertyType: 'Shop',
  imageUrls: [
    'https://images.unsplash.com/photo-1604719312566-8912e9c8a213?w=600',
  ],
  amenities: ['Street Access', 'Prepaid Meter', 'Security'],
  features: ['High foot traffic area', 'Open-plan retail space'],
  utilities: {'Electricity': 'Prepaid NEPA'},
  nearbyFacilities: [],
  listedBy: UserType.starter,
  userId: 'user_ag03',
  agencyId: 'ag_03',
  verificationStatus: VerificationStatus.pending,
  agency: kAgencyHomeFinders,
  documents: kDocumentsPending,
  createdAt: DateTime(2026, 5, 8),
  updatedAt: DateTime(2026, 5, 8),
  asOffice: AsOffice(
    officeType: 'Shop',
    layoutType: 'Open Plan',
    floorLevel: 0,
    parkingSpaces: "0",
    hasHVAC: false,
    hasDisabledAccess: true,
    hasElevator: false,
    hasKitchen: false,
    hasConferenceRoom: false,
    hasReception: false,
    has24HourPower: false,
    hasGenerator: false,
    hasInternet: false,
    has24HourSecurity: false,
    hasCCTV: false,
    hasFireSafety: false,
    hasPestControl: false,
    minLeaseMonths: 12,
    hasRenewalOption: false,
  ),
);

// =============================================================================
//  ESTATE LISTINGS
// =============================================================================

final PropertyModel kEstate1 = PropertyModel(
  id: 'est_01',
  category: PropertyCategory.estate,
  type: PropertyType.apartment,
  listingType: ListingType.sale,
  title: 'Greenview Estate — 3 Bed Terrace, Woji',
  description:
      'Greenview Estate is a gated community of 48 units in the fast-growing Woji area of Port Harcourt. '
      'The estate features CCTV surveillance, a swimming pool, gym, children\'s play area, and 24-hour security. '
      'Units are available as 2- and 3-bedroom terrace duplexes. Flexible payment plan for off-plan purchases.',
  price: '38,000,000',
  priceUnit: 'per unit',
  paymentTerms: '12-month installment plan available',
  address: 'Greenview Estate, Woji',
  area: 'Woji',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 180.0,
  bedrooms: 3,
  bathrooms: 3,
  toilets: 4,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Apex Realty NG',
  tierLabel: 'Enterprise Agency',
  tierColor: VeriRentColors.tierEnterprise,
  emoji: '🏘️',
  rating: 4.9,
  reviewCount: 63,
  agentInitials: 'AR',
  location: 'Woji, Obio-Akpor',
  propertyType: 'Terrace Duplex',
  imageUrls: [
    'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=600',
    'https://images.unsplash.com/photo-1613977257592-4871e5fcd7c4?w=600',
    'https://images.unsplash.com/photo-1600607687939-ce8a6d731f89?w=600',
  ],
  amenities: [
    'Gated Community',
    '24hr Security',
    'CCTV Surveillance',
    'Swimming Pool',
    'Gym',
    'Children\'s Play Area',
    'Generator House',
    'Borehole Water',
    'Visitor Parking',
    'Paved Roads Within Estate',
  ],
  features: [
    '48 units in total — 2-bed and 3-bed options',
    'Flexible off-plan payment plan available',
    'Each unit has 2 parking spaces',
    'C of O for the entire estate',
  ],
  utilities: {
    'Electricity': 'NEPA + Estate Generator',
    'Water': 'Estate Borehole + Overhead',
    'Internet': 'Fibre-ready',
  },
  nearbyFacilities: kNearbyFacilitiesTransAmadi,
  listedBy: UserType.starter,
  userId: 'user_ag02',
  agencyId: 'ag_02',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyApex,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 1, 10),
  updatedAt: DateTime(2026, 5, 1),
  unitCount: 48,
);

final PropertyModel kEstate2 = PropertyModel(
  id: 'est_02',
  category: PropertyCategory.estate,
  type: PropertyType.apartment,
  listingType: ListingType.sale,
  title: 'Sunrise Court Estate — 2 Bed Flat, Eliozu',
  description:
      'Sunrise Court is a boutique estate of 20 luxury apartments in Eliozu. '
      'Modern finishes, fitted kitchens, and estate-wide CCTV and access control. '
      'Ready for immediate occupation.',
  price: '22,000,000',
  priceUnit: 'per unit',
  paymentTerms: 'Outright or 6-month plan',
  address: 'Sunrise Court, Eliozu',
  area: 'Eliozu',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 120.0,
  bedrooms: 2,
  bathrooms: 2,
  toilets: 3,
  isVerified: true,
  isFeatured: false,
  agencyName: 'Greenfield Estates Ltd',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '🌅',
  rating: 4.7,
  reviewCount: 28,
  agentInitials: 'GE',
  location: 'Eliozu, Obio-Akpor',
  propertyType: 'Flat',
  imageUrls: [
    'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600',
    'https://images.unsplash.com/photo-1560185007-5f0bb1866cab?w=600',
  ],
  amenities: [
    'Gated',
    'Access Control',
    'CCTV',
    '24hr Security',
    'Borehole',
    'Fitted Kitchen',
    'Parking per Unit',
  ],
  features: [
    '20 luxury apartments',
    'Ready for immediate occupation',
    'Modern finishes throughout',
  ],
  utilities: {'Electricity': 'NEPA + Generator', 'Water': 'Borehole'},
  nearbyFacilities: [],
  listedBy: UserType.starter,
  userId: 'user_ag01',
  agencyId: 'ag_01',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyGreenfield,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 2, 14),
  updatedAt: DateTime(2026, 4, 30),
  unitCount: 20,
);

// =============================================================================
//  SHORTLET LISTINGS
// =============================================================================

final PropertyModel kShortlet1 = PropertyModel(
  id: 'sht_01',
  category: PropertyCategory.shortLet,
  type: PropertyType.apartment,
  listingType: ListingType.rent,
  title: 'Luxury 2-Bed Shortlet, Rumuola',
  description:
      'Tastefully furnished 2-bedroom shortlet apartment in Rumuola. '
      'Features a fully equipped kitchen, smart TV, high-speed WiFi, and AC in all rooms. '
      'Ideal for business travellers, expatriates, and weekend getaways. '
      'Daily, weekly, and monthly rates available.',
  price: '35,000',
  priceUnit: 'per night',
  paymentTerms: 'Minimum 1 night stay',
  address: '12 Agip Road',
  area: 'Rumuola',
  lga: 'Obio-Akpor',
  state: 'Rivers',
  areaSqm: 95.0,
  bedrooms: 2,
  bathrooms: 2,
  isVerified: true,
  isFeatured: true,
  agencyName: 'Elite Property Solutions',
  tierLabel: 'Professional Agency',
  tierColor: VeriRentColors.tierProfessional,
  emoji: '✨',
  rating: 4.9,
  reviewCount: 87,
  agentInitials: 'EP',
  location: 'Rumuola, Port Harcourt',
  propertyType: 'Shortlet Apartment',
  imageUrls: [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=600',
    'https://images.unsplash.com/photo-1556020685-ae41abfc9365?w=600',
  ],
  amenities: [
    'WiFi (100Mbps)',
    'AC in all rooms',
    'Smart TV',
    'Fully Equipped Kitchen',
    '24hr Security',
    'Parking',
    'Housekeeping',
    'Generator Backup',
  ],
  features: [
    'Self check-in with smart lock',
    'Netflix & streaming ready',
    'Weekly and monthly discounts available',
  ],
  utilities: {
    'Electricity': '24hr Power',
    'Internet': '100Mbps WiFi Included',
    'Water': 'Constant Supply',
  },
  nearbyFacilities: [],
  listedBy: UserType.starter,
  userId: 'user_ag04',
  agencyId: 'ag_04',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyElite,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 4, 25),
  updatedAt: DateTime(2026, 5, 20),

  // LeaseProperty fields
  asLease: AsLease(
    furnishingLevel: 'Fully Furnished',
    leaseTermMonths: '1 night minimum',
    hasFlexibleDates: true,
    depositAmount: 35000,
    hasWiFi: true,
    utilitiesIncluded: true,
    hasHousekeeping: true,
    hasParkingIncluded: true,
    hasACIncluded: true,
    hasKitchen: true,
    guestsAllowed: true,
    petsAllowed: false,
    smokingAllowed: false,
    quietHours: '11PM – 7AM',
    checkInTime: '2:00 PM',
    checkOutTime: '12:00 PM',
    idealTenantProfile: 'Business travellers, Expats, Couples',
    cancellationPolicy: 'Free cancellation up to 48 hours before check-in',
  ),
);

final PropertyModel kShortlet2 = PropertyModel(
  id: 'sht_02',
  category: PropertyCategory.shortLet,
  type: PropertyType.apartment,
  listingType: ListingType.rent,
  title: 'Cozy Studio Shortlet, GRA Phase 1',
  description:
      'Affordable and clean studio shortlet in GRA Phase 1. '
      'Perfect for solo travellers and short business trips. '
      'Self-contained with AC, WiFi, and kitchen essentials provided.',
  price: '18,000',
  priceUnit: 'per night',
  paymentTerms: 'Minimum 2 nights',
  address: '5 Forces Avenue',
  area: 'GRA Phase 1',
  lga: 'Port Harcourt',
  state: 'Rivers',
  areaSqm: 40.0,
  bedrooms: 1,
  bathrooms: 1,
  isVerified: true,
  isFeatured: false,
  agencyName: 'HomeFinders NG',
  tierLabel: 'Starter Agency',
  tierColor: VeriRentColors.tierStarterAgency,
  emoji: '🌙',
  rating: 4.5,
  reviewCount: 34,
  agentInitials: 'HF',
  location: 'GRA Phase 1, Port Harcourt',
  propertyType: 'Studio Shortlet',
  imageUrls: [
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600',
    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
  ],
  amenities: ['WiFi', 'AC', 'Smart TV', 'Kitchen Essentials', 'Parking'],
  features: ['Self check-in', 'Quiet neighbourhood'],
  utilities: {'Electricity': '24hr Power', 'Internet': 'WiFi Included'},
  nearbyFacilities: kNearbyFacilitiesGRA,
  listedBy: UserType.starter,
  userId: 'user_ag03',
  agencyId: 'ag_03',
  verificationStatus: VerificationStatus.verified,
  agency: kAgencyHomeFinders,
  documents: kDocumentsVerified,
  createdAt: DateTime(2026, 5, 1),
  updatedAt: DateTime(2026, 5, 15),
  asLease: AsLease(
    furnishingLevel: 'Fully Furnished',
    leaseTermMonths: '2 nights minimum',
    hasFlexibleDates: true,
    depositAmount: 18000,
    hasWiFi: true,
    utilitiesIncluded: true,
    hasHousekeeping: false,
    hasParkingIncluded: true,
    hasACIncluded: true,
    hasKitchen: true,
    guestsAllowed: false,
    petsAllowed: false,
    smokingAllowed: false,
    checkInTime: '3:00 PM',
    checkOutTime: '11:00 AM',
    idealTenantProfile: 'Solo travellers, Business trips',
    cancellationPolicy: 'Non-refundable',
  ),
);

// =============================================================================
//  CONSOLIDATED LISTS  (plug directly into widgets)
// =============================================================================
/// Chat Threads
final List<ChatThread> kChatThreads = mockThreads();

/// Featured horizontal scroll — mixed categories, all verified.
final List<PropertyModel> kFeatured = [
  kResidential1,
  kEstate1,
  kCommercial1,
  kLand1,
  kShortlet1,
  kResidential4,
];

/// Recently added — variety of verification status and types.
final List<PropertyModel> kRecent = [
  kResidential3,
  kLand3,
  kCommercial3,
  kShortlet2,
  kResidential2,
  kEstate2,
];

/// Available listings — vertical / masonry grid.
final List<PropertyModel> kAvailable = [
  kResidential1,
  kLand1,
  kCommercial1,
  kEstate1,
  kShortlet1,
  kResidential2,
  kLand2,
  kCommercial2,
  kEstate2,
  kShortlet2,
  kResidential3,
  kResidential4,
  kLand3,
  kCommercial3,
];

/// Land only.
final List<PropertyModel> kLandListings = [kLand1, kLand2, kLand3];

/// Commercial only.
final List<PropertyModel> kCommercialListings = [
  kCommercial1,
  kCommercial2,
  kCommercial3,
];

/// Estates only.
final List<PropertyModel> kEstateListings = [kEstate1, kEstate2];

/// Shortlets only.
final List<PropertyModel> kShortletListings = [kShortlet1, kShortlet2];

/// Residential only
final List<PropertyModel> kResidentialListings = [
  kResidential1,
  kResidential2,
  kResidential3,
  kResidential4,
];

/// Saved listings (mirrors what SavedCubit mock returns).
final List<PropertyModel> kSaved = [
  kResidential1,
  kEstate1,
  kShortlet1,
  kCommercial1,
];

/// All listings flat — useful for search and filter screens.
final List<PropertyModel> kAllListings = [
  ...kFeatured,
  kLand2,
  kLand3,
  kCommercial2,
  kCommercial3,
  kEstate2,
  kShortlet2,
  kResidential3,
  kResidential4,
];
