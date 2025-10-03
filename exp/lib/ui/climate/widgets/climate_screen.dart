import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../view_model/climate_view_model.dart';
import 'climate_diagram.dart';

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
        title: Text(selectedLocation),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddLocationDialog(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Select Location',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...locations.keys.map(
              (location) => ListTile(
                title: Text(location),
                selected: location == selectedLocation,
                onTap: () {
                  sl<ClimateViewModel>().selectLocation(location);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
            ? Text(errorMessage)
            : climateData != null
            ? const ClimateDiagram()
            : const Text('Select a location to view climate data'),
      ),
    );
  }

  Future<void> _showAddLocationDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final latController = TextEditingController();
    final lonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: latController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final lat = double.tryParse(latController.text);
              final lon = double.tryParse(lonController.text);

              if (name.isNotEmpty && lat != null && lon != null) {
                sl<ClimateViewModel>().addLocation(name, lat, lon);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
