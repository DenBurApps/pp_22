import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp_22_copy/services/database/entities/coin_entity.dart';
import 'package:pp_22_copy/services/database/entities/collection_entity.dart';

class DatabaseService {
  late final Box _common;
  late final Box<CollectionEntity> _collections;

  Future<DatabaseService> init() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);
    Hive.registerAdapter(CollectionEntityAdapter());
    Hive.registerAdapter(CoinEntityAdapter());
    _common = await Hive.openBox('common');
    _collections = await Hive.openBox('collections');
    return this;
  }

  Iterable<CollectionEntity> get collections => _collections.values;

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);

  void addCollection(CollectionEntity collectionEntity) =>
      _collections.add(collectionEntity);

  void deleteCollection(int collectionIndex) =>
      _collections.deleteAt(collectionIndex);

  void updateCollection(
          int collectionIndex, CollectionEntity updatedCollectionEntity) =>
      _collections.putAt(
        collectionIndex,
        updatedCollectionEntity,
      );
}
