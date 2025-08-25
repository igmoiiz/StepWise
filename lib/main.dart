import 'package:flutter/material.dart';
import 'package:stepwise/presentation/utilities/theme.dart';
import 'package:stepwise/presentation/view/interface/interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StepWise",
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      home: const InterfacePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
