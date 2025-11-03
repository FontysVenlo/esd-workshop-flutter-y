# exp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Workshop Draft

## Climate Diagram Web App

---

**Prerequisites**: Flutter SDK installed, basic Dart knowledge

### What You'll Build
A weather data visualization app that fetches climate data from an API and displays it with interactive charts and a map.

### What You'll Learn
1. HTTP requests and async operations
2. State management with ChangeNotifier
3. Data visualization with fl_chart
4. Form validation and dialogs
5. Map integration with flutter_map

---

## Setup Instructions

### 1. Create Project
```bash
flutter create climate_workshop
cd climate_workshop
```

### 2. Add Dependencies
Update `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  fl_chart: ^0.68.0
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  fpdart: ^1.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run App
```bash
flutter run -d chrome  # For web        # For mobile
```

---

## Background Knowledge

### Flutter Fundamentals

**Widgets**: Everything in Flutter is a widget. Widgets describe what their view should look like given their current configuration and state.

**StatelessWidget**: Immutable widgets that don't maintain state.
- Use for static UI that doesn't change
- Example: Text, Icon, Container with fixed content

**StatefulWidget**: Widgets that maintain mutable state.
- Use when UI needs to change dynamically
- Has lifecycle methods (initState, dispose)
- State changes trigger rebuilds

**Documentation**: [Introduction to widgets](https://docs.flutter.dev/ui/widgets-intro)

### Asynchronous Programming

**Future**: Represents a potential value or error that will be available at some time in the future.

**async/await**: Syntax for working with asynchronous code that makes it look synchronous.

```dart
// Without async/await (callback hell)
fetchData().then((data) => processData(data)).then((result) => display(result));

// With async/await (clean)
final data = await fetchData();
final result = await processData(data);
display(result);
```

**Documentation**: [Asynchronous programming](https://dart.dev/codelabs/async-await)

### State Management

**ChangeNotifier**: A class that can notify listeners when it changes.
- Part of Flutter's foundation library
- Used for simple state management
- Call `notifyListeners()` to trigger UI rebuilds

**Documentation**: [Simple app state management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)

---

## Exercise 1: HTTP Request & Async Operations (5 minutes)

### Background
Modern apps need to fetch data from APIs. Flutter's `http` package makes this straightforward with async/await patterns.

### Objective
Create an API client that fetches weather data from Open-Meteo API.

### Starter Code
Create `lib/api_client.dart`:
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';

class ApiClient {
  Future<Either<String, Map<String, dynamic>>> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    // TODO: Build URL with parameters
    // TODO: Make HTTP GET request
    // TODO: Check status code
    // TODO: Parse JSON response
    // TODO: Return Either.right on success, Either.left on error
  }
}
```

### Implementation Steps

1. **Build the URL** with query parameters:
```dart
final now = DateTime.now();
final startDate = DateTime(now.year - 1, 1, 1);
final endDate = DateTime(now.year - 1, 12, 31);

final url = Uri.parse(
  'https://archive-api.open-meteo.com/v1/era5?'
  'latitude=$latitude&'
  'longitude=$longitude&'
  'start_date=${startDate.toString().split(' ')[0]}&'
  'end_date=${endDate.toString().split(' ')[0]}&'
  'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
  'timezone=auto',
);
```

2. **Make the request** with error handling:
```dart
try {
  final response = await http.get(url);
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Either.right(data);
  } else {
    return Either.left('HTTP ${response.statusCode}: ${response.reasonPhrase}');
  }
} catch (e) {
  return Either.left('Network error: $e');
}
```

### Complete Solution
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';

class ApiClient {
  Future<Either<String, Map<String, dynamic>>> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, 1, 1);
    final endDate = DateTime(now.year - 1, 12, 31);

    final url = Uri.parse(
      'https://archive-api.open-meteo.com/v1/era5?'
      'latitude=$latitude&'
      'longitude=$longitude&'
      'start_date=${startDate.toString().split(' ')[0]}&'
      'end_date=${endDate.toString().split(' ')[0]}&'
      'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
      'timezone=auto',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Either.right(data);
      } else {
        return Either.left('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      return Either.left('Network error: $e');
    }
  }
}
```

### Key Concepts
- **URI building**: Use `Uri.parse()` for proper URL encoding
- **Error handling**: Use Either type instead of throwing exceptions
- **JSON parsing**: `jsonDecode()` converts JSON string to Dart objects
- **async/await**: Makes asynchronous code readable

### Documentation
- [http package](https://pub.dev/packages/http)
- [Fetch data from the internet](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [fpdart Either type](https://pub.dev/packages/fpdart)

---

## Exercise 2: ChangeNotifier State Management (5 minutes)

### Background
ChangeNotifier is Flutter's built-in mechanism for observable state. When state changes, it notifies all listeners to rebuild their UI.

### Objective
Create a ViewModel that manages locations and fetches weather data.

### Starter Code
Create `lib/climate_view_model.dart`:
```dart
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class ClimateViewModel extends ChangeNotifier {
  final ApiClient _apiClient;
  
  ClimateViewModel({required ApiClient apiClient}) : _apiClient = apiClient;

  String _selectedLocation = 'Berlin';
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _weatherData;
  
  final Map<String, Map<String, double>> _locations = {
    'Berlin': {'lat': 52.5200, 'lon': 13.4050},
    'Munich': {'lat': 48.1351, 'lon': 11.5820},
    'Venlo': {'lat': 51.3544, 'lon': 6.1540},
  };

  // TODO: Add getters
  // TODO: Implement selectLocation method
  // TODO: Implement fetchWeatherData method
  // TODO: Call notifyListeners() when state changes
}
```

### Implementation Steps

1. **Add getters** for UI access:
```dart
String get selectedLocation => _selectedLocation;
bool get isLoading => _isLoading;
String? get errorMessage => _errorMessage;
Map<String, dynamic>? get weatherData => _weatherData;
Map<String, Map<String, double>> get locations => Map.unmodifiable(_locations);
```

2. **Implement location selection**:
```dart
void selectLocation(String location) {
  if (_locations.containsKey(location)) {
    _selectedLocation = location;
    fetchWeatherData();
    notifyListeners();
  }
}
```

3. **Fetch weather data** asynchronously:
```dart
Future<void> fetchWeatherData() async {
  final locationData = _locations[_selectedLocation];
  if (locationData == null) return;

  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  final result = await _apiClient.fetchWeather(
    locationData['lat']!,
    locationData['lon']!,
  );

  result.match(
    (error) {
      _errorMessage = error;
      _weatherData = null;
    },
    (data) {
      _weatherData = data;
      _errorMessage = null;
    },
  );

  _isLoading = false;
  notifyListeners();
}
```

### Complete Solution
```dart
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class ClimateViewModel extends ChangeNotifier {
  final ApiClient _apiClient;

  ClimateViewModel({required ApiClient apiClient}) : _apiClient = apiClient {
    fetchWeatherData();
  }

  String _selectedLocation = 'Berlin';
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _weatherData;

  final Map<String, Map<String, double>> _locations = {
    'Berlin': {'lat': 52.5200, 'lon': 13.4050},
    'Munich': {'lat': 48.1351, 'lon': 11.5820},
    'Venlo': {'lat': 51.3544, 'lon': 6.1540},
  };

  String get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get weatherData => _weatherData;
  Map<String, Map<String, double>> get locations => Map.unmodifiable(_locations);

  void selectLocation(String location) {
    if (_locations.containsKey(location)) {
      _selectedLocation = location;
      fetchWeatherData();
      notifyListeners();
    }
  }

  Future<void> fetchWeatherData() async {
    final locationData = _locations[_selectedLocation];
    if (locationData == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _apiClient.fetchWeather(
      locationData['lat']!,
      locationData['lon']!,
    );

    result.match(
      (error) {
        _errorMessage = error;
        _weatherData = null;
      },
      (data) {
        _weatherData = data;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
```

### Key Concepts
- **ChangeNotifier**: Base class for observable objects
- **notifyListeners()**: Triggers UI rebuild in listening widgets
- **Private fields**: Use `_` prefix for internal state
- **Getters**: Expose read-only access to state
- **Async state updates**: Set loading state before/after async operations

### Documentation
- [ChangeNotifier class](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)
- [State management approaches](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

---

## Exercise 3: Line Chart Visualization (5 minutes)

### Background
`fl_chart` is Flutter's most popular charting library, providing beautiful, customizable charts with minimal boilerplate.

### Objective
Create a temperature line chart with max and min temperatures.

### Starter Code
Create `lib/temperature_chart.dart`:
```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TemperatureChart extends StatelessWidget {
  final List<double> maxTemperatures;
  final List<double> minTemperatures;

  const TemperatureChart({
    super.key,
    required this.maxTemperatures,
    required this.minTemperatures,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          // TODO: Configure grid
          // TODO: Configure axes
          // TODO: Add line data for temperatures
        ),
      ),
    );
  }
}
```

### Implementation Steps

1. **Configure grid and borders**:
```dart
gridData: FlGridData(
  show: true,
  drawVerticalLine: false,
  horizontalInterval: 10,
  getDrawingHorizontalLine: (value) {
    return FlLine(
      color: Colors.grey.withOpacity(0.3),
      strokeWidth: 1,
    );
  },
),
borderData: FlBorderData(
  show: true,
  border: Border.all(color: Colors.grey.withOpacity(0.5)),
),
```

2. **Configure axes titles**:
```dart
titlesData: FlTitlesData(
  topTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  rightTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 10,
      getTitlesWidget: (value, meta) {
        return Text(
          '${value.toInt()}°C',
          style: const TextStyle(fontSize: 10),
        );
      },
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 30,
      getTitlesWidget: (value, meta) {
        return Text(
          'Day ${value.toInt()}',
          style: const TextStyle(fontSize: 10),
        );
      },
    ),
  ),
),
```

3. **Add temperature lines**:
```dart
lineBarsData: [
  // Max temperature line
  LineChartBarData(
    spots: List.generate(
      maxTemperatures.length,
      (i) => FlSpot(i.toDouble(), maxTemperatures[i]),
    ),
    isCurved: true,
    color: Colors.red,
    barWidth: 2,
    dotData: const FlDotData(show: false),
  ),
  // Min temperature line
  LineChartBarData(
    spots: List.generate(
      minTemperatures.length,
      (i) => FlSpot(i.toDouble(), minTemperatures[i]),
    ),
    isCurved: true,
    color: Colors.blue,
    barWidth: 2,
    dotData: const FlDotData(show: false),
  ),
],
```

### Complete Solution
```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TemperatureChart extends StatelessWidget {
  final List<double> maxTemperatures;
  final List<double> minTemperatures;

  const TemperatureChart({
    super.key,
    required this.maxTemperatures,
    required this.minTemperatures,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}°C',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    'Day ${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          lineBarsData: [
            // Max temperature line
            LineChartBarData(
              spots: List.generate(
                maxTemperatures.length,
                (i) => FlSpot(i.toDouble(), maxTemperatures[i]),
              ),
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            // Min temperature line
            LineChartBarData(
              spots: List.generate(
                minTemperatures.length,
                (i) => FlSpot(i.toDouble(), minTemperatures[i]),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Key Concepts
- **FlSpot**: Data point with x and y coordinates
- **LineChartBarData**: Configuration for a single line series
- **FlGridData**: Grid line configuration
- **AxisTitles**: Label configuration for axes
- **isCurved**: Smooth curves vs straight lines

### Documentation
- [fl_chart package](https://pub.dev/packages/fl_chart)
- [fl_chart examples](https://github.com/imaNNeo/fl_chart/tree/main/example)
- [LineChart documentation](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md)

---

## Exercise 4: Form Validation & Dialogs (5 minutes)

### Background
Forms are essential for user input. Flutter provides TextEditingController for managing input and built-in validation patterns.

### Objective
Create a dialog to add new locations with validation.

### Starter Code
Create `lib/add_location_dialog.dart`:
```dart
import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  const AddLocationDialog({super.key});

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  @override
  void dispose() {
    // TODO: Dispose controllers
    super.dispose();
  }

  void _submit() {
    // TODO: Validate inputs
    // TODO: Return data if valid
    // TODO: Show error if invalid
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: Add text fields
        ],
      ),
      actions: [
        // TODO: Add buttons
      ],
    );
  }
}
```

### Implementation Steps

1. **Add text fields** with proper configuration:
```dart
TextField(
  controller: _nameController,
  decoration: const InputDecoration(
    labelText: 'Location Name',
    hintText: 'e.g., London',
  ),
),
const SizedBox(height: 16),
TextField(
  controller: _latController,
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
  controller: _lonController,
  decoration: const InputDecoration(
    labelText: 'Longitude',
    hintText: 'e.g., -0.1278',
  ),
  keyboardType: const TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
),
```

2. **Implement validation** logic:
```dart
void _submit() {
  final name = _nameController.text.trim();
  final lat = double.tryParse(_latController.text);
  final lon = double.tryParse(_lonController.text);

  if (name.isEmpty) {
    _showError('Please enter a location name');
    return;
  }

  if (lat == null || lat < -90 || lat > 90) {
    _showError('Latitude must be between -90 and 90');
    return;
  }

  if (lon == null || lon < -180 || lon > 180) {
    _showError('Longitude must be between -180 and 180');
    return;
  }

  Navigator.pop(context, {
    'name': name,
    'lat': lat,
    'lon': lon,
  });
}

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

3. **Add action buttons**:
```dart
actions: [
  TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text('Cancel'),
  ),
  ElevatedButton(
    onPressed: _submit,
    child: const Text('Add Location'),
  ),
],
```

### Complete Solution
```dart
import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  const AddLocationDialog({super.key});

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final lat = double.tryParse(_latController.text);
    final lon = double.tryParse(_lonController.text);

    if (name.isEmpty) {
      _showError('Please enter a location name');
      return;
    }

    if (lat == null || lat < -90 || lat > 90) {
      _showError('Latitude must be between -90 and 90');
      return;
    }

    if (lon == null || lon < -180 || lon > 180) {
      _showError('Longitude must be between -180 and 180');
      return;
    }

    Navigator.pop(context, {
      'name': name,
      'lat': lat,
      'lon': lon,
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Location Name',
              hintText: 'e.g., London',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _latController,
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
            controller: _lonController,
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
          onPressed: _submit,
          child: const Text('Add Location'),
        ),
      ],
    );
  }
}

// Usage:
Future<void> showAddLocationDialog(BuildContext context) async {
  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => const AddLocationDialog(),
  );

  if (result != null) {
    print('New location: ${result['name']} at ${result['lat']}, ${result['lon']}');
  }
}
```

### Key Concepts
- **TextEditingController**: Manages text field state
- **dispose()**: Clean up resources to prevent memory leaks
- **double.tryParse()**: Safe parsing that returns null on error
- **Navigator.pop()**: Close dialog and optionally return data
- **ScaffoldMessenger**: Show temporary messages (SnackBar)

### Documentation
- [TextField class](https://api.flutter.dev/flutter/material/TextField-class.html)
- [Form validation](https://docs.flutter.dev/cookbook/forms/validation)
- [TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
- [AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)

---

## Exercise 5: Map Integration (5 minutes)

### Background
`flutter_map` provides OpenStreetMap integration with markers, overlays, and interactions - perfect for showing location data.

### Objective
Create a map widget that displays the selected location with a marker.

### Starter Code
Create `lib/location_map.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const LocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        options: MapOptions(
          // TODO: Set initial center
          // TODO: Set initial zoom
          // TODO: Configure interactions
        ),
        children: [
          // TODO: Add TileLayer for map tiles
          // TODO: Add MarkerLayer for location marker
        ],
      ),
    );
  }
}
```

### Implementation Steps

1. **Configure map options**:
```dart
options: MapOptions(
  initialCenter: LatLng(latitude, longitude),
  initialZoom: 10.0,
  interactionOptions: const InteractionOptions(
    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  ),
),
```

2. **Add tile layer** (map background):
```dart
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.example.climate_workshop',
),
```

3. **Add marker layer** with custom marker:
```dart
MarkerLayer(
  markers: [
    Marker(
      point: LatLng(latitude, longitude),
      width: 80,
      height: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              locationName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ],
      ),
    ),
  ],
),
```

### Complete Solution
```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const LocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(latitude, longitude),
              initialZoom: 10.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.climate_workshop',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(latitude, longitude),
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            locationName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Key Concepts
- **LatLng**: Geographic coordinate (latitude, longitude)
- **TileLayer**: Displays map tiles from OpenStreetMap
- **MarkerLayer**: Adds interactive markers to the map
- **MapOptions**: Configure zoom, center, and interactions
- **InteractiveFlag**: Control which gestures are enabled

### Documentation
- [flutter_map package](https://pub.dev/packages/flutter_map)
- [flutter_map documentation](https://docs.fleaflet.dev/)
- [latlong2 package](https://pub.dev/packages/latlong2)
- [OpenStreetMap tile usage](https://operations.osmfoundation.org/policies/tiles/)

---

## Putting It All Together

### Main App Structure
Create `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'api_client.dart';
import 'climate_view_model.dart';
import 'temperature_chart.dart';
import 'location_map.dart';
import 'add_location_dialog.dart';

void main() {
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Workshop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1a237e),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a237e),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const ClimateScreen(),
    );
  }
}

class ClimateScreen extends StatefulWidget {
  const ClimateScreen({super.key});

  @override
  State<ClimateScreen> createState() => _ClimateScreenState();
}

class _ClimateScreenState extends State<ClimateScreen> {
  late final ClimateViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ClimateViewModel(apiClient: ApiClient());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Climate Data - ${_viewModel.selectedLocation}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_location_alt),
                onPressed: () => _showAddLocationDialog(),
              ),
            ],
          ),
          drawer: _buildDrawer(),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1a237e),
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF283593)),
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
            ..._viewModel.locations.keys.map(
              (location) => ListTile(
                leading: const Icon(Icons.place, color: Colors.white70),
                title: Text(
                  location,
                  style: const TextStyle(color: Colors.white),
                ),
                selected: location == _viewModel.selectedLocation,
                selectedTileColor: const Color(0xFF283593),
                onTap: () {
                  _viewModel.selectLocation(location);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Text(
          _viewModel.errorMessage!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    final weatherData = _viewModel.weatherData;
    if (weatherData == null) {
      return const Center(
        child: Text(
          'Select a location to view data',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final daily = weatherData['daily'] as Map<String, dynamic>;
    final maxTemps = (daily['temperature_2m_max'] as List).cast<double>();
    final minTemps = (daily['temperature_2m_min'] as List).cast<double>();

    final locationData = _viewModel.locations[_viewModel.selectedLocation]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TemperatureChart(
            maxTemperatures: maxTemps,
            minTemperatures: minTemps,
          ),
          const SizedBox(height: 16),
          LocationMap(
            latitude: locationData['lat']!,
            longitude: locationData['lon']!,
            locationName: _viewModel.selectedLocation,
          ),
        ],
      ),
    );
  }

  Future<void> _showAddLocationDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddLocationDialog(),
    );

    if (result != null) {
      // In a real app, you'd add this to the ViewModel
      // For now, just show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added location: ${result['name']}'),
          ),
        );
      }
    }
  }
}
```

---

## Testing Your App

### Run the App
```bash
flutter run -d chrome
```

### Test Each Feature

1. **API Integration**
    - Select different locations from drawer
    - Verify loading indicator appears
    - Check that data loads successfully

2. **State Management**
    - Switch locations and confirm UI updates
    - Open drawer, verify selected location is highlighted

3. **Chart Visualization**
    - Confirm temperature lines display correctly
    - Check that axes show proper labels
    - Verify chart is responsive to data

4. **Form Validation**
    - Click "Add Location" button
    - Try submitting empty form (should show error)
    - Try invalid coordinates (should show error)
    - Submit valid location (should succeed)

5. **Map Integration**
    - Verify map displays for selected location
    - Check that marker shows location name
    - Test zoom and pan interactions

---

## Common Issues & Solutions

### API Not Loading
**Problem**: No data appears, or error message shows  
**Solutions**:
- Check internet connection
- Verify API URL is correct
- Check browser console for errors
- Ensure coordinates are valid

### Chart Not Displaying
**Problem**: Chart area is blank or shows error  
**Solutions**:
- Verify data format matches expected structure
- Check that lists are not empty
- Ensure proper data types (double, not int)

### Map Tiles Not Loading
**Problem**: Map shows blank or gray tiles  
**Solutions**:
- Check internet connection
- Verify tile URL is correct
- Check OpenStreetMap usage policy compliance
- Try different tile provider if needed

### Controllers Not Disposed
**Problem**: Memory leaks or errors when navigating  
**Solutions**:
- Always call `dispose()` on controllers
- Use `@override` to ensure dispose is called
- Check that super.dispose() is last in dispose method

---

## Key Takeaways

### What You've Learned

1. **Async Programming**: Making HTTP requests with proper error handling using Either pattern

2. **State Management**: Using ChangeNotifier to separate business logic from UI and trigger rebuilds

3. **Data Visualization**: Creating professional charts with fl_chart library

4. **Form Validation**: Implementing robust input validation with user feedback

5. **Map Integration**: Displaying geographic data with interactive maps

### Flutter Core Concepts

- **Widget Tree**: Everything in Flutter is a widget arranged in a tree
- **Immutability**: Widgets are immutable; state changes create new widgets
- **Hot Reload**: See changes instantly without losing app state
- **Composition**: Build complex UIs from simple, reusable widgets
- **Reactive UI**: UI automatically updates when state changes

---

## Next Steps

### Immediate Improvements
1. Add more chart types (precipitation bars, combined chart)
2. Implement persistent storage for custom locations
3. Add pull-to-refresh functionality
4. Create loading skeletons instead of spinner
5. Add error recovery (retry button)

### Advanced Features
1. **Testing**: Write unit tests for ViewModel, widget tests for UI
2. **Animations**: Add smooth transitions between states
3. **Responsive Design**: Adapt layout for different screen sizes
4. **Internationalization**: Support multiple languages
5. **Performance**: Optimize rebuilds, lazy loading

### Learning Resources

**Official Documentation**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Cookbook](https://docs.flutter.dev/cookbook)

**State Management**
- [State management approaches](https://docs.flutter.dev/data-and-backend/state-mgmt/options)
- [Provider package](https://pub.dev/packages/provider)
- [Riverpod package](https://riverpod.dev/)
- [Bloc pattern](https://bloclibrary.dev/)

**Architecture**
- [Flutter app architecture](https://docs.flutter.dev/app-architecture)
- [Clean Architecture in Flutter](https://medium.com/flutter-community/flutter-clean-architecture-b53ce9e19d5a)

**Community**
- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://reddit.com/r/flutterdev)
- [Flutter YouTube Channel](https://www.youtube.com/@flutterdev)

**Practice**
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [DartPad](https://dartpad.dev/) - Online Dart/Flutter editor
- [Flutter Gallery](https://gallery.flutter.dev/) - Example app with source code

---

## Workshop Completion

Congratulations! You've built a functional climate data visualization app in just 25 minutes.

### What Makes This App Production-Ready?

✅ **Error handling** with Either pattern  
✅ **Separation of concerns** with ViewModel  
✅ **User input validation** with helpful error messages  
✅ **Professional UI** with charts and maps  
✅ **Responsive feedback** with loading states

### Continue Your Flutter Journey

The best way to learn Flutter is to build. Take this foundation and:
- Add your own features
- Integrate different APIs
- Experiment with styling
- Share your work with the community

Happy coding! 🚀