import 'package:flutter/material.dart';

// ---------------------------
enum PropertyCategory {
  none,
  all,
  featured,
  recent,
  residential,
  estate,
  land,
  commercial,
  shortLet,
  option,
}

// -------------------
enum PropertyType { apartment, duplex, land, house, office }

// ---------------------
enum ListingType { rent, sale }

// -----------------------
enum UserType { starter, individual }

// ---------------------
enum VerificationStatus { verified, pending }

//  ------------------
enum PropertyCondition { good, new_property, renovated }

//------------------------------
enum VerificationTier { professional, enterprise, starter, pro, basic }

// ----------------------------------------------
enum OverallStatus { verified, unverified, pending }

// ---------------- Document Model ------------------
class DocumentModel {
  DocumentModel({
    this.overallStatus,
    this.buildingApproval,
    this.landRegistry,
    this.surveyPlan,
    this.titleDeed,
  });

  final OverallStatus? overallStatus;
  final bool? titleDeed;
  final bool? landRegistry;
  final bool? buildingApproval;
  final bool? surveyPlan;

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      overallStatus: json['overallStatus'] != null
          ? OverallStatus.values[json['overallStatus'] as int]
          : null,
      titleDeed: json['titleDeed'] as bool?,
      landRegistry: json['landRegistry'] as bool?,
      buildingApproval: json['buildingApproval'] as bool?,
      surveyPlan: json['surveyPlan'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'overallStatus': overallStatus?.index,
    'titleDeed': titleDeed,
    'landRegistry': landRegistry,
    'buildingApproval': buildingApproval,
    'surveyPlan': surveyPlan,
  };
}

// --------- Agency Model ------------------------
class AgencyModel extends PropertyModel {
  AgencyModel({
    required super.id,
    this.name,
    this.verificationTier,
    super.rating,
    this.transactions,
    this.esvarbon,
    this.phone,
    this.email,
    super.address,
    super.title,
  });

  final String? name;
  final VerificationTier? verificationTier;
  final int? transactions;
  final String? esvarbon;
  final String? phone;
  final String? email;

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      verificationTier: json['verificationTier'] != null
          ? VerificationTier.values[json['verificationTier'] as int]
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      transactions: json['transactions'] as int?,
      esvarbon: json['esvarbon'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      title: json['title'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'verificationTier': verificationTier?.index,
    'rating': rating,
    'transactions': transactions,
    'esvarbon': esvarbon,
    'phone': phone,
    'email': email,
    'address': address,
    'title': title,
  };
}

// ----------------- Nearby Facilities ------------
class NearbyFacility {
  final String name;
  final String type; // School, Hospital, Market, Bank, etc.
  final String distance;

  // In nearby_facilities.dart
  factory NearbyFacility.fromJson(Map<String, dynamic> json) {
    return NearbyFacility(
      name: json['name'] as String,
      type: json['type'] as String,
      distance: json['distance'] as String,
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

// ----------------- LEASE -----------------------
class AsLease extends AsOffice {
  AsLease({
    this.furnishingLevel,
    this.leaseTermMonths,
    this.hasFlexibleDates,
    this.depositAmount,
    this.hasWiFi,
    this.utilitiesIncluded,
    this.hasHousekeeping,
    this.hasParkingIncluded,
    this.hasACIncluded,
    this.hasKitchen,
    this.cancellationPolicy,
    this.guestsAllowed,
    this.petsAllowed,
    this.smokingAllowed,
    this.quietHours,
    this.checkInTime,
    this.checkOutTime,
    this.idealTenantProfile,
  });

  final String? furnishingLevel;
  final String? leaseTermMonths;
  final bool? hasFlexibleDates;
  final double? depositAmount;
  final bool? hasWiFi;
  final bool? utilitiesIncluded;
  final bool? hasHousekeeping;
  final bool? hasParkingIncluded;
  final bool? hasACIncluded;
  @override
  final bool? hasKitchen;
  final bool? guestsAllowed;
  final bool? petsAllowed;
  final bool? smokingAllowed;
  final String? quietHours;
  final String? checkInTime;
  final String? checkOutTime;
  final String? idealTenantProfile;
  final String? cancellationPolicy;

  factory AsLease.fromJson(Map<String, dynamic> json) {
    return AsLease(
      furnishingLevel: json['furnishingLevel'] as String?,
      leaseTermMonths: json['leaseTermMonths'] as String?,
      hasFlexibleDates: json['hasFlexibleDates'] as bool?,
      depositAmount: (json['depositAmount'] as num?)?.toDouble(),
      hasWiFi: json['hasWiFi'] as bool?,
      utilitiesIncluded: json['utilitiesIncluded'] as bool?,
      hasHousekeeping: json['hasHousekeeping'] as bool?,
      hasParkingIncluded: json['hasParkingIncluded'] as bool?,
      hasACIncluded: json['hasACIncluded'] as bool?,
      hasKitchen: json['hasKitchen'] as bool?,
      guestsAllowed: json['guestsAllowed'] as bool?,
      petsAllowed: json['petsAllowed'] as bool?,
      smokingAllowed: json['smokingAllowed'] as bool?,
      quietHours: json['quietHours'] as String?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      idealTenantProfile: json['idealTenantProfile'] as String?,
      cancellationPolicy: json['cancellationPolicy'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'furnishingLevel': furnishingLevel,
    'leaseTermMonths': leaseTermMonths,
    'hasFlexibleDates': hasFlexibleDates,
    'depositAmount': depositAmount,
    'hasWiFi': hasWiFi,
    'utilitiesIncluded': utilitiesIncluded,
    'hasHousekeeping': hasHousekeeping,
    'hasParkingIncluded': hasParkingIncluded,
    'hasACIncluded': hasACIncluded,
    'hasKitchen': hasKitchen,
    'guestsAllowed': guestsAllowed,
    'petsAllowed': petsAllowed,
    'smokingAllowed': smokingAllowed,
    'quietHours': quietHours,
    'checkInTime': checkInTime,
    'checkOutTime': checkOutTime,
    'idealTenantProfile': idealTenantProfile,
    'cancellationPolicy': cancellationPolicy,
  };
}

//  ---------------- OFFICE ------------------------
// A typed sub class accessor of (propertyModel) for offices and spaces
class AsOffice extends AsResidential {
  AsOffice({
    super.id,
    super.lga,
    super.state,
    super.area,
    super.priceUnit,
    super.paymentTerms,
    super.toilets,
    super.listingType,
    super.title,
    super.location,
    super.price,
    super.bedrooms,
    super.bathrooms,
    super.agencyName,
    super.tierLabel,
    super.tierColor,
    super.isVerified,
    super.emoji,
    super.address,
    super.condition,
    super.isFeatured,
    super.mediaUrls,
    super.description,
    super.amenities,
    super.features,
    super.utilities,
    super.nearbyFacilities,
    // ------------------------
    this.hasHVAC,
    this.hasElevator,
    this.hasDisabledAccess,
    this.hasKitchen,
    this.hasConferenceRoom,
    this.hasInternet,
    this.has24HourPower,
    this.hasCCTV,
    this.minLeaseMonths,
    this.hasRenewalOption,
    this.escalationPercentage,
    this.officeType,
    this.layoutType,
    this.floorLevel,
    this.parkingSpaces,
    this.hasReception,
    this.hasGenerator,
    this.has24HourSecurity,
    this.hasFireSafety,
    this.hasPestControl,
  });

  final bool? hasHVAC;
  final bool? hasElevator;
  final bool? hasDisabledAccess;
  final bool? hasKitchen;
  final bool? hasConferenceRoom;
  final bool? hasInternet;
  final bool? has24HourSecurity;
  final bool? has24HourPower;
  final bool? hasReception;
  final bool? hasFireSafety;
  final bool? hasPestControl;
  final bool? hasGenerator;
  @override
  final String? parkingSpaces;
  final String? officeType;
  @override
  final String? layoutType;
  @override
  final int? floorLevel;
  @override
  final bool? hasCCTV;
  final int? minLeaseMonths;
  final bool? hasRenewalOption;
  final double? escalationPercentage;

  factory AsOffice.fromJson(Map<String, dynamic> json) {
    return AsOffice(
      id: json['id'] as String?,
      lga: json['lga'] as String?,
      state: json['state'] as String?,
      area: json['area'] as String?,
      priceUnit: json['priceUnit'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      toilets: json['toilets'] as int?,
      listingType: json['listingType'] != null
          ? ListingType.values[json['listingType'] as int]
          : null,
      title: json['title'] as String?,
      location: json['location'] as String?,
      price: json['price'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      agencyName: json['agencyName'] as String?,
      tierLabel: json['tierLabel'] as String?,
      tierColor: json['tierColor'] != null
          ? Color(json['tierColor'] as int)
          : null,
      isVerified: json['isVerified'] as bool?,
      emoji: json['emoji'] as String?,
      address: json['address'] as String?,
      condition: json['condition'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      mediaUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      utilities: (json['utilities'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      nearbyFacilities: (json['nearbyFacilities'] as List<dynamic>?)
          ?.map((e) => NearbyFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasHVAC: json['hasHVAC'] as bool?,
      hasElevator: json['hasElevator'] as bool?,
      hasDisabledAccess: json['hasDisabledAccess'] as bool?,
      hasKitchen: json['hasKitchen'] as bool?,
      hasConferenceRoom: json['hasConferenceRoom'] as bool?,
      hasInternet: json['hasInternet'] as bool?,
      has24HourPower: json['has24HourPower'] as bool?,
      hasCCTV: json['hasCCTV'] as bool?,
      minLeaseMonths: json['minLeaseMonths'] as int?,
      hasRenewalOption: json['hasRenewalOption'] as bool?,
      escalationPercentage: (json['escalationPercentage'] as num?)?.toDouble(),
      officeType: json['officeType'] as String?,
      layoutType: json['layoutType'] as String?,
      floorLevel: json['floorLevel'] as int?,
      parkingSpaces: json['parkingSpaces'] as String?,
      hasReception: json['hasReception'] as bool?,
      hasGenerator: json['hasGenerator'] as bool?,
      has24HourSecurity: json['has24HourSecurity'] as bool?,
      hasFireSafety: json['hasFireSafety'] as bool?,
      hasPestControl: json['hasPestControl'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'lga': lga,
    'state': state,
    'area': area,
    'priceUnit': priceUnit,
    'paymentTerms': paymentTerms,
    'toilets': toilets,
    'listingType': listingType?.index,
    'title': title,
    'location': location,
    'price': price,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'agencyName': agencyName,
    'tierLabel': tierLabel,
    'tierColor': tierColor?.value,
    'isVerified': isVerified,
    'emoji': emoji,
    'address': address,
    'condition': condition,
    'isFeatured': isFeatured,
    'imageUrls': mediaUrls,
    'description': description,
    'amenities': amenities,
    'features': features,
    'utilities': utilities,
    'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
    'hasHVAC': hasHVAC,
    'hasElevator': hasElevator,
    'hasDisabledAccess': hasDisabledAccess,
    'hasKitchen': hasKitchen,
    'hasConferenceRoom': hasConferenceRoom,
    'hasInternet': hasInternet,
    'has24HourPower': has24HourPower,
    'hasCCTV': hasCCTV,
    'minLeaseMonths': minLeaseMonths,
    'hasRenewalOption': hasRenewalOption,
    'escalationPercentage': escalationPercentage,
    'officeType': officeType,
    'layoutType': layoutType,
    'floorLevel': floorLevel,
    'parkingSpaces': parkingSpaces,
    'hasReception': hasReception,
    'hasGenerator': hasGenerator,
    'has24HourSecurity': has24HourSecurity,
    'hasFireSafety': hasFireSafety,
    'hasPestControl': hasPestControl,
  };
}

// ---------------- RESIDENTIAL ------------------
// A typed sub class accessor of (propertyModel) for residential
class AsResidential extends AsLand {
  AsResidential({
    super.id,
    super.lga,
    super.state,
    super.area,
    super.priceUnit,
    super.paymentTerms,
    super.toilets,
    super.listingType,
    super.title,
    super.location,
    super.price,
    super.bedrooms,
    super.bathrooms,
    super.agencyName,
    super.tierLabel,
    super.tierColor,
    super.isVerified,
    super.emoji,
    super.address,
    super.condition,
    super.isFeatured,
    super.mediaUrls,
    super.description,
    super.amenities,
    super.features,
    super.utilities,
    super.nearbyFacilities,
    this.furnishing,
    this.residentialCondition,
    this.waterSupply,
    this.powerSupply,
    this.hasAC,
    this.hasParking,
    this.hasGarden,
    this.isFenced,
    this.hasSecurityGuard,
    this.hasCCTV,
    this.hasAlarmSystem,
    this.yearBuilt,
    this.hasTitleDocument,
    this.hasBuildingApproval,
  });

  final String? furnishing;
  final PropertyCondition? residentialCondition;
  final String? waterSupply;
  final String? powerSupply;
  final bool? hasAC;
  final bool? hasParking;
  final bool? hasGarden;
  final bool? isFenced;
  final bool? hasSecurityGuard;
  final bool? hasCCTV;
  final bool? hasAlarmSystem;
  final double? yearBuilt;
  final bool? hasTitleDocument;
  final bool? hasBuildingApproval;

  factory AsResidential.fromJson(Map<String, dynamic> json) {
    return AsResidential(
      id: json['id'] as String?,
      lga: json['lga'] as String?,
      state: json['state'] as String?,
      area: json['area'] as String?,
      priceUnit: json['priceUnit'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      toilets: json['toilets'] as int?,
      listingType: json['listingType'] != null
          ? ListingType.values[json['listingType'] as int]
          : null,
      title: json['title'] as String?,
      location: json['location'] as String?,
      price: json['price'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      agencyName: json['agencyName'] as String?,
      tierLabel: json['tierLabel'] as String?,
      tierColor: json['tierColor'] != null
          ? Color(json['tierColor'] as int)
          : null,
      isVerified: json['isVerified'] as bool?,
      emoji: json['emoji'] as String?,
      address: json['address'] as String?,
      condition: json['condition'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      mediaUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      utilities: (json['utilities'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      nearbyFacilities: (json['nearbyFacilities'] as List<dynamic>?)
          ?.map((e) => NearbyFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
      furnishing: json['furnishing'] as String?,
      residentialCondition: json['residentialCondition'] != null
          ? PropertyCondition.values[json['residentialCondition'] as int]
          : null,
      waterSupply: json['waterSupply'] as String?,
      powerSupply: json['powerSupply'] as String?,
      hasAC: json['hasAC'] as bool?,
      hasParking: json['hasParking'] as bool?,
      hasGarden: json['hasGarden'] as bool?,
      isFenced: json['isFenced'] as bool?,
      hasSecurityGuard: json['hasSecurityGuard'] as bool?,
      hasCCTV: json['hasCCTV'] as bool?,
      hasAlarmSystem: json['hasAlarmSystem'] as bool?,
      yearBuilt: (json['yearBuilt'] as num?)?.toDouble(),
      hasTitleDocument: json['hasTitleDocument'] as bool?,
      hasBuildingApproval: json['hasBuildingApproval'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'lga': lga,
    'state': state,
    'area': area,
    'priceUnit': priceUnit,
    'paymentTerms': paymentTerms,
    'toilets': toilets,
    'listingType': listingType?.index,
    'title': title,
    'location': location,
    'price': price,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'agencyName': agencyName,
    'tierLabel': tierLabel,
    'tierColor': tierColor?.value,
    'isVerified': isVerified,
    'emoji': emoji,
    'address': address,
    'condition': condition,
    'isFeatured': isFeatured,
    'imageUrls': mediaUrls,
    'description': description,
    'amenities': amenities,
    'features': features,
    'utilities': utilities,
    'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
    'furnishing': furnishing,
    'residentialCondition': residentialCondition?.index,
    'waterSupply': waterSupply,
    'powerSupply': powerSupply,
    'hasAC': hasAC,
    'hasParking': hasParking,
    'hasGarden': hasGarden,
    'isFenced': isFenced,
    'hasSecurityGuard': hasSecurityGuard,
    'hasCCTV': hasCCTV,
    'hasAlarmSystem': hasAlarmSystem,
    'yearBuilt': yearBuilt,
    'hasTitleDocument': hasTitleDocument,
    'hasBuildingApproval': hasBuildingApproval,
  };
}

// ------------------- LAND --------------------------
// a typed sub class accessor of the (propertyModel) for land
class AsLand extends PropertyModel {
  AsLand({
    super.id,
    super.lga,
    super.state,
    super.area,
    super.priceUnit,
    super.paymentTerms,
    super.toilets,
    super.listingType,
    super.title,
    super.location,
    super.price,
    super.bedrooms,
    super.bathrooms,
    super.agencyName,
    super.tierLabel,
    super.tierColor,
    super.isVerified,
    super.emoji,
    super.address,
    super.condition,
    super.isFeatured,
    super.mediaUrls,
    super.description,
    super.amenities,
    super.features,
    super.utilities,
    super.nearbyFacilities,
    //-----------------
    this.dimensions,
    this.landUse,
    this.surveyPlanNumber,
    this.landRegistryReference,
    this.hasElectricityPoles,
    this.hasWaterLine,
    this.hasDrainage,
    this.hasTarredRoad,
    this.isAccessibleByRoad,
    this.zoningClassification,
    this.maxBuildingHeight,
    this.allowsCommercial,
    this.landCondition,
    this.hasStreetFrontage,
    this.streetFrontageMeters,
    this.documentType,
    this.hasBoundaryDemarcation,
  });
  @override
  final String? dimensions;
  final String? landCondition;
  final bool? hasStreetFrontage;
  final int? streetFrontageMeters;
  final bool? hasBoundaryDemarcation;
  @override
  final String? documentType;
  final String? landUse;
  final String? surveyPlanNumber;
  final String? landRegistryReference;
  final bool? hasElectricityPoles;
  final bool? hasWaterLine;
  final bool? hasDrainage;
  final bool? hasTarredRoad;
  final bool? isAccessibleByRoad;
  final String? zoningClassification;
  final double? maxBuildingHeight;
  final bool? allowsCommercial;

  factory AsLand.fromJson(Map<String, dynamic> json) {
    return AsLand(
      id: json['id'] as String?,
      lga: json['lga'] as String?,
      state: json['state'] as String?,
      area: json['area'] as String?,
      priceUnit: json['priceUnit'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      toilets: json['toilets'] as int?,
      listingType: json['listingType'] != null
          ? ListingType.values[json['listingType'] as int]
          : null,
      title: json['title'] as String?,
      location: json['location'] as String?,
      price: json['price'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      agencyName: json['agencyName'] as String?,
      tierLabel: json['tierLabel'] as String?,
      tierColor: json['tierColor'] != null
          ? Color(json['tierColor'] as int)
          : null,
      isVerified: json['isVerified'] as bool?,
      emoji: json['emoji'] as String?,
      address: json['address'] as String?,
      condition: json['condition'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      mediaUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      utilities: (json['utilities'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      nearbyFacilities: (json['nearbyFacilities'] as List<dynamic>?)
          ?.map((e) => NearbyFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
      dimensions: json['dimensions'] as String?,
      landUse: json['landUse'] as String?,
      surveyPlanNumber: json['surveyPlanNumber'] as String?,
      landRegistryReference: json['landRegistryReference'] as String?,
      hasElectricityPoles: json['hasElectricityPoles'] as bool?,
      hasWaterLine: json['hasWaterLine'] as bool?,
      hasDrainage: json['hasDrainage'] as bool?,
      hasTarredRoad: json['hasTarredRoad'] as bool?,
      isAccessibleByRoad: json['isAccessibleByRoad'] as bool?,
      zoningClassification: json['zoningClassification'] as String?,
      maxBuildingHeight: (json['maxBuildingHeight'] as num?)?.toDouble(),
      allowsCommercial: json['allowsCommercial'] as bool?,
      landCondition: json['landCondition'] as String?,
      hasStreetFrontage: json['hasStreetFrontage'] as bool?,
      streetFrontageMeters: json['streetFrontageMeters'] as int?,
      documentType: json['documentType'] as String?,
      hasBoundaryDemarcation: json['hasBoundaryDemarcation'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'lga': lga,
    'state': state,
    'area': area,
    'priceUnit': priceUnit,
    'paymentTerms': paymentTerms,
    'toilets': toilets,
    'listingType': listingType?.index,
    'title': title,
    'location': location,
    'price': price,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'agencyName': agencyName,
    'tierLabel': tierLabel,
    'tierColor': tierColor?.value,
    'isVerified': isVerified,
    'emoji': emoji,
    'address': address,
    'condition': condition,
    'isFeatured': isFeatured,
    'imageUrls': mediaUrls,
    'description': description,
    'amenities': amenities,
    'features': features,
    'utilities': utilities,
    'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
    'dimensions': dimensions,
    'landUse': landUse,
    'surveyPlanNumber': surveyPlanNumber,
    'landRegistryReference': landRegistryReference,
    'hasElectricityPoles': hasElectricityPoles,
    'hasWaterLine': hasWaterLine,
    'hasDrainage': hasDrainage,
    'hasTarredRoad': hasTarredRoad,
    'isAccessibleByRoad': isAccessibleByRoad,
    'zoningClassification': zoningClassification,
    'maxBuildingHeight': maxBuildingHeight,
    'allowsCommercial': allowsCommercial,
    'landCondition': landCondition,
    'hasStreetFrontage': hasStreetFrontage,
    'streetFrontageMeters': streetFrontageMeters,
    'documentType': documentType,
    'hasBoundaryDemarcation': hasBoundaryDemarcation,
  };
}

// ------------ PROPERTY MODEL (BASE CLASS) -------------------
class PropertyModel {
  const PropertyModel({
    // -------------------
    this.key,
    this.id,
    this.category = PropertyCategory.none,
    this.reviewCount = 0,
    this.areaSqm = 2,
    this.propertyType = "House",
    // -------------------
    this.userId,
    this.verificationStatus,
    this.agencyId,
    this.listedBy,
    this.type,
    this.listingType,
    this.documentType,
    this.dimensions,
    this.floorLevel,
    this.layoutType,
    this.parkingSpaces,
    this.unitCount,
    this.agency,
    this.documents,
    this.createdAt,
    this.updatedAt,
    // --------------------
    this.asResidential,
    // -------------------
    this.asLand,
    // ------------------
    this.asOffice,
    // -------------------
    this.asLease,
    // -------------------
    this.lga,
    this.state,
    this.area,
    this.priceUnit,
    this.paymentTerms,
    this.toilets,
    this.title,
    this.location,
    this.price,
    this.bedrooms,
    this.bathrooms,
    this.agencyName,
    this.tierLabel,
    this.tierColor,
    this.isVerified,
    this.emoji, // placeholder for image
    this.rating = 0,
    this.agentAvatarUrl,
    this.agentInitials,
    this.address,
    this.condition,
    this.isFeatured,
    this.isRecent,
    this.showInOptions,
    this.mediaUrls,
    this.description,

    this.amenities,
    this.features,
    this.utilities,
    this.nearbyFacilities,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      agencyId: json['agencyId'] as String?,
      title: json['title'] as String?,
      address: json['address'] as String?,
      lga: json['lga'] as String?,
      state: json['state'] as String?,
      area: json['area'] as String?,
      price: json['price'] as String?,
      priceUnit: json['priceUnit'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      toilets: json['toilets'] as int?,
      condition: json['condition'] as String?,
      isVerified: json['isVerified'] as bool?,
      isFeatured: json['isFeatured'] as bool?,
      isRecent: json['isFeatured'] as bool?,
      showInOptions: json['showInOptions'] as bool?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toDouble() ?? 0,
      areaSqm: (json['areaSqm'] as num?)?.toDouble() ?? 2,
      description: json['description'] as String?,
      location: json['location'] as String?,
      agencyName: json['agencyName'] as String?,
      tierLabel: json['tierLabel'] as String?,
      tierColor: json['tierColor'] != null
          ? Color(json['tierColor'] as int)
          : null,
      emoji: json['emoji'] as String?,
      agentInitials: json['agentInitials'] as String?,
      agentAvatarUrl: json['agentAvatarUrl'] as String?,
      propertyType: json['propertyType'] as String? ?? "House",
      documentType: json['documentType'] as String?,
      dimensions: json['dimensions'] as String?,
      floorLevel: json['floorLevel'] as int?,
      layoutType: json['layoutType'] as String?,
      parkingSpaces: json['parkingSpaces'] as String?,
      unitCount: json['unitCount'] as int?,
      category: json['category'] != null
          ? PropertyCategory.values[json['category'] as int]
          : PropertyCategory.none,
      listingType: json['listingType'] != null
          ? ListingType.values[json['listingType'] as int]
          : null,
      type: json['type'] != null
          ? PropertyType.values[json['type'] as int]
          : null,
      listedBy: json['listedBy'] != null
          ? UserType.values[json['listedBy'] as int]
          : null,
      verificationStatus: json['verificationStatus'] != null
          ? VerificationStatus.values[json['verificationStatus'] as int]
          : null,
      mediaUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      utilities: (json['utilities'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      nearbyFacilities: (json['nearbyFacilities'] as List<dynamic>?)
          ?.map((e) => NearbyFacility.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      agency: json['agency'] != null
          ? AgencyModel.fromJson(json['agency'] as Map<String, dynamic>)
          : null,
      documents: json['documents'] != null
          ? DocumentModel.fromJson(json['documents'] as Map<String, dynamic>)
          : null,
      asResidential: json['asResidential'] != null
          ? AsResidential.fromJson(
              json['asResidential'] as Map<String, dynamic>,
            )
          : null,
      asLand: json['asLand'] != null
          ? AsLand.fromJson(json['asLand'] as Map<String, dynamic>)
          : null,
      asOffice: json['asOffice'] != null
          ? AsOffice.fromJson(json['asOffice'] as Map<String, dynamic>)
          : null,
      asLease: json['asLease'] != null
          ? AsLease.fromJson(json['asLease'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'agencyId': agencyId,
      'title': title,
      'address': address,
      'lga': lga,
      'state': state,
      'area': area,
      'price': price,
      'priceUnit': priceUnit,
      'paymentTerms': paymentTerms,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'toilets': toilets,
      'condition': condition,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'isRecent': isRecent,
      'showInOptions': showInOptions,
      'rating': rating,
      'reviewCount': reviewCount,
      'areaSqm': areaSqm,
      'description': description,
      'location': location,
      'agencyName': agencyName,
      'tierLabel': tierLabel,
      'tierColor': tierColor?.value, // Color → int (ARGB)
      'emoji': emoji,
      'agentInitials': agentInitials,
      'agentAvatarUrl': agentAvatarUrl,
      'propertyType': propertyType,
      'documentType': documentType,
      'dimensions': dimensions,
      'floorLevel': floorLevel,
      'layoutType': layoutType,
      'parkingSpaces': parkingSpaces,
      'unitCount': unitCount,
      'category': category?.index,
      'listingType': listingType?.index,
      'type': type?.index,
      'listedBy': listedBy?.index,
      'verificationStatus': verificationStatus?.index,
      'imageUrls': mediaUrls,
      'amenities': amenities,
      'features': features,
      'utilities': utilities,
      'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'agency': agency?.toJson(),
      'documents': documents?.toJson(),
      'asResidential': asResidential?.toJson(),
      'asLand': asLand?.toJson(),
      'asOffice': asOffice?.toJson(),
      'asLease': asLease?.toJson(),
    };
  }

  // -------------------------
  final Key? key;
  final PropertyCategory? category;
  final String? documentType;
  final String? dimensions;
  final int? floorLevel;
  final String? layoutType;
  final String? parkingSpaces;
  final int? unitCount;
  final PropertyType? type;
  final ListingType? listingType;
  final UserType? listedBy;
  final String? userId;
  final String? agencyId;
  // -------------------------
  final VerificationStatus? verificationStatus;
  // -------------------------
  final AgencyModel? agency;
  // -----------------------
  final DocumentModel? documents;
  //--------------------------
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // ------------------------
  final AsResidential? asResidential;
  // ------------------------
  final AsLand? asLand;
  // ------------------------
  final AsOffice? asOffice;
  // -----------------------
  final AsLease? asLease;
  // -----------------------
  final String? id;
  final String? propertyType;

  final String? title;
  final String? address;
  final String? lga; //
  final String? state; //
  final String? area; //

  final String? price;
  final String? priceUnit; // "per year" / "per month" / "one-time"
  final String? paymentTerms; // "Lump sum" / "Installments available"

  final int? bedrooms;
  final int? bathrooms;
  final int? toilets; //
  final String? condition; // "New" / "Renovated" / "Good"

  final bool? isVerified;
  final bool? isFeatured; //
  final bool? isRecent;
  final bool? showInOptions;
  final double? rating;

  final List<String>? mediaUrls; //
  final String? description; //

  final List<String>? amenities; //
  final List<String>? features; //
  final Map<String, String>? utilities; //

  final List<NearbyFacility>? nearbyFacilities; //

  final double? reviewCount;
  final double? areaSqm;

  final String? agentInitials;
  final String? agentAvatarUrl;

  final String? location;

  final String? agencyName;
  final String? tierLabel;
  final Color? tierColor;

  final String? emoji;
}
