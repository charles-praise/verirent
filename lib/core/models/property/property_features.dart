/// Bundles the three "what does this place have" lists that used to be
/// three separate flat fields on PropertyModel. Kept as one small
/// composed object since they're always read/written together in the UI
/// (an amenities/features chip section on the listing detail screen).
class PropertyFeatures {
  const PropertyFeatures({this.amenities, this.features, this.utilities});

  final List<String>? amenities;
  final List<String>? features;
  final Map<String, String>? utilities;

  factory PropertyFeatures.fromJson(Map<String, dynamic> json) {
    return PropertyFeatures(
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      utilities: (json['utilities'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)),
    );
  }

  Map<String, dynamic> toJson() => {
    'amenities': amenities,
    'features': features,
    'utilities': utilities,
  };
}
