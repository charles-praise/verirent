class PropertyLocation {
  final String address;

  final String state;

  final String lga;

  final String? area;

  final LatLng? coordinate;

  PropertyLocation({
    required this.address,
    required this.state,
    required this.lga,
    this.coordinate,
    this.area,
  });
}

class LatLng {
  final String latitude;
  final String longitude;

  LatLng({required this.latitude, required this.longitude});
}
