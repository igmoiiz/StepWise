import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stepwise/firebase_options.dart';
import 'package:stepwise/presentation/utilities/theme.dart';
import 'package:stepwise/presentation/view/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
