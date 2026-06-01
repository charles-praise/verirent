import 'package:flutter/material.dart';

import 'agency_profile.dart';
import 'document_status.dart';
import 'nearby_facilities.dart';

class PropertyModel {
  const PropertyModel({
    required this.id,
    this.reviewCount = 0,
    this.areaSqm = "2",
    this.propertyType = "House",
    required this.lga,
    required this.state,
    required this.area,
    required this.priceUnit,
    required this.paymentTerms,
    required this.toilets,
    required this.listingType, // Rent, Sale
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.agencyName,
    required this.tierLabel,
    required this.tierColor,
    required this.isVerified,
    required this.emoji, // placeholder for image
    this.rating = 0,
    this.agentAvatarUrl,
    this.agentInitials,
    required this.address,
    required this.condition,
    required this.isFeatured,
    required this.imageUrls,
    required this.description,
    this.agency,
    this.documents,
    required this.amenities,
    required this.features,
    required this.utilities,
    required this.nearbyFacilities,
  });

  ///-------------------------
  final String id;
  final String listingType;
  final String propertyType;

  final String title;
  final String address;
  final String lga; //
  final String state; //
  final String area; //

  final String price;
  final String priceUnit; // "per year" / "per month" / "one-time"
  final String paymentTerms; // "Lump sum" / "Installments available"

  final int bedrooms;
  final int bathrooms;
  final int? toilets; //
  final String condition; // "New" / "Renovated" / "Good"

  final bool isVerified;
  final bool isFeatured; //
  final double rating;

  final List<String> imageUrls; //
  final String description; //

  final AgencyProfile? agency; //
  final DocumentStatus? documents; //

  final List<String> amenities; //
  final List<String> features; //
  final Map<String, String> utilities; //

  final List<NearbyFacility> nearbyFacilities; //

  final double reviewCount;
  final String areaSqm;

  final String? agentInitials;
  final String? agentAvatarUrl;

  final String location;

  final String agencyName;
  final String tierLabel;
  final Color tierColor;

  final String emoji;
}
