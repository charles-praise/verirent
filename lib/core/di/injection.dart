import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verirent/core/repo/local_repo.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';
import 'package:verirent/features/home/features/listing/ui/cubit/listing_details_cubit.dart';
import 'package:verirent/features/message/ui/cubit/message_cubit.dart';
import 'package:verirent/features/saved/ui/cubit/saved_cubit.dart';
import 'package:verirent/features/search/ui/cubit/search_cubit.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import '../../features/auth/ui/cubit/auth_cubit.dart';
import '../../features/home/domain/use_case/listing_use_cases.dart';
import '../../features/home/features/view/ui/cubit/see_all_cubit.dart';
import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/profile/ui/cubit/profile_cubit.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';
import '../repo/api_client.dart';
import '../service/auth_service.dart';
import '../service/auth_service_impl.dart';
import '../service/secure_storage_service.dart';
import '../service/secure_storage_service_impl.dart';
import '../service/token_refresh.dart';
import '../service/token_refresh_service_impl.dart';

Future<void> injection() async {
  final GetIt getIt = GetIt.I;
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.verirent.ng/v1',
      ),
    ),
  );
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TokenRefreshService>(
    () => TokenRefreshServiceImpl(getIt<ApiClient>()),
  );
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      authService: getIt<AuthService>(),
      secureStorage: getIt<SecureStorageService>(),
      tokenRefreshService: getIt<TokenRefreshService>(),
    ),
  );
  getIt.registerLazySingleton<GetPropertiesUseCase>(
    () => GetPropertiesUseCase(getIt<LocalRepository>()),
  );
  getIt.registerLazySingleton<LocalRepository>(() => LocalRepoImpl());
  getIt.registerFactory<MainCubit>(() => MainCubit(getIt<LocationCubit>()));
  getIt.registerSingleton<LocationCubit>(LocationCubit());
  getIt.registerSingleton<MessagesCubit>(MessagesCubit());
  getIt.registerSingleton<HomeCubit>(HomeCubit());
  getIt.registerSingleton<SearchCubit>(SearchCubit());
  getIt.registerSingleton<ProfileCubit>(ProfileCubit());
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerSingleton<ListingDetailsCubit>(ListingDetailsCubit());
  getIt.registerSingleton<SavedCubit>(SavedCubit());
  getIt.registerSingleton<SeeAllCubit>(SeeAllCubit());

  await getIt<AuthCubit>().initialise();
}
