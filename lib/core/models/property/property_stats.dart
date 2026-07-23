import 'property_type.dart';

/// Aggregate/marketplace metadata about a property — how it's ranked and
/// discovered, not what it physically is. Replaces the scattered
/// category/isFeatured/isRecent/rating/reviewCount/areaSqm fields that
/// used to sit directly on PropertyModel.
class PropertyStatistics {
  const PropertyStatistics({
    this.category = PropertyCategory.none,
    this.rating = 0,
    this.reviewCount = 0,
    this.areaSqm = 0,
    this.isFeatured = false,
    this.isRecent = false,
    this.showInOptions = false,
  });

  final PropertyCategory category;
  final double rating;
  final int reviewCount; // was a double in the original — review counts are integers
  final double areaSqm;
  final bool isFeatured;
  final bool isRecent;
  final bool showInOptions;

  factory PropertyStatistics.fromJson(Map<String, dynamic> json) {
    return PropertyStatistics(
      category: json['category'] != null
          ? PropertyCategory.values[json['category'] as int]
          : PropertyCategory.none,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      areaSqm: (json['areaSqm'] as num?)?.toDouble() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isRecent: json['isRecent'] as bool? ?? false,
      showInOptions: json['showInOptions'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category.index,
    'rating': rating,
    'reviewCount': reviewCount,
    'areaSqm': areaSqm,
    'isFeatured': isFeatured,
    'isRecent': isRecent,
    'showInOptions': showInOptions,
  };
}
