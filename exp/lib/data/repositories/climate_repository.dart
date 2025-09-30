import 'package:fpdart/fpdart.dart' show Either;
import 'package:watch_it/watch_it.dart' show sl;

import '../services/api/api_client.dart';
import '../services/api/model/weather_api_model.dart';

abstract class ClimateRepository {
  Future<Either<String, WeatherApiModel>> getWeather(double latitude, double longitude);
}

class ClimateRepositoryImpl implements ClimateRepository {
  @override
  Future<Either<String, WeatherApiModel>> getWeather(double latitude, double longitude) {
    return sl<ApiClient>().fetchWeather(latitude, longitude);
  }
}
