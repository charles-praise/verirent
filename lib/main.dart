import 'package:flutter/material.dart';
import 'package:verirent/core/di/agents_di.dart';
import 'package:verirent/core/route/agents_route.dart';
import 'package:verirent/core/theme/agents_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerServices();
  runApp(const App());
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
      routerConfig: VeriRentRoute.router,
      debugShowCheckedModeBanner: true,
    );
  }
}
