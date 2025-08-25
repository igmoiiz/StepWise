import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepwise/firebase_options.dart';
import 'package:stepwise/presentation/utilities/theme.dart';
import 'package:stepwise/presentation/view/interface/interface.dart';
import 'package:stepwise/core/provider/api_provider.dart';
import 'package:stepwise/core/provider/ui_state_provider.dart';
import 'package:stepwise/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ApplicationProgramInterfaceProvider(AppConfig.geminiApiKey),
        ),
        ChangeNotifierProvider(
          create: (_) => UIStateProvider(),
        ),
      ],
      child: Consumer<UIStateProvider>(
        builder: (context, uiState, child) {
          return MaterialApp(
            title: "StepWise",
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: uiState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const InterfacePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
