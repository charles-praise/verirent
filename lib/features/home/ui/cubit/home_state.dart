part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int activeIndex;

  const HomeState({this.activeIndex = 0});

  HomeState copyWith({final int? activeIndex}) {
    return HomeState(activeIndex: activeIndex ?? this.activeIndex);
  }

  @override
  List<Object?> get props => [activeIndex];
}
