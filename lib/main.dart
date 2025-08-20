import 'package:flutter/material.dart';
import 'package:auraflow/theme.dart';
import 'package:auraflow/screens/focus_timer_screen.dart';

void main() {
  runApp(const AuraFlowApp());
}

class AuraFlowApp extends StatelessWidget {
  const AuraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraFlow - Focus Timer',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const FocusTimerScreen(),
    );
  }
}
