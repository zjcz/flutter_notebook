// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeControllerHash() => r'2eafc3f37d7531714d8eddddcf3f36e9a42763ee';

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

abstract class _$HomeController
    extends BuildlessAutoDisposeStreamNotifier<List<NoteWithCategoryModel>> {
  late final int? categoryId;
  late final SortOrder sortOrder;

  Stream<List<NoteWithCategoryModel>> build(
    int? categoryId,
    SortOrder sortOrder,
  );
}

/// See also [HomeController].
@ProviderFor(HomeController)
const homeControllerProvider = HomeControllerFamily();

/// See also [HomeController].
class HomeControllerFamily
    extends Family<AsyncValue<List<NoteWithCategoryModel>>> {
  /// See also [HomeController].
  const HomeControllerFamily();

  /// See also [HomeController].
  HomeControllerProvider call(
    int? categoryId,
    SortOrder sortOrder,
  ) {
    return HomeControllerProvider(
      categoryId,
      sortOrder,
    );
  }

  @override
  HomeControllerProvider getProviderOverride(
    covariant HomeControllerProvider provider,
  ) {
    return call(
      provider.categoryId,
      provider.sortOrder,
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
  String? get name => r'homeControllerProvider';
}

/// See also [HomeController].
class HomeControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    HomeController, List<NoteWithCategoryModel>> {
  /// See also [HomeController].
  HomeControllerProvider(
    int? categoryId,
    SortOrder sortOrder,
  ) : this._internal(
          () => HomeController()
            ..categoryId = categoryId
            ..sortOrder = sortOrder,
          from: homeControllerProvider,
          name: r'homeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeControllerHash,
          dependencies: HomeControllerFamily._dependencies,
          allTransitiveDependencies:
              HomeControllerFamily._allTransitiveDependencies,
          categoryId: categoryId,
          sortOrder: sortOrder,
        );

  HomeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.sortOrder,
  }) : super.internal();

  final int? categoryId;
  final SortOrder sortOrder;

  @override
  Stream<List<NoteWithCategoryModel>> runNotifierBuild(
    covariant HomeController notifier,
  ) {
    return notifier.build(
      categoryId,
      sortOrder,
    );
  }

  @override
  Override overrideWith(HomeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: HomeControllerProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..sortOrder = sortOrder,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<HomeController,
      List<NoteWithCategoryModel>> createElement() {
    return _HomeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeControllerProvider &&
        other.categoryId == categoryId &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HomeControllerRef
    on AutoDisposeStreamNotifierProviderRef<List<NoteWithCategoryModel>> {
  /// The parameter `categoryId` of this provider.
  int? get categoryId;

  /// The parameter `sortOrder` of this provider.
  SortOrder get sortOrder;
}

class _HomeControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<HomeController,
        List<NoteWithCategoryModel>> with HomeControllerRef {
  _HomeControllerProviderElement(super.provider);

  @override
  int? get categoryId => (origin as HomeControllerProvider).categoryId;
  @override
  SortOrder get sortOrder => (origin as HomeControllerProvider).sortOrder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
