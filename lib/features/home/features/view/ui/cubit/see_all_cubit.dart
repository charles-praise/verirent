import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verirent/core/models/property/property_model.dart';

part 'see_all_state.dart';

class SeeAllCubit extends Cubit<SeeAllState> {
  SeeAllCubit() : super(SeeAllState());

  // cache memory
  List<PropertyModel> _allProperties = [];

  void clearQuery() {
    emit(state.copyWith(query: ''));
  }

  void saveProperties(List<PropertyModel> properties) {
    _allProperties = properties;
  }

  // Does NOT trigger a search — just caches the list.
  void setAllProperties(List<PropertyModel> properties) {
    _allProperties = properties;
  }

  void activeIndex(int index) => emit(state.copyWith(activeIndex: index));

  void setProperties(List<PropertyModel> properties, String query) {
    emit(state.copyWith(allProperties: properties, query: query.trim()));
  }

  // ── Typing in the search bar ───────────────────────────────────────────
  void searchProperties(List<PropertyModel> properties, String query) {
    _allProperties = properties;
    // Emit the new query first, THEN filter against it.
    final next = state.copyWith(query: query);
    emit(next);
    _applyFilters(next);
  }

  // ── Core filter pipeline ───────────────────────────────────────────────
  // Takes an explicit [snapshot] instead of reading `state` so it always
  // operates on the values that were just emitted — never stale state.
  void _applyFilters(SeeAllState snapshot) {
    final query = snapshot.query.trim(); // trim so " " == ""
    final hasActiveFilters = _hasNonDefaultFilters(snapshot);

    // Early-return ONLY when there is genuinely nothing to filter on.
    if (query.isEmpty &&
        snapshot.selectedCategory == PropertyCategory.none &&
        !hasActiveFilters) {
      emit(
        snapshot.copyWith(
          seeAllStage: SeeAllStage.initial,
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
          seeAllStage: SeeAllStage.loaded,
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
        seeAllStage: SeeAllStage.loaded,
        filteredProperties: filtered,
      ),
    );
  }

  bool _hasNonDefaultFilters(SeeAllState s) =>
      s.priceRange.start != 100000 ||
      s.priceRange.end != 2000000 ||
      s.selectedType != 'Any' ||
      s.minBeds > 0 ||
      s.minBaths > 0 ||
      s.verifiedOnly;
}
