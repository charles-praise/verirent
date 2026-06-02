import 'package:verirent/core/api/data/mock_data.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

/// Featured horizontal scroll — mixed categories, all verified.
List<PropertyModel> get featuredProperties => kFeatured;

/// Available listings — vertical / masonry grid.
List<PropertyModel> get recentProperties => kRecent;

/// Land only.
List<PropertyModel> get landedProperties => kLandListings;

/// Commercial only.
List<PropertyModel> get commercialProperties => kCommercialListings;

/// Estates only.
List<PropertyModel> get estateProperties => kEstateListings;

/// Shortlets only.
List<PropertyModel> get shortletProperties => kShortletListings;

/// All listings flat — useful for search and filter screens.
List<PropertyModel> get allListedProperties => kAllListings;
