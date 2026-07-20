import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verirent/features/shell/feature/notification/ui/cubit/notification_cubit.dart';

import '../../features/auth/domain/service/auth_service/auth_service.dart';
import '../../features/auth/domain/service/auth_service/auth_service_impl.dart';
import '../../features/auth/domain/service/secure_storage_service/secure_storage_service.dart';
import '../../features/auth/domain/service/secure_storage_service/secure_storage_service_impl.dart';
import '../../features/auth/domain/service/token_refresh_service/token_refresh.dart';
import '../../features/auth/domain/service/token_refresh_service/token_refresh_service_impl.dart';
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
import '../shared/location/ui/cubit/location_cubit.dart';

class Dependencies {
  static final main = GetIt.I<MainCubit>();
  static final locationCubit = GetIt.I<LocationCubit>();
  static final localRepository = GetIt.I<LocalRepository>();
  static final homeCubit = GetIt.I<HomeCubit>();
  static final profileCubit = GetIt.I<ProfileCubit>();
  static final settingsCubit = GetIt.I<SettingsCubit>();
  static final listingDetailsCubit = GetIt.I<ListingDetailsCubit>();
  static final savedCubit = GetIt.I<SavedCubit>();
  static final searchCubit = GetIt.I<SearchCubit>();
  static final seeAllCubit = GetIt.I<SeeAllCubit>();
  static final messageCubit = GetIt.I<MessagesCubit>();
  static final notificationCubit = GetIt.I<NotificationCubit>();
  static final authCubit = GetIt.I<AuthCubit>();
  static final homeCacheDataSource = GetIt.I<HomeCacheDataSource>();
  static final apiClient = GetIt.I<ApiClient>();
  static final authService = GetIt.I<AuthService>();
  static final secureStorageService = GetIt.I<SecureStorageService>();
  static final tokenRefreshService = GetIt.I<TokenRefreshService>();
}

Future<void> injection() async {
  final GetIt getIt = GetIt.I;

  // ── Hydrated Bloc Storage   ────────────────────────────────────────────
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
    () => AuthServiceImpl(Dependencies.apiClient),
  );
  getIt.registerLazySingleton<TokenRefreshService>(
    () => TokenRefreshServiceImpl(Dependencies.apiClient),
  );

  // ── Auth (singleton — needed early for routing) ───────────────────
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      authService: Dependencies.authService,
      secureStorage: Dependencies.secureStorageService,
      tokenRefreshService: Dependencies.tokenRefreshService,
    ),
  );

  // ── Location (must be before MainCubit) ───────────────────────────
  getIt.registerSingleton<LocationCubit>(LocationCubit());

  // ── Main ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<MainCubit>(
    () => MainCubit(Dependencies.locationCubit, Dependencies.authCubit),
  );

  // ── Data layer (must be before HomeCubit) ─────────────────────────
  getIt.registerLazySingleton<LocalRepository>(
    () => LocalRepoImpl(cache: Dependencies.homeCacheDataSource),
  );

  // ── Feature cubits ────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(Dependencies.localRepository),
  );
  getIt.registerFactory<SearchCubit>(() => SearchCubit());
  getIt.registerSingleton<ProfileCubit>(ProfileCubit());
  getIt.registerSingleton<SettingsCubit>(SettingsCubit());
  getIt.registerFactory<ListingDetailsCubit>(() => ListingDetailsCubit());
  getIt.registerSingleton<SavedCubit>(SavedCubit());
  getIt.registerFactory<SeeAllCubit>(() => SeeAllCubit());
  getIt.registerSingleton<MessagesCubit>(MessagesCubit(Dependencies.authCubit));
  getIt.registerSingleton<NotificationCubit>(NotificationCubit());

  Dependencies.locationCubit;
  await Dependencies.authCubit.initialise();
}
