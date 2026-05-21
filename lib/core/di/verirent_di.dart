import 'package:get_it/get_it.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';

final GetIt _getIt = GetIt.instance;

///  this function register all services, repositories or Cubits present in this
Future<void> registerServices() async {
  _getIt.registerSingleton<HomeCubit>(HomeCubit());
}
