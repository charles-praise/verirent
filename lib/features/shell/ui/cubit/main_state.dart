import 'package:equatable/equatable.dart';

enum Status { initial }

final class MainState extends Equatable {
  final Status status;
  final int navigationIndex;

  const MainState({this.status = Status.initial, this.navigationIndex = 0});

  MainState copyWith({Status? status, int? navigationIndex}) {
    return MainState(
      status: status ?? this.status,
      navigationIndex: navigationIndex ?? this.navigationIndex,
    );
  }

  @override
  List<Object> get props => [status, navigationIndex];
}
