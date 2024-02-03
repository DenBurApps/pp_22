import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:pp_22_copy/models/collection.dart';
import 'package:pp_22_copy/services/database/entities/coin_entity.dart';

part 'collection_entity.g.dart';

@HiveType(typeId: 0)
class CollectionEntity extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<CoinEntity> coins;

  CollectionEntity({
    required this.name,
    required this.coins,
    required this.id,
  });

  factory CollectionEntity.fromCollection(Collection collection) =>
      CollectionEntity(
        name: collection.name,
        id: collection.id,
        coins: collection.coins
            .map((expandedCoinData) => CoinEntity.fromCoin(expandedCoinData))
            .toList(),
      );

  @override
  List<Object?> get props => [id];
}