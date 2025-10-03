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
      theme: ThemeData(primarySwatch: Colors.blue),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
