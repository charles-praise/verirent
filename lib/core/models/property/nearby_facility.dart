/// A single point of interest near a property (school, hospital, market,
/// bank, etc.) with its distance.
class NearbyFacility {
  const NearbyFacility({
    required this.name,
    required this.type,
    required this.distance,
  });

  final String name;
  final String type;
  final String distance;

  factory NearbyFacility.fromJson(Map<String, dynamic> json) {
    return NearbyFacility(
      name: json['name'] as String,
      type: json['type'] as String,
      distance: json['distance'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'distance': distance,
  };
}
