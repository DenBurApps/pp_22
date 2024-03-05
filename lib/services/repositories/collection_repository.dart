import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/services/database/database_service.dart';
import 'package:pp_22/services/database/entities/collection_entity.dart';

class CollectionsRepository extends ValueNotifier<CollectionsState> {
  CollectionsRepository() : super(CollectionsState.initial()) {
    _init();
  }

  final _databaseService = GetIt.instance<DatabaseService>();

  void _init() {
    final collections = _databaseService.collections
        .map((e) => Collection.fromEntity(e))
        .toList();

    value = value.copyWith(data: collections);
  }

  void createCollection(Collection collection) {
    value.data.add(collection);
    final collectionEntity = CollectionEntity.fromCollection(collection);
    _databaseService.addCollection(collectionEntity);
    notifyListeners();
  }

  void deleteCollection(Collection collection, int index) {
    value.data.remove(collection);
    _databaseService.deleteCollection(index);
    notifyListeners();
  }

  void updateData(Collection updatedCollection, int index) {
    value.data[index] = updatedCollection;
    final collectionEntity = CollectionEntity.fromCollection(updatedCollection);
    _databaseService.updateCollection(index, collectionEntity);
    notifyListeners();
  }

  void updateSelectedIndex({int? selectedIndex}) {
    value = value.copyWith(selectedIndex: selectedIndex);
  }
}

class CollectionsState {
  final List<Collection> data;
  final int? selectedIndex;

  const CollectionsState({
    required this.data,
    this.selectedIndex,
  });

  factory CollectionsState.initial() => const CollectionsState(
        data: [],
      );

  CollectionsState copyWith({
    List<Collection>? data,
    int? selectedIndex,
  }) =>
      CollectionsState(
        data: data ?? this.data,
        selectedIndex: selectedIndex,
      );
}
