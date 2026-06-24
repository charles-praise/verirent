part of 'home_cubit.dart';

enum HomePhase { initial, loading, loaded, error }

class HomeState extends Equatable {
  final int activeIndex;
  final bool isFilterVisible;
  final List<IconData> filterIcons;
  final List<String> filters;
  final Map<PropertyCategory, List<PropertyModel>> listings;
  final HomePhase phase;

  const HomeState({
    this.phase = HomePhase.initial,
    this.activeIndex = 0,
    this.isFilterVisible = false,
    this.listings = const {},
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
    Map<PropertyCategory, List<PropertyModel>>? listings,
    HomePhase? phase,
  }) {
    return HomeState(
      activeIndex: activeIndex ?? this.activeIndex,
      isFilterVisible: isFilterVisible ?? this.isFilterVisible,
      listings: listings ?? this.listings,
      phase: phase ?? this.phase,
    );
  }

  @override
  List<Object?> get props => [
    activeIndex,
    isFilterVisible,
    listings,
    filterIcons,
    filters,
    phase,
  ];
}
