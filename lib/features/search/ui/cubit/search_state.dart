/// search_state.dart (developer: charles praise diepriye)

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verirent/core/models/property/property_model.dart';

enum SearchStage { initial, loading, loaded, error }

class SearchState extends Equatable {
  final String query;
  final SearchStage searchStage;
  final List<PropertyModel> filteredProperties;

  final bool filtersExpanded;

  final RangeValues priceRange;
  final int minBeds;
  final int minBaths;
  final String selectedType;
  final bool verifiedOnly;
  final PropertyCategory selectedCategory;

  final List<String> recentSearches;
  final List<String> propertyTypes;

  const SearchState({
    this.filteredProperties = const [],
    this.searchStage = SearchStage.initial,
    this.query = '',
    this.filtersExpanded = false,
    this.priceRange = const RangeValues(100000, 2000000),
    this.minBeds = 0,
    this.minBaths = 0,
    this.selectedType = 'Any',
    this.verifiedOnly = false,
    this.selectedCategory = PropertyCategory.none,
    this.recentSearches = const [
      'GRA Phase 2 apartments',
      'Trans Amadi furnished flat',
      'Woji 3 bedroom duplex',
      'D/Line self contain',
    ],
    this.propertyTypes = const [
      'Any',
      'Apartment',
      'Duplex',
      'Flat',
      'Bungalow',
      'Furnished',
      'Corporate',
    ],
  });

  SearchState copyWith({
    List<PropertyModel>? filteredProperties,
    SearchStage? searchStage,
    String? query,
    bool? filtersExpanded,
    RangeValues? priceRange,
    int? minBeds,
    int? minBaths,
    String? selectedType,
    bool? verifiedOnly,
    PropertyCategory? selectedCategory,
    List<String>? recentSearches,
    List<String>? propertyTypes,
  }) {
    return SearchState(
      filteredProperties: filteredProperties ?? this.filteredProperties,
      searchStage: searchStage ?? this.searchStage,
      query: query ?? this.query,
      filtersExpanded: filtersExpanded ?? this.filtersExpanded,
      priceRange: priceRange ?? this.priceRange,
      minBeds: minBeds ?? this.minBeds,
      minBaths: minBaths ?? this.minBaths,
      selectedType: selectedType ?? this.selectedType,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      recentSearches: recentSearches ?? this.recentSearches,
      propertyTypes: propertyTypes ?? this.propertyTypes,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (priceRange.start != 100000 || priceRange.end != 2000000) count++;
    if (selectedType != 'Any') count++;
    if (minBeds > 0) count++;
    if (minBaths > 0) count++;
    if (verifiedOnly) count++;
    if (selectedCategory != PropertyCategory.none) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    filteredProperties,
    searchStage,
    query,
    filtersExpanded,
    priceRange,
    minBeds,
    minBaths,
    selectedType,
    verifiedOnly,
    selectedCategory,
    recentSearches,
    propertyTypes,
  ];
}
