import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22_copy/models/collection.dart';
import 'package:pp_22_copy/services/repositories/collection_repository.dart';
import 'package:uuid/uuid.dart';

class CollectionsController extends ValueNotifier<CollectionsState> {
  CollectionsController() : super(CollectionsState.initial()) {
    _init();
  }

  final _collectionsRepository = GetIt.instance<CollectionsRepository>();

  void _init() {
    value = value.copyWith(collections: _collectionsRepository.value.data);
    _collectionsRepository.addListener(_handleCollectionsUpdates);
  }

  void createCollection(String name) {
    final newCollection = Collection(
      name: name,
      coins: [],
      id: const Uuid().v4(),
    );
    _collectionsRepository.createCollection(newCollection);
  }

  void _handleCollectionsUpdates() =>
      value = value.copyWith(collections: _collectionsRepository.value.data);
}

class CollectionsState {
  final List<Collection> collections;

  CollectionsState({
    required this.collections,
  });

  factory CollectionsState.initial() => CollectionsState(collections: []);

  CollectionsState copyWith({
    List<Collection>? collections,
  }) =>
      CollectionsState(
        collections: collections ?? this.collections,
      );
}
