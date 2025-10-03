// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherApiModel {

/// The latitude of the location.
 double get latitude;/// The longitude of the location.
 double get longitude;/// The generation time of the data in milliseconds.
@JsonKey(name: 'generationtime_ms') double get generationTimeMs;/// The UTC offset in seconds.
@JsonKey(name: 'utc_offset_seconds') int get utcOffsetSeconds;/// The timezone of the location.
 String get timezone;/// The abbreviation of the timezone.
@JsonKey(name: 'timezone_abbreviation') String get timezoneAbbreviation;/// The elevation used for statistical downscaling.
 double get elevation;/// The units of the daily data.
@JsonKey(name: 'daily_units') DailyUnits get dailyUnits;/// The daily weather data.
 Daily get daily;
/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherApiModelCopyWith<WeatherApiModel> get copyWith => _$WeatherApiModelCopyWithImpl<WeatherApiModel>(this as WeatherApiModel, _$identity);

  /// Serializes this WeatherApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherApiModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationTimeMs, generationTimeMs) || other.generationTimeMs == generationTimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationTimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,dailyUnits,daily);

@override
String toString() {
  return 'WeatherApiModel(latitude: $latitude, longitude: $longitude, generationTimeMs: $generationTimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, dailyUnits: $dailyUnits, daily: $daily)';
}


}

/// @nodoc
abstract mixin class $WeatherApiModelCopyWith<$Res>  {
  factory $WeatherApiModelCopyWith(WeatherApiModel value, $Res Function(WeatherApiModel) _then) = _$WeatherApiModelCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationTimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'daily_units') DailyUnits dailyUnits, Daily daily
});


$DailyUnitsCopyWith<$Res> get dailyUnits;$DailyCopyWith<$Res> get daily;

}
/// @nodoc
class _$WeatherApiModelCopyWithImpl<$Res>
    implements $WeatherApiModelCopyWith<$Res> {
  _$WeatherApiModelCopyWithImpl(this._self, this._then);

  final WeatherApiModel _self;
  final $Res Function(WeatherApiModel) _then;

/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? generationTimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? dailyUnits = null,Object? daily = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationTimeMs: null == generationTimeMs ? _self.generationTimeMs : generationTimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as DailyUnits,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as Daily,
  ));
}
/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<$Res> get dailyUnits {
  
  return $DailyUnitsCopyWith<$Res>(_self.dailyUnits, (value) {
    return _then(_self.copyWith(dailyUnits: value));
  });
}/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCopyWith<$Res> get daily {
  
  return $DailyCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherApiModel].
extension WeatherApiModelPatterns on WeatherApiModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherApiModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherApiModel value)  $default,){
final _that = this;
switch (_that) {
case _WeatherApiModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherApiModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherApiModel() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.dailyUnits,_that.daily);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)  $default,) {final _that = this;
switch (_that) {
case _WeatherApiModel():
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.dailyUnits,_that.daily);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)?  $default,) {final _that = this;
switch (_that) {
case _WeatherApiModel() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.dailyUnits,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherApiModel implements WeatherApiModel {
  const _WeatherApiModel({required this.latitude, required this.longitude, @JsonKey(name: 'generationtime_ms') required this.generationTimeMs, @JsonKey(name: 'utc_offset_seconds') required this.utcOffsetSeconds, required this.timezone, @JsonKey(name: 'timezone_abbreviation') required this.timezoneAbbreviation, required this.elevation, @JsonKey(name: 'daily_units') required this.dailyUnits, required this.daily});
  factory _WeatherApiModel.fromJson(Map<String, dynamic> json) => _$WeatherApiModelFromJson(json);

/// The latitude of the location.
@override final  double latitude;
/// The longitude of the location.
@override final  double longitude;
/// The generation time of the data in milliseconds.
@override@JsonKey(name: 'generationtime_ms') final  double generationTimeMs;
/// The UTC offset in seconds.
@override@JsonKey(name: 'utc_offset_seconds') final  int utcOffsetSeconds;
/// The timezone of the location.
@override final  String timezone;
/// The abbreviation of the timezone.
@override@JsonKey(name: 'timezone_abbreviation') final  String timezoneAbbreviation;
/// The elevation used for statistical downscaling.
@override final  double elevation;
/// The units of the daily data.
@override@JsonKey(name: 'daily_units') final  DailyUnits dailyUnits;
/// The daily weather data.
@override final  Daily daily;

/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherApiModelCopyWith<_WeatherApiModel> get copyWith => __$WeatherApiModelCopyWithImpl<_WeatherApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherApiModel&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationTimeMs, generationTimeMs) || other.generationTimeMs == generationTimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationTimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,dailyUnits,daily);

@override
String toString() {
  return 'WeatherApiModel(latitude: $latitude, longitude: $longitude, generationTimeMs: $generationTimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, dailyUnits: $dailyUnits, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$WeatherApiModelCopyWith<$Res> implements $WeatherApiModelCopyWith<$Res> {
  factory _$WeatherApiModelCopyWith(_WeatherApiModel value, $Res Function(_WeatherApiModel) _then) = __$WeatherApiModelCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationTimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'daily_units') DailyUnits dailyUnits, Daily daily
});


@override $DailyUnitsCopyWith<$Res> get dailyUnits;@override $DailyCopyWith<$Res> get daily;

}
/// @nodoc
class __$WeatherApiModelCopyWithImpl<$Res>
    implements _$WeatherApiModelCopyWith<$Res> {
  __$WeatherApiModelCopyWithImpl(this._self, this._then);

  final _WeatherApiModel _self;
  final $Res Function(_WeatherApiModel) _then;

/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? generationTimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? dailyUnits = null,Object? daily = null,}) {
  return _then(_WeatherApiModel(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationTimeMs: null == generationTimeMs ? _self.generationTimeMs : generationTimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as DailyUnits,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as Daily,
  ));
}

/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<$Res> get dailyUnits {
  
  return $DailyUnitsCopyWith<$Res>(_self.dailyUnits, (value) {
    return _then(_self.copyWith(dailyUnits: value));
  });
}/// Create a copy of WeatherApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCopyWith<$Res> get daily {
  
  return $DailyCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// @nodoc
mixin _$DailyUnits {

/// The date
 String get time;/// The unit for the maximum temperature at 2 meters above ground level.
@JsonKey(name: 'temperature_2m_max') String get temperature2mMax;/// The unit for the minimum temperature at 2 meters above ground level.
@JsonKey(name: 'temperature_2m_min') String get temperature2mMin;/// The unit for the sum of daily precipitation (including rain, showers and snowfall).
@JsonKey(name: 'precipitation_sum') String get precipitationSum;
/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<DailyUnits> get copyWith => _$DailyUnitsCopyWithImpl<DailyUnits>(this as DailyUnits, _$identity);

  /// Serializes this DailyUnits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2mMax, temperature2mMax) || other.temperature2mMax == temperature2mMax)&&(identical(other.temperature2mMin, temperature2mMin) || other.temperature2mMin == temperature2mMin)&&(identical(other.precipitationSum, precipitationSum) || other.precipitationSum == precipitationSum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2mMax,temperature2mMin,precipitationSum);

@override
String toString() {
  return 'DailyUnits(time: $time, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, precipitationSum: $precipitationSum)';
}


}

/// @nodoc
abstract mixin class $DailyUnitsCopyWith<$Res>  {
  factory $DailyUnitsCopyWith(DailyUnits value, $Res Function(DailyUnits) _then) = _$DailyUnitsCopyWithImpl;
@useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m_max') String temperature2mMax,@JsonKey(name: 'temperature_2m_min') String temperature2mMin,@JsonKey(name: 'precipitation_sum') String precipitationSum
});




}
/// @nodoc
class _$DailyUnitsCopyWithImpl<$Res>
    implements $DailyUnitsCopyWith<$Res> {
  _$DailyUnitsCopyWithImpl(this._self, this._then);

  final DailyUnits _self;
  final $Res Function(DailyUnits) _then;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? precipitationSum = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as String,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as String,precipitationSum: null == precipitationSum ? _self.precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyUnits].
extension DailyUnitsPatterns on DailyUnits {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyUnits value)  $default,){
final _that = this;
switch (_that) {
case _DailyUnits():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyUnits value)?  $default,){
final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'precipitation_sum')  String precipitationSum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'precipitation_sum')  String precipitationSum)  $default,) {final _that = this;
switch (_that) {
case _DailyUnits():
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'precipitation_sum')  String precipitationSum)?  $default,) {final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyUnits implements DailyUnits {
  const _DailyUnits({required this.time, @JsonKey(name: 'temperature_2m_max') required this.temperature2mMax, @JsonKey(name: 'temperature_2m_min') required this.temperature2mMin, @JsonKey(name: 'precipitation_sum') required this.precipitationSum});
  factory _DailyUnits.fromJson(Map<String, dynamic> json) => _$DailyUnitsFromJson(json);

/// The date
@override final  String time;
/// The unit for the maximum temperature at 2 meters above ground level.
@override@JsonKey(name: 'temperature_2m_max') final  String temperature2mMax;
/// The unit for the minimum temperature at 2 meters above ground level.
@override@JsonKey(name: 'temperature_2m_min') final  String temperature2mMin;
/// The unit for the sum of daily precipitation (including rain, showers and snowfall).
@override@JsonKey(name: 'precipitation_sum') final  String precipitationSum;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyUnitsCopyWith<_DailyUnits> get copyWith => __$DailyUnitsCopyWithImpl<_DailyUnits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyUnitsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2mMax, temperature2mMax) || other.temperature2mMax == temperature2mMax)&&(identical(other.temperature2mMin, temperature2mMin) || other.temperature2mMin == temperature2mMin)&&(identical(other.precipitationSum, precipitationSum) || other.precipitationSum == precipitationSum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2mMax,temperature2mMin,precipitationSum);

@override
String toString() {
  return 'DailyUnits(time: $time, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, precipitationSum: $precipitationSum)';
}


}

/// @nodoc
abstract mixin class _$DailyUnitsCopyWith<$Res> implements $DailyUnitsCopyWith<$Res> {
  factory _$DailyUnitsCopyWith(_DailyUnits value, $Res Function(_DailyUnits) _then) = __$DailyUnitsCopyWithImpl;
@override @useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m_max') String temperature2mMax,@JsonKey(name: 'temperature_2m_min') String temperature2mMin,@JsonKey(name: 'precipitation_sum') String precipitationSum
});




}
/// @nodoc
class __$DailyUnitsCopyWithImpl<$Res>
    implements _$DailyUnitsCopyWith<$Res> {
  __$DailyUnitsCopyWithImpl(this._self, this._then);

  final _DailyUnits _self;
  final $Res Function(_DailyUnits) _then;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? precipitationSum = null,}) {
  return _then(_DailyUnits(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as String,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as String,precipitationSum: null == precipitationSum ? _self.precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Daily {

/// The date
 List<String> get time;/// The maximum temperature at 2 meters above ground level in degrees Celsius.
@JsonKey(name: 'temperature_2m_max') List<double> get temperature2mMax;/// The minimum temperature at 2 meters above ground level in degrees Celsius.
@JsonKey(name: 'temperature_2m_min') List<double> get temperature2mMin;/// Sum of daily precipitation (including rain, showers and snowfall) in millimeters.
@JsonKey(name: 'precipitation_sum') List<double> get precipitationSum;
/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCopyWith<Daily> get copyWith => _$DailyCopyWithImpl<Daily>(this as Daily, _$identity);

  /// Serializes this Daily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Daily&&const DeepCollectionEquality().equals(other.time, time)&&const DeepCollectionEquality().equals(other.temperature2mMax, temperature2mMax)&&const DeepCollectionEquality().equals(other.temperature2mMin, temperature2mMin)&&const DeepCollectionEquality().equals(other.precipitationSum, precipitationSum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(time),const DeepCollectionEquality().hash(temperature2mMax),const DeepCollectionEquality().hash(temperature2mMin),const DeepCollectionEquality().hash(precipitationSum));

@override
String toString() {
  return 'Daily(time: $time, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, precipitationSum: $precipitationSum)';
}


}

/// @nodoc
abstract mixin class $DailyCopyWith<$Res>  {
  factory $DailyCopyWith(Daily value, $Res Function(Daily) _then) = _$DailyCopyWithImpl;
@useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m_max') List<double> temperature2mMax,@JsonKey(name: 'temperature_2m_min') List<double> temperature2mMin,@JsonKey(name: 'precipitation_sum') List<double> precipitationSum
});




}
/// @nodoc
class _$DailyCopyWithImpl<$Res>
    implements $DailyCopyWith<$Res> {
  _$DailyCopyWithImpl(this._self, this._then);

  final Daily _self;
  final $Res Function(Daily) _then;

/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? precipitationSum = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as List<double>,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as List<double>,precipitationSum: null == precipitationSum ? _self.precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Daily].
extension DailyPatterns on Daily {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Daily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Daily value)  $default,){
final _that = this;
switch (_that) {
case _Daily():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Daily value)?  $default,){
final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m_max')  List<double> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double> temperature2mMin, @JsonKey(name: 'precipitation_sum')  List<double> precipitationSum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m_max')  List<double> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double> temperature2mMin, @JsonKey(name: 'precipitation_sum')  List<double> precipitationSum)  $default,) {final _that = this;
switch (_that) {
case _Daily():
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> time, @JsonKey(name: 'temperature_2m_max')  List<double> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double> temperature2mMin, @JsonKey(name: 'precipitation_sum')  List<double> precipitationSum)?  $default,) {final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that.time,_that.temperature2mMax,_that.temperature2mMin,_that.precipitationSum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Daily implements Daily {
  const _Daily({required final  List<String> time, @JsonKey(name: 'temperature_2m_max') required final  List<double> temperature2mMax, @JsonKey(name: 'temperature_2m_min') required final  List<double> temperature2mMin, @JsonKey(name: 'precipitation_sum') required final  List<double> precipitationSum}): _time = time,_temperature2mMax = temperature2mMax,_temperature2mMin = temperature2mMin,_precipitationSum = precipitationSum;
  factory _Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

/// The date
 final  List<String> _time;
/// The date
@override List<String> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

/// The maximum temperature at 2 meters above ground level in degrees Celsius.
 final  List<double> _temperature2mMax;
/// The maximum temperature at 2 meters above ground level in degrees Celsius.
@override@JsonKey(name: 'temperature_2m_max') List<double> get temperature2mMax {
  if (_temperature2mMax is EqualUnmodifiableListView) return _temperature2mMax;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2mMax);
}

/// The minimum temperature at 2 meters above ground level in degrees Celsius.
 final  List<double> _temperature2mMin;
/// The minimum temperature at 2 meters above ground level in degrees Celsius.
@override@JsonKey(name: 'temperature_2m_min') List<double> get temperature2mMin {
  if (_temperature2mMin is EqualUnmodifiableListView) return _temperature2mMin;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2mMin);
}

/// Sum of daily precipitation (including rain, showers and snowfall) in millimeters.
 final  List<double> _precipitationSum;
/// Sum of daily precipitation (including rain, showers and snowfall) in millimeters.
@override@JsonKey(name: 'precipitation_sum') List<double> get precipitationSum {
  if (_precipitationSum is EqualUnmodifiableListView) return _precipitationSum;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precipitationSum);
}


/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCopyWith<_Daily> get copyWith => __$DailyCopyWithImpl<_Daily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Daily&&const DeepCollectionEquality().equals(other._time, _time)&&const DeepCollectionEquality().equals(other._temperature2mMax, _temperature2mMax)&&const DeepCollectionEquality().equals(other._temperature2mMin, _temperature2mMin)&&const DeepCollectionEquality().equals(other._precipitationSum, _precipitationSum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_temperature2mMax),const DeepCollectionEquality().hash(_temperature2mMin),const DeepCollectionEquality().hash(_precipitationSum));

@override
String toString() {
  return 'Daily(time: $time, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, precipitationSum: $precipitationSum)';
}


}

/// @nodoc
abstract mixin class _$DailyCopyWith<$Res> implements $DailyCopyWith<$Res> {
  factory _$DailyCopyWith(_Daily value, $Res Function(_Daily) _then) = __$DailyCopyWithImpl;
@override @useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m_max') List<double> temperature2mMax,@JsonKey(name: 'temperature_2m_min') List<double> temperature2mMin,@JsonKey(name: 'precipitation_sum') List<double> precipitationSum
});




}
/// @nodoc
class __$DailyCopyWithImpl<$Res>
    implements _$DailyCopyWith<$Res> {
  __$DailyCopyWithImpl(this._self, this._then);

  final _Daily _self;
  final $Res Function(_Daily) _then;

/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? precipitationSum = null,}) {
  return _then(_Daily(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2mMax: null == temperature2mMax ? _self._temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as List<double>,temperature2mMin: null == temperature2mMin ? _self._temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as List<double>,precipitationSum: null == precipitationSum ? _self._precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
