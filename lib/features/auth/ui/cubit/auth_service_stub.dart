




// ─────────────────────────────────────────────────────────────────────────────
// GetIt registration snippet — add to lib/core/di/injection.dart
// ─────────────────────────────────────────────────────────────────────────────
//
// await HydratedBloc.storage = await HydratedStorage.build(
//   storageDirectory: await getApplicationDocumentsDirectory(),
// );
//
// getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(getIt()));
// getIt.registerLazySingleton<SecureStorageService>(
//   () => SecureStorageServiceImpl(),
// );
// getIt.registerLazySingleton<TokenRefreshService>(
//   () => TokenRefreshServiceImpl(getIt()),
// );
// getIt.registerLazySingleton<AuthCubit>(
//   () => AuthCubit(
//     authService: getIt(),
//     secureStorage: getIt(),
//     tokenRefreshService: getIt(),
//   ),
// );
//
// Then in main():
//   await getIt<AuthCubit>().initialise();
