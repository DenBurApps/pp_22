import 'package:equatable/equatable.dart';
import 'package:pp_22/models/coin.dart';
import 'package:pp_22/services/database/entities/collection_entity.dart';

class Collection extends Equatable {
  final String id;
  final String name;
  final List<ExpandedCoinData> coins;
  const Collection({
    required this.name,
    required this.coins,
    required this.id,
  });

  factory Collection.fromEntity(CollectionEntity collectionEntity) =>
      Collection(
        name: collectionEntity.name,
        coins: collectionEntity.coins
            .map((coinEntity) => ExpandedCoinData.fromEntity(coinEntity))
            .toList(),
        id: collectionEntity.id,
      );

  Collection copyWith({String? name, List<ExpandedCoinData>? coins}) =>
      Collection(
        name: name ?? this.name,
        coins: coins ?? this.coins,
        id: id,
      );

  @override
  List<Object?> get props => [id];
}