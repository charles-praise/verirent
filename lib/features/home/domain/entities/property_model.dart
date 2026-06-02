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
