part of 'main_cubit.dart';

enum Status {
  initial,
  loading,
  serviceDisabled,
  rationaleRequired,
  requesting,
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  error,
}

final class MainState extends Equatable {
  final Status status;
  final bool isBackground;
  final Position? position;
  final String? message;
  final int? navigationIndex;

  const MainState({
    this.status = Status.initial,
    this.isBackground = false,
    this.navigationIndex = 0,
    this.position,
    this.message,
  });

  MainState copyWith({
    Status? status,
    bool? isBackground,
    Position? position,
    String? message,
    int? navigationIndex,
  }) {
    return MainState(
      status: status ?? this.status,
      isBackground: isBackground ?? this.isBackground,
      position: position ?? this.position,
      navigationIndex: navigationIndex ?? this.navigationIndex,
      message: message,
    );
  }

  @override
  List<Object> get props => [
    status,
    isBackground,
    ?position,
    ?message,
    ?navigationIndex,
  ];
}
