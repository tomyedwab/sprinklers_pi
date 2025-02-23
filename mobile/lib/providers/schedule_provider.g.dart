// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleDetailsHash() => r'f04e755150db247a8ff33ac1d2f242a3afedbaee';

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
class ScheduleDetailsFamily extends Family<AsyncValue<ScheduleDetail>> {
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
class ScheduleDetailsProvider
    extends AutoDisposeFutureProvider<ScheduleDetail> {
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
    FutureOr<ScheduleDetail> Function(ScheduleDetailsRef provider) create,
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
  AutoDisposeFutureProviderElement<ScheduleDetail> createElement() {
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
mixin ScheduleDetailsRef on AutoDisposeFutureProviderRef<ScheduleDetail> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ScheduleDetailsProviderElement
    extends AutoDisposeFutureProviderElement<ScheduleDetail>
    with ScheduleDetailsRef {
  _ScheduleDetailsProviderElement(super.provider);

  @override
  int get id => (origin as ScheduleDetailsProvider).id;
}

String _$scheduleListNotifierHash() =>
    r'e5f5eaeb8e6253b077ca9ace9f60209a64ec3d17';

/// See also [ScheduleListNotifier].
@ProviderFor(ScheduleListNotifier)
final scheduleListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ScheduleListNotifier, List<ScheduleListItem>>.internal(
  ScheduleListNotifier.new,
  name: r'scheduleListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleListNotifier
    = AutoDisposeAsyncNotifier<List<ScheduleListItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
