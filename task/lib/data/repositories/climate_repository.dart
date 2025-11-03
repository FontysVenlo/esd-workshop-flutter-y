import 'package:fpdart/fpdart.dart' show Either;

import '../services/api/api_client.dart';
import '../services/api/model/weather_api_model.dart';

abstract class ClimateRepository {
  Future<Either<String, WeatherApiModel>> getWeather(double latitude, double longitude);
}

class ClimateRepositoryImpl implements ClimateRepository {
  ClimateRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Either<String, WeatherApiModel>> getWeather(double latitude, double longitude) {
    return _apiClient.fetchWeather(latitude, longitude);
  }
}
