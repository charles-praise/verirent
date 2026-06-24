/// developer: charles praise diepriye
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/core/models/property_model.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  List<PropertyModel> _allProperties = [];

  // ── Seed the full list ─────────────────────────────────────────────────
  // Call once on app start or whenever the source data changes.
  // Does NOT trigger a search — just caches the list.
  void setAllProperties(List<PropertyModel> properties) {
    _allProperties = properties;
  }

  // ── Typing in the search bar ───────────────────────────────────────────
  void searchProperties(List<PropertyModel> properties, String query) {
    _allProperties = properties;
    // Emit the new query first, THEN filter against it.
    final next = state.copyWith(query: query);
    emit(next);
    _applyFilters(next);
  }

  void updateQuery(String value) {
    final next = state.copyWith(query: value);
    emit(next);
    _applyFilters(next);
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

  // ── Apply FiltersPanel values without touching the query ───────────────
  // This is what onApply in HomeSearchBar and SearchPage should call.
  // It NEVER resets filters — it just re-runs the pipeline with whatever
  // filter values are currently in state.
  void applyFilters(List<PropertyModel> properties) {
    _allProperties = properties;
    _applyFilters(state);
  }

  // ── Individual filter mutations (live-update as user adjusts) ─────────
  void updatePrice(RangeValues value) {
    final next = state.copyWith(priceRange: value);
    emit(next);
    _applyFilters(next);
  }

  void updateType(String value) {
    final next = state.copyWith(selectedType: value);
    emit(next);
    _applyFilters(next);
  }

  void updateBeds(int value) {
    final next = state.copyWith(minBeds: value);
    emit(next);
    _applyFilters(next);
  }

  void updateBaths(int value) {
    final next = state.copyWith(minBaths: value);
    emit(next);
    _applyFilters(next);
  }

  void updateVerified(bool value) {
    final next = state.copyWith(verifiedOnly: value);
    emit(next);
    _applyFilters(next);
  }

  void resetFilters() {
    final next = state.copyWith(
      priceRange: const RangeValues(100000, 2000000),
      selectedType: 'Any',
      minBeds: 0,
      minBaths: 0,
      verifiedOnly: false,
      selectedCategory: PropertyCategory.none,
    );
    emit(next);
    _applyFilters(next);
  }

  // ── Home category chips ────────────────────────────────────────────────
  void setHomeCategory(int chipIndex) {
    const map = {
      0: PropertyCategory.none,
      1: PropertyCategory.residential,
      2: PropertyCategory.residential,
      3: PropertyCategory.shortLet,
      4: PropertyCategory.commercial,
    };
    final cat = map[chipIndex] ?? PropertyCategory.none;
    final next = state.copyWith(selectedCategory: cat);
    emit(next);
    _applyFilters(next);
  }

  // ── Filter panel visibility (SearchPage inline panel only) ────────────
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

  // ── REMOVED: filterResult ──────────────────────────────────────────────
  // The old `filterResult` set query = " " (a space) to bypass the
  // early-return guard, which caused the text-match branch to run against
  // " " and return zero results every time.
  // Replaced by `applyFilters()` above which passes state explicitly.

  // ── Core filter pipeline ───────────────────────────────────────────────
  // Takes an explicit [snapshot] instead of reading `state` so it always
  // operates on the values that were just emitted — never stale state.
  void _applyFilters(SearchState snapshot) {
    final query = snapshot.query.trim(); // trim so " " == ""
    final hasActiveFilters = _hasNonDefaultFilters(snapshot);

    // Early-return ONLY when there is genuinely nothing to filter on.
    if (query.isEmpty &&
        snapshot.selectedCategory == PropertyCategory.none &&
        !hasActiveFilters) {
      emit(
        snapshot.copyWith(
          searchStage: SearchStage.initial,
          filteredProperties: [],
        ),
      );
      return;
    }

    // Guard: if _allProperties is empty there is nothing to filter.
    // The UI will show an empty state rather than silently doing nothing.
    if (_allProperties.isEmpty) {
      emit(
        snapshot.copyWith(
          searchStage: SearchStage.loaded,
          filteredProperties: [],
        ),
      );
      return;
    }

    final lower = query.toLowerCase();
    final priceMin = snapshot.priceRange.start;
    final priceMax = snapshot.priceRange.end;

    final filtered = _allProperties.where((p) {
      // ── Text query (only applied when non-empty) ─────────────────────
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

      // ── Category chip ────────────────────────────────────────────────
      if (snapshot.selectedCategory != PropertyCategory.none) {
        if (p.category != snapshot.selectedCategory) return false;
      }

      // ── Property type dropdown ───────────────────────────────────────
      if (snapshot.selectedType != 'Any') {
        final match =
            p.propertyType?.toLowerCase() ==
            snapshot.selectedType.toLowerCase();
        if (!match) return false;
      }

      // ── Price ────────────────────────────────────────────────────────
      // Strip commas/symbols and parse. Skip price check if unparseable
      // (e.g. "negotiable") so those listings still appear.
      final rawPrice = p.price?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
      final priceNum = double.tryParse(rawPrice);
      if (priceNum != null) {
        if (priceNum < priceMin || priceNum > priceMax) return false;
      }

      // ── Beds / baths ─────────────────────────────────────────────────
      if ((p.bedrooms ?? 0) < snapshot.minBeds) return false;
      if ((p.bathrooms ?? 0) < snapshot.minBaths) return false;

      // ── Verified only ────────────────────────────────────────────────
      if (snapshot.verifiedOnly && p.isVerified != true) return false;

      return true;
    }).toList();

    emit(
      snapshot.copyWith(
        searchStage: SearchStage.loaded,
        filteredProperties: filtered,
      ),
    );
  }

  // Returns true if any filter differs from its default value.
  bool _hasNonDefaultFilters(SearchState s) =>
      s.priceRange.start != 100000 ||
      s.priceRange.end != 2000000 ||
      s.selectedType != 'Any' ||
      s.minBeds > 0 ||
      s.minBaths > 0 ||
      s.verifiedOnly;
}
