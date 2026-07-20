import 'package:flutter/material.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import 'features/router/app_router.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await injection();
    runApp(const App());
  } catch (e) {
    throw ('$e');
  }
}

// ── Main Application   ────────────────────────────────────────────
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingCubit = Dependencies.settingsCubit;
    return MaterialApp.router(
      title: "Agents-NG",
      color: Colors.transparent,
      darkTheme: AgentsTheme.dark.copyWith(
        extensions: [VeriRentExtension.dark],
      ),
      theme: AgentsTheme.light.copyWith(extensions: [VeriRentExtension.light]),
      themeMode: settingCubit.state.themeMode,
      routerConfig: agentNgRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
