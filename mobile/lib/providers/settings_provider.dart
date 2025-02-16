import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/settings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<Settings> build() async {
    final apiClient = ref.watch(apiClientProvider);
    final apiSettings = await apiClient.getSettings();
    return apiSettings.toModel();
  }

  Future<void> saveSettings(Settings settings) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.saveSettings(settings);
      return settings;
    });
  }
} 