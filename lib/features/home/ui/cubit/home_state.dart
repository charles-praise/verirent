part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int activeIndex;
  final bool isFilterVisible;
  final List<IconData> filterIcons;
  final List<String> filters;
  final List<PropertyModel> allProperties;

  const HomeState({
    this.activeIndex = 0,
    this.isFilterVisible = false,
    this.allProperties = const [],
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
    List<PropertyModel>? allProperties,
  }) {
    return HomeState(
      activeIndex: activeIndex ?? this.activeIndex,
      isFilterVisible: isFilterVisible ?? this.isFilterVisible,
      allProperties: allProperties ?? this.allProperties,
    );
  }

  @override
  List<Object?> get props => [
    activeIndex,
    isFilterVisible,
    allProperties,
    filterIcons,
    filters,
  ];
}
