import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState());

  // ── Start loading animation with optional duration
  Future<void> startLoading({Duration? duration}) async {
    emit(state.copyWith(progress: 0.0));

    final totalDuration = duration ?? const Duration(seconds: 3);
    final steps = 30;
    final stepDuration = totalDuration.inMilliseconds ~/ steps;

    for (int i = 0; i <= steps; i++) {
      if (isClosed) return;

      final progress = (i / steps * 100).toDouble();
      emit(state.copyWith(progress: progress));

      if (i < steps) {
        await Future.delayed(Duration(milliseconds: stepDuration));
      }
    }
  }

  // ── Complete with success (loaded state)
  Future<void> completeSuccess({
    String message = 'Successfully Loaded',
    String? actionLabel,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(delay);
    if (!isClosed) {
      emit(state.copyWith(message: message, actionLabel: actionLabel));
    }
  }

  // ── Complete with decline
  Future<void> completeDecline({
    String message = 'Request Declined',
    String reason = 'Please try again',
    String actionLabel = 'Retry',
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(delay);
    if (!isClosed) {
      emit(
        state.copyWith(
          message: message,
          reason: reason,
          actionLabel: actionLabel,
        ),
      );
    }
  }

  // ── Error state
  void setError({required String message, String errorCode = 'UNKNOWN_ERROR'}) {
    if (!isClosed) {
      emit(state.copyWith(message: message, errorCode: errorCode));
    }
  }

  // ── Retry: Reset to initial
  void reset() {
    if (!isClosed) {
      emit(state.copyWith(loadingEnum: LoadingEnum.initial));
    }
  }

  // ── Simulate API call with loading → success
  Future<void> simulateAPICall({
    Duration loadingDuration = const Duration(seconds: 3),
    bool shouldSucceed = true,
    String successMessage = 'Listing Created Successfully',
    String declineMessage = 'Listing Could Not Be Created',
  }) async {
    await startLoading(duration: loadingDuration);

    if (shouldSucceed) {
      await completeSuccess(message: successMessage);
    } else {
      await completeDecline(message: declineMessage);
    }
  }
}
