import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
abstract class Location with _$Location {
  const factory Location({required String name, required double latitude, required double longitude}) = _Location;

  factory Location.fromJson(Map<String, Object?> json) => _$LocationFromJson(json);
}
