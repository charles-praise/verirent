import '../../address/address_model.dart';
import 'nearby_facility.dart';

/// Everything about WHERE a property is: its structured Nigerian address,
/// an optional free-text display string, map coordinates, and what's
/// nearby. Replaces the flat lga/state/area/address/location fields that
/// used to sit directly on PropertyModel.
class PropertyLocation {
  const PropertyLocation({
    this.addressDetails,
    this.displayLocation,
    this.latitude,
    this.longitude,
    this.nearbyFacilities,
  });

  final AddressModel? addressDetails;
  final String? displayLocation; // e.g. "GRA Phase 2, Port Harcourt"
  final double? latitude;
  final double? longitude;
  final List<NearbyFacility>? nearbyFacilities;

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      addressDetails: json['addressDetails'] != null
          ? AddressModel.fromJson(json['addressDetails'] as Map<String, dynamic>)
          : null,
      displayLocation: json['displayLocation'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      nearbyFacilities: (json['nearbyFacilities'] as List<dynamic>?)
          ?.map((e) => NearbyFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'addressDetails': addressDetails?.toJson(),
    'displayLocation': displayLocation,
    'latitude': latitude,
    'longitude': longitude,
    'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
  };
}
