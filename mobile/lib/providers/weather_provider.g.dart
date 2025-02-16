// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherAutoRefreshHash() =>
    r'857fa3459e5ec86cffc898da8d86444f0cd7653a';

/// See also [weatherAutoRefresh].
@ProviderFor(weatherAutoRefresh)
final weatherAutoRefreshProvider = AutoDisposeStreamProvider<Weather>.internal(
  weatherAutoRefresh,
  name: r'weatherAutoRefreshProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherAutoRefreshHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherAutoRefreshRef = AutoDisposeStreamProviderRef<Weather>;
String _$weatherNotifierHash() => r'0036c70c4356a0f5ec14dab7005691d5a7841db2';

/// See also [WeatherNotifier].
@ProviderFor(WeatherNotifier)
final weatherNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WeatherNotifier, Weather>.internal(
  WeatherNotifier.new,
  name: r'weatherNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WeatherNotifier = AutoDisposeAsyncNotifier<Weather>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
