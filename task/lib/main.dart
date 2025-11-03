import 'package:flutter/material.dart';
import 'config/dependencies.dart';
import 'routing/router.dart';

void main() {
  setupLocator();
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1a237e), // Dark blue background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a237e), // Dark blue header
          foregroundColor: Colors.white, // White text
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1a237e),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          selectedColor: Colors.white,
          selectedTileColor: Color(0xFF283593),
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}