import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

@freezed
class Zone with _$Zone {
  const factory Zone({
    required int id,
    required String name,
    required bool isEnabled,
    required bool isRunning,
    @Default(false) bool isPumpAssociated,
    @Default(0) int wateringTime,
    String? description,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
} 