import 'package:flutter/material.dart';
import 'app/shell/app_shell.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuickEditApp());
}

class QuickEditApp extends StatelessWidget {
  const QuickEditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickEdit — Video Editing Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
