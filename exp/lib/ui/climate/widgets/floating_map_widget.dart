import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:watch_it/watch_it.dart';
import '../view_model/climate_view_model.dart';

class FloatingMapWidget extends StatelessWidget with WatchItMixin {
  const FloatingMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLocation = watchPropertyValue(
          (ClimateViewModel vm) => vm.selectedLocation,
    );
    final locations = watchPropertyValue(
          (ClimateViewModel vm) => vm.locations,
    );

    final currentLocation = locations[selectedLocation];
    if (currentLocation == null) return const SizedBox.shrink();

    return Container(
      width: 280,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                currentLocation.latitude,
                currentLocation.longitude,
              ),
              initialZoom: 3.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // Map tiles layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.climate_diagrams',
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.9),
                      BlendMode.dstATop,
                    ),
                    child: tileWidget,
                  );
                },
              ),
              // Marker layer
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      currentLocation.latitude,
                      currentLocation.longitude,
                    ),
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF1a237e),
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Location info overlay
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1a237e).withOpacity(0.9),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedLocation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${currentLocation.latitude.toStringAsFixed(4)}°, ${currentLocation.longitude.toStringAsFixed(4)}°',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Zoom controls

        ],
      ),
    );
  }
}
