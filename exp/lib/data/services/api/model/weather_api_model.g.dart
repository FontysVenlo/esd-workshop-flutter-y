// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherApiModel _$WeatherApiModelFromJson(Map<String, dynamic> json) =>
    _WeatherApiModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      generationTimeMs: (json['generationtime_ms'] as num).toDouble(),
      utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
      timezone: json['timezone'] as String,
      timezoneAbbreviation: json['timezone_abbreviation'] as String,
      elevation: (json['elevation'] as num).toDouble(),
      dailyUnits: DailyUnits.fromJson(
        json['daily_units'] as Map<String, dynamic>,
      ),
      daily: Daily.fromJson(json['daily'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherApiModelToJson(_WeatherApiModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'generationtime_ms': instance.generationTimeMs,
      'utc_offset_seconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'timezone_abbreviation': instance.timezoneAbbreviation,
      'elevation': instance.elevation,
      'daily_units': instance.dailyUnits,
      'daily': instance.daily,
    };

_DailyUnits _$DailyUnitsFromJson(Map<String, dynamic> json) => _DailyUnits(
  time: json['time'] as String,
  temperature2mMax: json['temperature_2m_max'] as String,
  temperature2mMin: json['temperature_2m_min'] as String,
  precipitationSum: json['precipitation_sum'] as String,
);

Map<String, dynamic> _$DailyUnitsToJson(_DailyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m_max': instance.temperature2mMax,
      'temperature_2m_min': instance.temperature2mMin,
      'precipitation_sum': instance.precipitationSum,
    };

_Daily _$DailyFromJson(Map<String, dynamic> json) => _Daily(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature2mMax: (json['temperature_2m_max'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  temperature2mMin: (json['temperature_2m_min'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  precipitationSum: (json['precipitation_sum'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$DailyToJson(_Daily instance) => <String, dynamic>{
  'time': instance.time,
  'temperature_2m_max': instance.temperature2mMax,
  'temperature_2m_min': instance.temperature2mMin,
  'precipitation_sum': instance.precipitationSum,
};
