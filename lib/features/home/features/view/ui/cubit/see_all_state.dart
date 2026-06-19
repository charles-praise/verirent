part of 'see_all_cubit.dart';

enum SeeAllStage { initial, loading, loaded, error }

class SeeAllState extends Equatable {
  final List<PropertyModel> allProperties;
  final List<IconData> filterIcons;
  final List<String> filters;
  final String query;
  final int activeIndex;
  final SeeAllStage seeAllStage;
  final List<PropertyModel> filteredProperties;

  final bool filtersExpanded;

  final RangeValues priceRange;
  final int minBeds;
  final int minBaths;
  final String selectedType;
  final bool verifiedOnly;
  final PropertyCategory selectedCategory;

  final List<String> recentSearches;
  final List<String> propertyTypes;

  const SeeAllState({
    this.filteredProperties = const [],
    this.seeAllStage = SeeAllStage.initial,
    this.query = '',
    this.filtersExpanded = false,
    this.priceRange = const RangeValues(100000, 2000000),
    this.minBeds = 0,
    this.minBaths = 0,
    this.selectedType = 'Any',
    this.verifiedOnly = false,
    this.selectedCategory = PropertyCategory.initial,
    this.allProperties = const [],
    this.activeIndex = 0,
    this.filterIcons = const [
      Icons.star_rounded,
      Icons.house_rounded,
      Icons.apartment_rounded,
      Icons.chair_rounded,
      Icons.business_center_rounded,
    ],
    this.filters = const [
      'All',
      'Apartment',
      'Duplex',
      'Furnished',
      'Corporate',
    ],
    this.recentSearches = const [
      'GRA Phase 2 apartments',
      'Trans Amadi furnished flat',
      'Woji 3 bedroom duplex',
      'D/Line self contain',
    ],
    this.propertyTypes = const [
      'Any',
      'Apartment',
      'Duplex',
      'Flat',
      'Bungalow',
      'Furnished',
      'Corporate',
    ],
  });

  SeeAllState copyWith({
    List<PropertyModel>? allProperties,
    String? query,
    int? activeIndex,
    RangeValues? priceRange,
    int? minBeds,
    int? minBaths,
    String? selectedType,
    bool? verifiedOnly,
    PropertyCategory? selectedCategory,
    List<String>? recentSearches,
    List<String>? propertyTypes,
    SeeAllStage? seeAllStage,
    List<PropertyModel>? filteredProperties,
  }) {
    return SeeAllState(
      allProperties: allProperties ?? this.allProperties,
      query: query ?? this.query,
      activeIndex: activeIndex ?? this.activeIndex,
      priceRange: priceRange ?? this.priceRange,
      minBeds: minBeds ?? this.minBeds,
      minBaths: minBaths ?? this.minBaths,
      selectedType: selectedType ?? this.selectedType,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      recentSearches: recentSearches ?? this.recentSearches,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      seeAllStage: seeAllStage ?? this.seeAllStage,
      filteredProperties: filteredProperties ?? this.filteredProperties,
    );
  }

  @override
  List<Object?> get props => [
        allProperties,
        query,
        activeIndex,
        priceRange,
        minBeds,
        minBaths,
        selectedType,
        verifiedOnly,
        selectedCategory,
        recentSearches,
        propertyTypes,
        seeAllStage,
      ];
}
