import 'package:daily_amol/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'service/AppColors.dart';

class DailyAmolApp extends StatelessWidget {
  const DailyAmolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'প্রতিদিনের আমল',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'kalpurush',
        scaffoldBackgroundColor: AppColors.secondary,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 96),
          displayMedium: TextStyle(fontSize: 60),
          displaySmall: TextStyle(fontSize: 48),
          headlineMedium: TextStyle(fontSize: 34),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 20),
          titleMedium: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 14),
          labelLarge: TextStyle(fontSize: 14),
          labelSmall: TextStyle(fontSize: 12),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
