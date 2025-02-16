import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/weather.dart';

part 'weather_provider.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  Future<Weather> build() async {
    return _fetchWeather();
  }

  Future<Weather> _fetchWeather() async {
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.getWeatherCheck();
    return Weather.fromJson(response.toJson());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWeather());
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