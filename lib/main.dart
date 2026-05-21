import 'package:flutter/material.dart';
import 'package:verirent/core/di/verirent_di.dart';
import 'package:verirent/core/route/verrirent_route.dart';
import 'package:verirent/core/theme/verirent_theme.dart';

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
      darkTheme: AgentsTheme.dark,
      theme: AgentsTheme.light,
      themeMode: ThemeMode.system,
      routerConfig: VeriRentRoute.router,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: true,
      showSemanticsDebugger: true,
      showPerformanceOverlay: true,
    );
  }
}
