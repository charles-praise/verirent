import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verirent/features/shell/feature/notification/ui/cubit/notification_cubit.dart';

import '../../features/auth/ui/cubit/auth_cubit.dart';
import '../../features/home/cache/home_cache_data_source.dart';
import '../../features/home/features/listing/ui/cubit/listing_details_cubit.dart';
import '../../features/home/features/view/ui/cubit/see_all_cubit.dart';
import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/message/ui/cubit/message_cubit.dart';
import '../../features/profile/ui/cubit/profile_cubit.dart';
import '../../features/saved/ui/cubit/saved_cubit.dart';
import '../../features/search/ui/cubit/search_cubit.dart';
import '../../features/settings/ui/cubit/settings_cubit.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';
import '../repo/api_client.dart';
import '../repo/local_repo.dart';
import '../service/auth_service.dart';
import '../service/auth_service_impl.dart';
import '../service/secure_storage_service.dart';
import '../service/secure_storage_service_impl.dart';
import '../service/token_refresh.dart';
import '../service/token_refresh_service_impl.dart';
import '../shared/location/ui/cubit/location_cubit.dart';

Future<void> injection() async {
  final GetIt getIt = GetIt.I;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  // ── Cache layer (Hive) ────────────────────────────────────────────
  await Hive.initFlutter();
  final homeCache = HomeCacheDataSource();
  await homeCache.init();
  getIt.registerLazySingleton<HomeCacheDataSource>(() => homeCache);

  // ── Infrastructure ────────────────────────────────────────────────
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

  // ── Auth (singleton — needed early for routing) ───────────────────
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      authService: getIt<AuthService>(),
      secureStorage: getIt<SecureStorageService>(),
      tokenRefreshService: getIt<TokenRefreshService>(),
    ),
  );

  // ── Location (must be before MainCubit) ───────────────────────────
  getIt.registerSingleton<LocationCubit>(LocationCubit());

  // ── Shell ─────────────────────────────────────────────────────────
  getIt.registerFactory<MainCubit>(() => MainCubit(getIt<LocationCubit>()));

  // ── Data layer (must be before HomeCubit) ─────────────────────────
  getIt.registerLazySingleton<LocalRepository>(
    () => LocalRepoImpl(cache: getIt<HomeCacheDataSource>()),
  );

  // ── Feature cubits ────────────────────────────────────────────────
  getIt.registerFactory<HomeCubit>(() => HomeCubit(GetIt.I<LocalRepository>()));
  getIt.registerSingleton<SearchCubit>(SearchCubit());
  getIt.registerSingleton<ProfileCubit>(ProfileCubit());
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerSingleton<ListingDetailsCubit>(ListingDetailsCubit());
  getIt.registerSingleton<SavedCubit>(SavedCubit());
  getIt.registerSingleton<SeeAllCubit>(SeeAllCubit());
  getIt.registerSingleton<MessagesCubit>(MessagesCubit());
  getIt.registerSingleton<NotificationCubit>(NotificationCubit());

  await getIt<AuthCubit>().initialise();
}
