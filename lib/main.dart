import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/core/route/router.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import 'features/search/ui/cubit/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injection();
  GetIt.I<LocationCubit>();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => GetIt.I<SearchCubit>())],
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
