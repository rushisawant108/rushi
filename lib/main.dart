import 'package:flutter/material.dart';
import 'theme/theme.dart'; // Correctly importing your theme
import 'screen/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Applying custom global theme
      home: const DashboardScreen(),
    );
  }
}
