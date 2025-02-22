import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/models/zone.dart';
import 'api_provider.dart';
part 'zone_provider.g.dart';

@riverpod
class ZonesNotifier extends _$ZonesNotifier {
  @override
  Future<List<Zone>> build() async {
    return _fetchZones();
  }

  Future<List<Zone>> _fetchZones() async {
    final apiClient = ref.read(apiClientProvider);
    return apiClient.getZones();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchZones());
  }

  Future<void> toggleZone(int zoneId, bool enable) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.toggleZone(zoneId, enable);
      // Refresh the zones list
      await refresh();
    } catch (e, stack) {
      // Let the error propagate to the UI for handling
      state = AsyncValue.error(e, stack);
      throw e; // Re-throw to let the UI handle it
    }
  }

  Future<void> updateZone(Zone zone) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.updateZone(zone);
      // Refresh the zones list
      await refresh();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      throw e;
    }
  }
} 