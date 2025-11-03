import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../../../data/repositories/climate_repository.dart';
import '../../../data/services/api/model/weather_api_model.dart';
import '../../../domain/models/location.dart';

class ClimateViewModel extends SafeChangeNotifier {
  ClimateViewModel({required ClimateRepository climateRepository}) : _climateRepository = climateRepository {
    _initializeDefaultLocations();
    fetchClimateData();
  }

  final ClimateRepository _climateRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  WeatherApiModel? _climateData;
  WeatherApiModel? get climateData => _climateData;

  String _selectedLocation = 'Fontys Venlo';
  String get selectedLocation => _selectedLocation;

  final Map<String, Location> _locations = {};
  Map<String, Location> get locations => Map.unmodifiable(_locations);

  void _initializeDefaultLocations() {
    addLocation('Fontys Venlo', 51.3544, 6.1540);
    addLocation('Fontys Eindhoven', 51.4517, 5.4804);
    addLocation('Fontys Tilburg', 51.538900, 5.077889);
    addLocation('Brocken', 51.7992, 10.6183);
    addLocation('Berlin', 52.5200, 13.4050);
    addLocation('Munich', 48.1351, 11.5820);
    addLocation('Hamburg', 53.5511, 9.9937);
    addLocation('Frankfurt', 50.1109, 8.6821);
  }

  void addLocation(String name, double latitude, double longitude) {
    _locations[name] = Location(name: name, latitude: latitude, longitude: longitude);
    notifyListeners();
  }

  void selectLocation(String name) {
    if (_locations.containsKey(name)) {
      _selectedLocation = name;
      fetchClimateData();
      notifyListeners();
    }
  }

  Future<void> fetchClimateData() async {
    if (!_locations.containsKey(_selectedLocation)) return;

    _isLoading = true;
    _errorMessage = null;
    _climateData = null;
    notifyListeners();

    final location = _locations[_selectedLocation]!;

    final result = await _climateRepository.getWeather(location.latitude, location.longitude);

    result.match(
      (error) {
        _errorMessage = error;
        _climateData = null;
      },
      (data) {
        _climateData = data;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
