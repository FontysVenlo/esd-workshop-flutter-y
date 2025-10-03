import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;

import 'model/weather_api_model.dart';

class ApiClient {
  Future<Either<String, WeatherApiModel>> fetchWeather(
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
      'start_date=${DateFormat('yyyy-MM-dd').format(startDate)}&'
      'end_date=${DateFormat('yyyy-MM-dd').format(endDate)}&'
      'daily=temperature_2m_max,temperature_2m_min,precipitation_sum&'
      'timezone=Europe/Berlin',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final weatherData = WeatherApiModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.body) as Map),
        );
        return Either.right(weatherData);
      } else {
        return Either.left('Invalid response: ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      return Either.left('Failed to fetch weather data: $e');
    }
  }
}
