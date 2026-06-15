import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verirent/core/di/agents_di.dart';
import 'package:verirent/core/route/agents_route.dart';
import 'package:verirent/core/theme/agents_theme.dart';

import 'core/shared/location/ui/cubit/location_cubit.dart';
import 'features/home/ui/cubit/home_cubit.dart';
import 'features/search/ui/cubit/search_cubit.dart';
import 'features/shell/ui/cubit/main_cubit.dart';

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
        BlocProvider(create: (_) => GetIt.I<HomeCubit>()),
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider.value(value: GetIt.I<LocationCubit>()),
        BlocProvider(create: (_) => GetIt.I<MainCubit>()),
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
    return MaterialApp.router(
      title: "Agents-NG",
      color: Colors.transparent,
      darkTheme: AgentsTheme.dark.copyWith(
        extensions: [VeriRentExtension.dark],
      ),
      theme: AgentsTheme.light.copyWith(extensions: [VeriRentExtension.light]),
      themeMode: ThemeMode.system,
      routerConfig: agentNgRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
