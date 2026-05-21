part of 'main_cubit.dart';

enum LocationStatus {
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
  final LocationStatus status;
  final bool isBackground;
  final Position? position;
  final String? message;

  const MainState({
    this.status = LocationStatus.initial,
    this.isBackground = false,
    this.position,
    this.message,
  });

  MainState copyWith({
    LocationStatus? status,
    bool? isBackground,
    Position? position,
    String? message,
  }) {
    return MainState(
      status: status ?? this.status,
      isBackground: isBackground ?? this.isBackground,
      position: position ?? this.position,
      message: message,
    );
  }

  @override
  List<Object> get props => [status, isBackground, ?position, ?message];
}
