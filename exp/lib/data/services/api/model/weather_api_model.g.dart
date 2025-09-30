// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherApiModel _$WeatherApiModelFromJson(Map<String, dynamic> json) =>
    _WeatherApiModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      generationTimeMs: (json['generationTimeMs'] as num).toDouble(),
      utcOffsetSeconds: (json['utcOffsetSeconds'] as num).toInt(),
      timezone: json['timezone'] as String,
      timezoneAbbreviation: json['timezoneAbbreviation'] as String,
      elevation: (json['elevation'] as num).toDouble(),
      dailyUnits: DailyUnits.fromJson(
        json['dailyUnits'] as Map<String, dynamic>,
      ),
      daily: Daily.fromJson(json['daily'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherApiModelToJson(_WeatherApiModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'generationTimeMs': instance.generationTimeMs,
      'utcOffsetSeconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'timezoneAbbreviation': instance.timezoneAbbreviation,
      'elevation': instance.elevation,
      'dailyUnits': instance.dailyUnits,
      'daily': instance.daily,
    };

_DailyUnits _$DailyUnitsFromJson(Map<String, dynamic> json) => _DailyUnits(
  time: json['time'] as String,
  temperature2mMax: json['temperature2mMax'] as String,
  temperature2mMin: json['temperature2mMin'] as String,
  precipitationSum: json['precipitationSum'] as String,
);

Map<String, dynamic> _$DailyUnitsToJson(_DailyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature2mMax': instance.temperature2mMax,
      'temperature2mMin': instance.temperature2mMin,
      'precipitationSum': instance.precipitationSum,
    };

_Daily _$DailyFromJson(Map<String, dynamic> json) => _Daily(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature2mMax: (json['temperature2mMax'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  temperature2mMin: (json['temperature2mMin'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  precipitationSum: (json['precipitationSum'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$DailyToJson(_Daily instance) => <String, dynamic>{
  'time': instance.time,
  'temperature2mMax': instance.temperature2mMax,
  'temperature2mMin': instance.temperature2mMin,
  'precipitationSum': instance.precipitationSum,
};
