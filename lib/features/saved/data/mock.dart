// ── Mock data ──────────────────────────────────────────────────────────────
import '../../../core/theme/agents_theme.dart';
import '../../home/domain/entities/property_model.dart';

List<PropertyModel> mockSavedListings() => [
  PropertyModel(
    id: 's1',
    title: '3 Bedroom Flat, GRA Phase 2',
    location: 'GRA Phase 2, Port Harcourt',
    price: '1,800,000',
    bedrooms: 3,
    bathrooms: 2,
    areaSqm: "120",
    isVerified: true,
    agencyName: 'Greenfield Estates',
    tierLabel: 'Professional Agency',
    tierColor: VeriRentColors.tierProfessional,
    emoji: '🏠',
    imageUrls: ['https://source.unsplash.com/400x300/?apartment,interior'],
    listingType: 'rent',
    rating: 4.8,
    reviewCount: 24,
    agentInitials: 'GE',
    lga: '',
    state: '',
    area: '',
    priceUnit: '',
    paymentTerms: '',
    toilets: null,
    address: '',
    condition: '',
    isFeatured: false,
    description: '',
    amenities: [],
    features: [],
    utilities: {},
    nearbyFacilities: [],
  ),
];
