import 'package:equatable/equatable.dart';

import '../../../../core/models/property/property_model.dart';

enum SavedStatus { initial, loading, loaded, empty, error }

class SavedState extends Equatable {
  final SavedStatus status;
  final List<PropertyModel> items;
  final Set<String> removingIds;
  final String? errorMessage;
  final int activeFilterIndex;
  final List<String> filters;

  const SavedState({
    this.status = SavedStatus.initial,
    this.items = const [],
    this.removingIds = const {},
    this.errorMessage,
    this.activeFilterIndex = 0,
    this.filters = const ['All', 'Rent', 'Sale', 'Verified'],
  });
  factory SavedState.fromJson(Map<String, dynamic> json) {
    return SavedState(
      status: SavedStatus.values[json['status'] as int? ?? 0],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      removingIds: (json['removingIds'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toSet(),
      activeFilterIndex: json['activeFilterIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.index,
      'items': items.map((p) => p.toJson()).toList(),
      'removingIds': removingIds.toList(),
      'activeFilterIndex': activeFilterIndex,
    };
  }

  SavedState copyWith({
    SavedStatus? status,
    List<PropertyModel>? items,
    Set<String>? removingIds,
    String? errorMessage,
    int? activeFilterIndex,
  }) => SavedState(
    status: status ?? this.status,
    items: items ?? this.items,
    removingIds: removingIds ?? this.removingIds,
    errorMessage: errorMessage ?? this.errorMessage,
    activeFilterIndex: activeFilterIndex ?? this.activeFilterIndex,
  );

  List<PropertyModel> get filteredItems {
    if (activeFilterIndex == 0) return items;
    final filter = filters[activeFilterIndex];
    return items.where((p) {
      if (filter == 'Rent') return p.listingType == ListingType.rent;
      if (filter == 'Sale') return p.listingType == ListingType.sale;
      if (filter == 'Verified') return p.isVerified!;
      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
    status,
    items,
    removingIds,
    errorMessage,
    activeFilterIndex,
    filters,
  ];
}
