import 'package:flutter/material.dart';

class ListingCard {
  const ListingCard({
    this.reviewCount = 0,
    this.areaSqm = "2",
    this.propertyType = "House",
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
    this.rating,
    this.agentAvatarUrl,
    this.agentInitials,
  });
  final double reviewCount;
  final String areaSqm;
  final String propertyType;
  final String? agentInitials;
  final String? agentAvatarUrl;
  final int? rating;
  final String title;
  final String location;
  final String price;
  final int bedrooms;
  final int bathrooms;
  final String agencyName;
  final String tierLabel;
  final Color tierColor;
  final bool isVerified;
  final String emoji;
}
