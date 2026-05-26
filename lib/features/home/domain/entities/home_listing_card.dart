import 'package:flutter/material.dart';

class ListingCard {
  const ListingCard({
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
  });

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
