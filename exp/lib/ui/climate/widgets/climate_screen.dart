import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../view_model/climate_view_model.dart';
import 'climate_diagram.dart';
import 'floating_map_widget.dart';

class ClimateScreen extends StatelessWidget with WatchItMixin {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLocation = watchPropertyValue(
          (ClimateViewModel vm) => vm.selectedLocation,
    );
    final locations = watchPropertyValue((ClimateViewModel vm) => vm.locations);
    final isLoading = watchPropertyValue((ClimateViewModel vm) => vm.isLoading);
    final errorMessage = watchPropertyValue(
          (ClimateViewModel vm) => vm.errorMessage,
    );
    final climateData = watchPropertyValue(
          (ClimateViewModel vm) => vm.climateData,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Climate Data - $selectedLocation',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            onPressed: () => _showAddLocationDialog(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1a237e),
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF283593),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Select Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ...locations.keys.map(
                    (location) => ListTile(
                  leading: const Icon(Icons.place, color: Colors.white70),
                  title: Text(
                    location,
                    style: const TextStyle(color: Colors.white),
                  ),
                  selected: location == selectedLocation,
                  selectedTileColor: const Color(0xFF283593),
                  onTap: () {
                    sl<ClimateViewModel>().selectLocation(location);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            color: const Color(0xFF1a237e),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : errorMessage != null
                  ? Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              )
                  : climateData != null
                  ? const ClimateDiagram()
                  : const Text(
                'Select a location to view climate data',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          // Floating map widget
          if (climateData != null && !isLoading)
            const Positioned(
              bottom: 16,
              right: 16,
              child: FloatingMapWidget(),
            ),
        ],
      ),
    );
  }

  Future<void> _showAddLocationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final latController = TextEditingController();
    final lonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Add New Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Location Name',
                hintText: 'e.g., London',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'e.g., 51.5074',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'e.g., -0.1278',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final lat = double.tryParse(latController.text);
              final lon = double.tryParse(lonController.text);

              if (name.isNotEmpty && lat != null && lon != null) {
                if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
                  sl<ClimateViewModel>().addLocation(name, lat, lon);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid coordinates. Please check the values.'),
                    ),
                  );
                }
              }
            },
            child: const Text('Add Location'),
          ),
        ],
      ),
    );
  }
}