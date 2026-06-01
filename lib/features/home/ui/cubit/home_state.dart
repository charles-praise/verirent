part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int activeIndex;
  final bool isFilterVisible;

  const HomeState({this.activeIndex = 0, this.isFilterVisible = false});

  HomeState copyWith({final int? activeIndex, final bool? isFilterVisible}) {
    return HomeState(
      activeIndex: activeIndex ?? this.activeIndex,
      isFilterVisible: isFilterVisible ?? this.isFilterVisible,
    );
  }

  @override
  List<Object?> get props => [activeIndex];
}
