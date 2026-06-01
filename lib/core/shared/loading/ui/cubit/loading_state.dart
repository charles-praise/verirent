part of 'loading_cubit.dart';

enum LoadingEnum { initial, loading, loaded, declined, error }

class LoadingState extends Equatable {
  final String message;
  final String actionLabel;
  final String reason;
  final LoadingEnum loadingEnum;
  final String errorCode;
  final double progress;

  const LoadingState({
    this.progress = 0.0,
    this.errorCode = "",
    this.message = 'Request Declined',
    this.reason = 'Please try again',
    this.actionLabel = 'Retry',
    this.loadingEnum = LoadingEnum.initial,
  });

  LoadingState copyWith({
    double? progress,
    String? message,
    String? actionLabel,
    String? reason,
    LoadingEnum? loadingEnum,
    String? errorCode,
  }) {
    return LoadingState(
      progress: progress ?? this.progress,
      actionLabel: actionLabel ?? this.actionLabel,
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      loadingEnum: loadingEnum ?? this.loadingEnum,
    );
  }

  @override
  List<Object> get props => [
    progress,
    message,
    actionLabel,
    reason,
    loadingEnum,
    errorCode,
  ];
}
