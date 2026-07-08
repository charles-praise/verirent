import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/property_model.dart';

enum HomePhase { initial, loading, loaded, error }

class HomeState extends Equatable {
  final int activeIndex;
  final bool isFilterVisible;
  final List<IconData> filterIcons;
  final List<String> filters;
  final Map<PropertyCategory, List<PropertyModel>> home;
  final HomePhase phase;

  const HomeState({
    this.phase = HomePhase.initial,
    this.activeIndex = 0,
    this.isFilterVisible = false,
    this.home = const {},
    this.filterIcons = const [
      Icons.star_rounded,
      Icons.house_rounded,
      Icons.apartment_rounded,
      Icons.chair_rounded,
      Icons.business_center_rounded,
    ],
    this.filters = const [
      'All',
      'Apartment',
      'Duplex',
      'Furnished',
      'Corporate',
    ],
  });

  HomeState copyWith({
    int? activeIndex,
    bool? isFilterVisible,
    Map<PropertyCategory, List<PropertyModel>>? home,
    HomePhase? phase,
  }) {
    return HomeState(
      activeIndex: activeIndex ?? this.activeIndex,
      isFilterVisible: isFilterVisible ?? this.isFilterVisible,
      home: home ?? this.home,
      phase: phase ?? this.phase,
    );
  }

  @override
  List<Object?> get props => [
    activeIndex,
    isFilterVisible,
    home,
    filterIcons,
    filters,
    phase,
  ];
}
