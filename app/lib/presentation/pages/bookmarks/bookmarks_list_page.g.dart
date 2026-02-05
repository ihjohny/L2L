// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_list_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarksListControllerHash() =>
    r'9f91ab0f9ee9d0fff2751b43a94390084f91556f';

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

abstract class _$BookmarksListController
    extends BuildlessAutoDisposeAsyncNotifier<List<EntityModel>> {
  late final String projectId;

  FutureOr<List<EntityModel>> build(
    String projectId,
  );
}

/// See also [BookmarksListController].
@ProviderFor(BookmarksListController)
const bookmarksListControllerProvider = BookmarksListControllerFamily();

/// See also [BookmarksListController].
class BookmarksListControllerFamily
    extends Family<AsyncValue<List<EntityModel>>> {
  /// See also [BookmarksListController].
  const BookmarksListControllerFamily();

  /// See also [BookmarksListController].
  BookmarksListControllerProvider call(
    String projectId,
  ) {
    return BookmarksListControllerProvider(
      projectId,
    );
  }

  @override
  BookmarksListControllerProvider getProviderOverride(
    covariant BookmarksListControllerProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'bookmarksListControllerProvider';
}

/// See also [BookmarksListController].
class BookmarksListControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BookmarksListController,
        List<EntityModel>> {
  /// See also [BookmarksListController].
  BookmarksListControllerProvider(
    String projectId,
  ) : this._internal(
          () => BookmarksListController()..projectId = projectId,
          from: bookmarksListControllerProvider,
          name: r'bookmarksListControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookmarksListControllerHash,
          dependencies: BookmarksListControllerFamily._dependencies,
          allTransitiveDependencies:
              BookmarksListControllerFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  BookmarksListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  FutureOr<List<EntityModel>> runNotifierBuild(
    covariant BookmarksListController notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(BookmarksListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookmarksListControllerProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BookmarksListController,
      List<EntityModel>> createElement() {
    return _BookmarksListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookmarksListControllerProvider &&
        other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookmarksListControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<EntityModel>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _BookmarksListControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BookmarksListController,
        List<EntityModel>> with BookmarksListControllerRef {
  _BookmarksListControllerProviderElement(super.provider);

  @override
  String get projectId => (origin as BookmarksListControllerProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
