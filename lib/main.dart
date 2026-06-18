import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verirent/core/di/agents_di.dart';
import 'package:verirent/core/route/agents_route.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import 'core/shared/location/ui/cubit/location_cubit.dart';
import 'features/search/ui/cubit/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  HydratedBloc.storage = storage;
  await registerServices();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider.value(value: GetIt.I<LocationCubit>()),
      ],
      child: const App(),
    ),
  );
}

/// Main application
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: "Agents-NG",
            color: Colors.transparent,
            darkTheme: AgentsTheme.dark.copyWith(
              extensions: [VeriRentExtension.dark],
            ),
            theme: AgentsTheme.light.copyWith(
              extensions: [VeriRentExtension.light],
            ),
            themeMode: settingsState.themeMode,
            routerConfig: agentNgRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
