// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiClientHash() => r'830b3339c24d952121db45e5d7278545d0d2fbfd';

/// See also [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = AutoDisposeProvider<ApiClient>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = AutoDisposeProviderRef<ApiClient>;
String _$aPIProviderHash() => r'60f58dad5ebc9b5326ab3e4351d0525b71feb4ea';

/// See also [APIProvider].
@ProviderFor(APIProvider)
final aPIProviderProvider =
    AutoDisposeAsyncNotifierProvider<APIProvider, void>.internal(
  APIProvider.new,
  name: r'aPIProviderProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aPIProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$APIProvider = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
