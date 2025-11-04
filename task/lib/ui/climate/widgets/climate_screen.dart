// ignore_for_file: prefer-single-widget-per-file

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:climate_diagrams/domain/models/location.dart';
import 'package:climate_diagrams/ui/climate/view_model/climate_view_model.dart';
import 'package:climate_diagrams/ui/climate/widgets/climate_diagram.dart';
import 'package:climate_diagrams/ui/climate/widgets/floating_map_widget.dart';

class ClimateScreen extends StatelessWidget with WatchItMixin {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only watch properties needed for AppBar and Drawer
    final selectedLocation = watchPropertyValue((ClimateViewModel vm) => vm.selectedLocation);
    final locations = watchPropertyValue((ClimateViewModel vm) => vm.locations);

    return Scaffold(
      appBar: AppBar(
        // Custom leading button for faster response
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            // Reduce splash effect for snappier feel
            splashRadius: 20,
          ),
        ),
        title: Text(
          'Climate Data - $selectedLocation',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            onPressed: () => _showAddLocationDialog(context),
            splashRadius: 20,
          ),
        ],
      ),
      drawerScrimColor: Colors.black.withOpacity(0.2),
      drawerEdgeDragWidth: 60,
      drawerEnableOpenDragGesture: true,
      // Pre-built drawer
      drawer: _LocationDrawer(selectedLocation: selectedLocation, locations: locations),
      // Extracted body - only rebuilds when loading/error/data state changes
      body: const _ClimateBody(),
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
              decoration: const InputDecoration(labelText: 'Location Name', hintText: 'e.g., London'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: latController,
              decoration: const InputDecoration(labelText: 'Latitude', hintText: 'e.g., 51.5074'),
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(labelText: 'Longitude', hintText: 'e.g., -0.1278'),
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final lat = double.tryParse(latController.text);
              final lon = double.tryParse(lonController.text);

              if (name.isNotEmpty && lat != null && lon != null) {
                // TODO: Exercise 4 - Add coordinate validation
                // Check: lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
                // If valid: call addLocation and close dialog
                // If invalid: show SnackBar with error message

                sl<ClimateViewModel>().addLocation(name, lat, lon);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Location'),
          ),
        ],
      ),
    );
  }
}

/// Extracted drawer widget that only rebuilds when location data changes
class _LocationDrawer extends StatelessWidget {
  final String selectedLocation;
  final Map<String, Location> locations;

  const _LocationDrawer({required this.selectedLocation, required this.locations});

  @override
  Widget build(BuildContext context) {
    // Pre-calculate everything for instant rendering
    final locationList = locations.keys.toList();

    return Drawer(
      // Narrower drawer = faster animation
      width: 260,
      // Minimal elevation for faster rendering
      elevation: 8,
      child: Material(
        color: const Color(0xFF1a237e),
        // Pre-calculate expensive properties
        child: CustomScrollView(
          // Use custom scroll view for better performance
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // Header as Sliver for better performance
            const SliverToBoxAdapter(
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF283593)),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Select Location',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Location list as Sliver for better scrolling performance
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final location = locationList[index];
                final isSelected = location == selectedLocation;

                return Material(
                  color: isSelected ? const Color(0xFF283593) : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      sl<ClimateViewModel>().selectLocation(location);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.place, color: isSelected ? Colors.white : Colors.white70, size: 20),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: locationList.length),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extracted body widget that only rebuilds when data state changes
class _ClimateBody extends StatelessWidget with WatchItMixin {
  const _ClimateBody();

  @override
  Widget build(BuildContext context) {
    // Only watch properties needed for body content
    final isLoading = watchPropertyValue((ClimateViewModel vm) => vm.isLoading);
    final errorMessage = watchPropertyValue((ClimateViewModel vm) => vm.errorMessage);
    final climateData = watchPropertyValue((ClimateViewModel vm) => vm.climateData);

    return Stack(
      children: [
        // Main content
        Container(
          color: const Color(0xFF1a237e),
          child: const Center(
            child: Placeholder(),

            // TODO: Exercise 3
            // Use nested ternary operators:
            // isLoading ? LoadingWidget : (errorMessage != null ? ErrorWidget : ...)

            // Widget templates:
            // Loading: const CircularProgressIndicator(color: Colors.white)
            // Error: Text(errorMessage, style: const TextStyle(color: Colors.white))
            // Success: const ClimateDiagram()
            // Empty: const Text('Select a location to view climate data',
            //                    style: TextStyle(color: Colors.white70))
          ),
        ),
        // Floating map widget
        if (climateData != null && !isLoading) const Positioned(bottom: 16, right: 16, child: FloatingMapWidget()),
      ],
    );
  }

  Future<void> _showAddLocationDialog(BuildContext context) async {
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
              decoration: const InputDecoration(labelText: 'Location Name', hintText: 'e.g., London'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: latController,
              decoration: const InputDecoration(labelText: 'Latitude', hintText: 'e.g., 51.5074'),
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(labelText: 'Longitude', hintText: 'e.g., -0.1278'),
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Invalid coordinates. Please check the values.')));
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
