import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/weather.dart';

part 'weather_provider.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  Future<Weather> build() async {
    final apiClient = ref.watch(apiClientProvider);
    final weatherCheck = await apiClient.getWeatherCheck();
    return weatherCheck.toModel();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
Stream<Weather> weatherAutoRefresh(WeatherAutoRefreshRef ref) async* {
  while (true) {
    final weather = await ref.watch(weatherNotifierProvider.future);
    yield weather;
    await Future.delayed(const Duration(minutes: 15));
  }
} 