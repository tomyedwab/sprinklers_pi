import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/schedule.dart';
import 'schedule_provider.dart';
import 'zone_provider.dart';

part 'schedule_zone_provider.g.dart';

/// Provides zone names in order for schedule display
@riverpod
class ScheduleZoneNames extends _$ScheduleZoneNames {
  @override
  Future<List<String>> build() async {
    final zones = await ref.watch(zonesNotifierProvider.future);
    return zones.map((z) => z.name).toList();
  }
} 