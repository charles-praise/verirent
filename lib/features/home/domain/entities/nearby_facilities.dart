class NearbyFacility {
  final String name;
  final String type; // School, Hospital, Market, Bank, etc.
  final String distance;

  // In nearby_facilities.dart
  factory NearbyFacility.fromJson(Map<String, dynamic> json) {
    return NearbyFacility(
      name: json['name'] as String,
      type: json['type'] as String,
      distance: (json['distance'] as num?).toString(),
      // add your actual fields here
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'distance': distance,
    // mirror your actual fields
  };

  NearbyFacility({
    required this.name,
    required this.type,
    required this.distance,
  });
}
