// main_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/shared/location/ui/cubit/location_cubit.dart';
import '../../../auth/ui/cubit/auth_cubit.dart';
import '../../../home/ui/pages/home.dart';
import '../../../message/ui/pages/messages.dart';
import '../../../saved/ui/pages/saved.dart';
import '../../../settings/ui/pages/settings.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final LocationCubit _locationCubit;
  final AuthCubit _authCubit;

  MainCubit(this._locationCubit, this._authCubit) : super(const MainState()) {
    _startup();
  }

  Future<void> _startup() async {
    // Kick off location pipeline concurrently with auth check.
    // Neither blocks the other.
    await Future.wait([_locationCubit.init(), _checkAuth()]);
    emit(state.copyWith(pages: _screens, scaffoldKey: _scaffoldKey));
  }

  Future<void> _checkAuth() async {
    // TODO: implement auth flow here
  }

  void navigate(int value) => emit(state.copyWith(navigationIndex: value));
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final List<Widget> _screens = [
  BlocProvider.value(
    value: Dependencies.homeCubit,
    child: Home(scaffoldKey: _scaffoldKey),
  ),
  BlocProvider.value(value: Dependencies.messageCubit, child: MessagesPage()),
  BlocProvider.value(value: Dependencies.savedCubit, child: SavedPage()),
  BlocProvider.value(value: Dependencies.settingsCubit, child: SettingsPage()),
];
