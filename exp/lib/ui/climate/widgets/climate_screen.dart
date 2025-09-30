import 'package:flutter/material.dart';

class ClimateScreen extends StatelessWidget {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Climate Diagrams')),
      body: const Center(child: Text('Weather data will be displayed here.')),
    );
  }
}
