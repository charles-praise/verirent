import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/repo/local_repo.dart';
import '../../domain/home_response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeState()) {
    _subscribeToBackgroundUpdates();
  }

  final LocalRepository _repository;
  StreamSubscription<HomeResponse>? _updatesSub;

  void _subscribeToBackgroundUpdates() {
    _updatesSub = _repository.homeUpdates.listen((home) {
      emit(
        state.copyWith(home: home.categories),
      ); // no loading flicker — silent swap
    });
  }

  Future<void> load() async {
    emit(state.copyWith(phase: HomePhase.loading));
    try {
      final home = await _repository.home();
      emit(state.copyWith(home: home.categories, phase: HomePhase.loaded));
    } catch (e) {
      emit(state.copyWith(phase: HomePhase.error));
    }
  }

  void activeIndex(int value) => emit(state.copyWith(activeIndex: value));

  void loadListing() {}

  @override
  Future<void> close() {
    _updatesSub?.cancel();
    return super.close();
  }
}
