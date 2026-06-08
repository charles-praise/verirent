/// developer: charles praise diepriye
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  // Cached full list so filter changes can re-run without re-passing data.
  List<PropertyModel> _allProperties = [];

  // ── Primary entry point ────────────────────────────────────────────────
  // Call this whenever the source list or query changes.
  void searchProperties(List<PropertyModel> properties, String query) {
    _allProperties = properties;
    emit(state.copyWith(query: query));
    _applyFilters();
  }

  // ── Query-only update (typing in search bar) ───────────────────────────
  void updateQuery(String value) {
    emit(state.copyWith(query: value));
    _applyFilters();
  }

  void clearQuery() {
    emit(
      state.copyWith(
        query: '',
        searchStage: SearchStage.initial,
        filteredProperties: [],
      ),
    );
  }

  // ── Filter mutations — each re-runs the filter pipeline ───────────────
  void updatePrice(RangeValues value) {
    emit(state.copyWith(priceRange: value));
    _applyFilters();
  }

  void updateType(String value) {
    emit(state.copyWith(selectedType: value));
    _applyFilters();
  }

  void updateBeds(int value) {
    emit(state.copyWith(minBeds: value));
    _applyFilters();
  }

  void updateBaths(int value) {
    emit(state.copyWith(minBaths: value));
    _applyFilters();
  }

  void updateVerified(bool value) {
    emit(state.copyWith(verifiedOnly: value));
    _applyFilters();
  }

  void resetFilters() {
    emit(
      state.copyWith(
        priceRange: const RangeValues(100000, 2000000),
        selectedType: 'Any',
        minBeds: 0,
        minBaths: 0,
        verifiedOnly: false,
        selectedCategory: PropertyCategory.initial,
      ),
    );
    _applyFilters();
  }

  // ── Home category chip (index → category) ─────────────────────────────
  void setHomeCategory(int chipIndex) {
    const map = {
      0: PropertyCategory.initial,
      1: PropertyCategory.residential,
      2: PropertyCategory.residential,
      3: PropertyCategory.shortlet,
      4: PropertyCategory.commercial,
      5: PropertyCategory.residential,
      6: PropertyCategory.residential,
    };
    final cat = map[chipIndex] ?? PropertyCategory.initial;
    emit(state.copyWith(selectedCategory: cat));
    _applyFilters();
  }

  // filter result
  void filterResult(List<PropertyModel> properties) {
    _allProperties = properties;
    emit(
      state.copyWith(
        query: " ",
        priceRange: state.priceRange,
        minBaths: state.minBaths,
        minBeds: state.minBeds,
        verifiedOnly: state.verifiedOnly,
        selectedType: state.selectedType,
      ),
    );
    _applyFilters();
  }

  // ── Filter panel visibility ────────────────────────────────────────────
  void toggleFilters() =>
      emit(state.copyWith(filtersExpanded: !state.filtersExpanded));

  void closeFilters() => emit(state.copyWith(filtersExpanded: false));

  // ── Recent searches ────────────────────────────────────────────────────
  void saveSearch(String term) {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    final updated = [
      trimmed,
      ...state.recentSearches.where((s) => s != trimmed),
    ].take(10).toList();
    emit(state.copyWith(recentSearches: updated));
  }

  void clearRecentSearches() => emit(state.copyWith(recentSearches: []));

  // core filter pipeline
  void _applyFilters() {
    final query = state.query.trim();

    if (query.isEmpty && state.selectedCategory == PropertyCategory.initial) {
      // return to initial so Home shows full feed.
      emit(
        state.copyWith(
          searchStage: SearchStage.initial,
          filteredProperties: [],
        ),
      );
      return;
    }

    final lower = query.toLowerCase();
    final priceMin = state.priceRange.start;
    final priceMax = state.priceRange.end;

    final filtered = _allProperties.where((p) {
      // Text query (skip if empty)
      if (query.isNotEmpty) {
        final matchesQuery = [
          p.title,
          p.address,
          p.area,
          p.lga,
          p.state,
          p.propertyType,
          p.category?.name,
        ].whereType<String>().any((e) => e.toLowerCase().contains(lower));
        if (!matchesQuery) return false;
      }

      // Category (from Home chips)
      if (state.selectedCategory != PropertyCategory.initial) {
        if (p.category != state.selectedCategory) return false;
      }

      // Property type dropdown
      if (state.selectedType != 'Any') {
        final typeMatch =
            p.propertyType?.toLowerCase() == state.selectedType.toLowerCase();
        if (!typeMatch) return false;
      }

      // Price — parse the price string, ignore non-numeric listings
      final rawPrice = p.price?.replaceAll(RegExp(r'[^0-9]'), '');
      final priceNum = double.tryParse(rawPrice ?? '');
      if (priceNum != null) {
        if (priceNum < priceMin || priceNum > priceMax) return false;
      }

      // Beds / baths
      if ((p.bedrooms ?? 0) < state.minBeds) return false;
      if ((p.bathrooms ?? 0) < state.minBaths) return false;

      // Verified only
      if (state.verifiedOnly && p.isVerified != true) return false;

      return true;
    }).toList();

    emit(
      state.copyWith(
        searchStage: SearchStage.loaded,
        filteredProperties: filtered,
      ),
    );
  }
}
