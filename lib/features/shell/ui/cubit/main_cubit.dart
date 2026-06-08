// main_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/location/ui/cubit/location_cubit.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final LocationCubit _locationCubit;

  MainCubit(this._locationCubit) : super(const MainState()) {
    _startup();
  }

  Future<void> _startup() async {
    // Kick off location pipeline concurrently with auth check.
    // Neither blocks the other.
    await Future.wait([_locationCubit.init(), _checkAuth()]);
  }

  Future<void> _checkAuth() async {
    // TODO: implement auth flow here
  }

  void navigate(int value) => emit(state.copyWith(navigationIndex: value));
}
