import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_api_model.freezed.dart';
part 'weather_api_model.g.dart';

@freezed
abstract class WeatherApiModel with _$WeatherApiModel {
  const factory WeatherApiModel({
    /// The latitude of the location.
    required double latitude,

    /// The longitude of the location.
    required double longitude,

    /// The generation time of the data in milliseconds.
    @JsonKey(name: 'generationtime_ms') required double generationTimeMs,

    /// The UTC offset in seconds.
    @JsonKey(name: 'utc_offset_seconds') required int utcOffsetSeconds,

    /// The timezone of the location.
    required String timezone,

    /// The abbreviation of the timezone.
    @JsonKey(name: 'timezone_abbreviation')
    required String timezoneAbbreviation,

    /// The elevation used for statistical downscaling.
    required double elevation,

    /// The units of the daily data.
    @JsonKey(name: 'daily_units') required DailyUnits dailyUnits,

    /// The daily weather data.
    required Daily daily,
  }) = _WeatherApiModel;

  factory WeatherApiModel.fromJson(Map<String, Object?> json) =>
      _$WeatherApiModelFromJson(json);
}

@freezed
abstract class DailyUnits with _$DailyUnits {
  const factory DailyUnits({
    /// The date
    required String time,

    /// The unit for the maximum temperature at 2 meters above ground level.
    @JsonKey(name: 'temperature_2m_max') required String temperature2mMax,

    /// The unit for the minimum temperature at 2 meters above ground level.
    @JsonKey(name: 'temperature_2m_min') required String temperature2mMin,

    /// The unit for the sum of daily precipitation (including rain, showers and snowfall).
    @JsonKey(name: 'precipitation_sum') required String precipitationSum,
  }) = _DailyUnits;

  factory DailyUnits.fromJson(Map<String, Object?> json) =>
      _$DailyUnitsFromJson(json);
}

@freezed
abstract class Daily with _$Daily {
  const factory Daily({
    /// The date
    required List<String> time,

    /// The maximum temperature at 2 meters above ground level in degrees Celsius.
    @JsonKey(name: 'temperature_2m_max') required List<double> temperature2mMax,

    /// The minimum temperature at 2 meters above ground level in degrees Celsius.
    @JsonKey(name: 'temperature_2m_min') required List<double> temperature2mMin,

    /// Sum of daily precipitation (including rain, showers and snowfall) in millimeters.
    @JsonKey(name: 'precipitation_sum') required List<double> precipitationSum,
  }) = _Daily;

  factory Daily.fromJson(Map<String, Object?> json) => _$DailyFromJson(json);
}
