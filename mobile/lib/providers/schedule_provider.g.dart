// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleDetailsHash() => r'8810689aec4587fcfc53bced777cd90270c3f3bc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [scheduleDetails].
@ProviderFor(scheduleDetails)
const scheduleDetailsProvider = ScheduleDetailsFamily();

/// See also [scheduleDetails].
class ScheduleDetailsFamily extends Family<AsyncValue<Schedule>> {
  /// See also [scheduleDetails].
  const ScheduleDetailsFamily();

  /// See also [scheduleDetails].
  ScheduleDetailsProvider call(
    int id,
  ) {
    return ScheduleDetailsProvider(
      id,
    );
  }

  @override
  ScheduleDetailsProvider getProviderOverride(
    covariant ScheduleDetailsProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scheduleDetailsProvider';
}

/// See also [scheduleDetails].
class ScheduleDetailsProvider extends AutoDisposeFutureProvider<Schedule> {
  /// See also [scheduleDetails].
  ScheduleDetailsProvider(
    int id,
  ) : this._internal(
          (ref) => scheduleDetails(
            ref as ScheduleDetailsRef,
            id,
          ),
          from: scheduleDetailsProvider,
          name: r'scheduleDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scheduleDetailsHash,
          dependencies: ScheduleDetailsFamily._dependencies,
          allTransitiveDependencies:
              ScheduleDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  ScheduleDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Schedule> Function(ScheduleDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleDetailsProvider._internal(
        (ref) => create(ref as ScheduleDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Schedule> createElement() {
    return _ScheduleDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScheduleDetailsRef on AutoDisposeFutureProviderRef<Schedule> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ScheduleDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Schedule> with ScheduleDetailsRef {
  _ScheduleDetailsProviderElement(super.provider);

  @override
  int get id => (origin as ScheduleDetailsProvider).id;
}

String _$scheduleListNotifierHash() =>
    r'255beeb20380f3af024374f43f9aea403311e29c';

/// See also [ScheduleListNotifier].
@ProviderFor(ScheduleListNotifier)
final scheduleListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ScheduleListNotifier, List<Schedule>>.internal(
  ScheduleListNotifier.new,
  name: r'scheduleListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleListNotifier = AutoDisposeAsyncNotifier<List<Schedule>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
