// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logNotifierHash() => r'86e0186941abe1850d61aba5aa73e4e2c8ed4a32';

/// See also [LogNotifier].
@ProviderFor(LogNotifier)
final logNotifierProvider = AutoDisposeAsyncNotifierProvider<LogNotifier,
    Map<int, List<GraphPoint>>>.internal(
  LogNotifier.new,
  name: r'logNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LogNotifier = AutoDisposeAsyncNotifier<Map<int, List<GraphPoint>>>;
String _$tableLogNotifierHash() => r'edfd25bfae61439959a0492987e6610296699308';

/// See also [TableLogNotifier].
@ProviderFor(TableLogNotifier)
final tableLogNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TableLogNotifier, List<ZoneLog>>.internal(
  TableLogNotifier.new,
  name: r'tableLogNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableLogNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TableLogNotifier = AutoDisposeAsyncNotifier<List<ZoneLog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
