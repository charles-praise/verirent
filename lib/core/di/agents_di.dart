import 'package:get_it/get_it.dart';
import 'package:verirent/features/auth/ui/cubit/auth_cubit.dart';

import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';

final GetIt _getIt = GetIt.instance;

///  this function register all services, repositories or Cubits present in this
Future<void> registerServices() async {
  // AppCubit
  _getIt.registerSingleton<MainCubit>(MainCubit());
  // HomeCubit
  _getIt.registerSingleton<HomeCubit>(HomeCubit());
  //AuthCubit
  _getIt.registerSingleton<AuthCubit>(AuthCubit());
}
