import 'package:flutter/material.dart';
import 'package:verirent/core/api/domain/entities/agency_model.dart';

import '../../../../core/api/domain/entities/document_model.dart';
import 'nearby_facilities.dart';

// ---------------------------
enum PropertyCategory {
  initial,
  land,
  commercial,
  residential,
  estate,
  shortlet,
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
    super.imageUrls,
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
    super.imageUrls,
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
    super.imageUrls,
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
}

// ------------ PROPERTY MODEL (BASE CLASS) -------------------
class PropertyModel {
  const PropertyModel({
    // -------------------
    this.key,
    this.id,
    this.category = PropertyCategory.initial,
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
    this.imageUrls,
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
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toDouble(),
      areaSqm: (json['areaSqm'] as num?)?.toDouble(),
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
      propertyType: json['propertyType'] as String?,
      documentType: json['documentType'] as String?,
      dimensions: json['dimensions'] as String?,
      floorLevel: json['floorLevel'] as int?,
      layoutType: json['layoutType'] as String?,
      parkingSpaces: json['parkingSpaces'] as String?,
      unitCount: json['unitCount'] as int?,
      category: json['category'] != null
          ? PropertyCategory.values[json['category'] as int]
          : PropertyCategory.initial,
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
      imageUrls: (json['imageUrls'] as List<dynamic>?)
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
      'imageUrls': imageUrls,
      'amenities': amenities,
      'features': features,
      'utilities': utilities,
      'nearbyFacilities': nearbyFacilities?.map((f) => f.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
  final VerificationStatus? verificationStatus;
  final AgencyModel? agency;
  final DocumentModel? documents;
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
  final double? rating;

  final List<String>? imageUrls; //
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
