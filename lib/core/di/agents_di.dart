import 'package:get_it/get_it.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';
import 'package:verirent/features/auth/ui/cubit/auth_cubit.dart';
import 'package:verirent/features/home/features/listing_details/ui/cubit/listing_details_cubit.dart';
import 'package:verirent/features/message/ui/cubit/message_cubit.dart';
import 'package:verirent/features/saved/ui/cubit/saved_cubit.dart';
import 'package:verirent/features/search/ui/cubit/search_cubit.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import '../../features/home/features/see_all/ui/cubit/see_all_cubit.dart';
import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/profile/ui/cubit/profile_cubit.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';

final GetIt _getIt = GetIt.I;

///  this function register all services, repositories or Cubits present in this
Future<void> registerServices() async {
  // Location Cubit
  _getIt.registerSingleton<LocationCubit>(LocationCubit());
  // AppCubit
  _getIt.registerFactory<MainCubit>(() => MainCubit(_getIt<LocationCubit>()));
  // HomeCubit
  _getIt.registerSingleton<HomeCubit>(HomeCubit());
  //AuthCubit
  _getIt.registerSingleton<AuthCubit>(AuthCubit());
  //SearchCubit
  _getIt.registerSingleton<SearchCubit>(SearchCubit());
  // ProfileCubit
  _getIt.registerSingleton<ProfileCubit>(ProfileCubit());
  // Settings Cubit
  _getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  //Details Cubit
  _getIt.registerSingleton<ListingDetailsCubit>(ListingDetailsCubit());
  // Messages Cubit
  _getIt.registerSingleton<MessagesCubit>(MessagesCubit()).loadThreads();
  // Saved Cubit
  _getIt.registerSingleton<SavedCubit>(SavedCubit()).loadSaved();
  // Sell All
  _getIt.registerSingleton<SeeAllCubit>(SeeAllCubit());
}
