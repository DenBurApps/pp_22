import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:pp_22/models/coin.dart';

part 'coin_entity.g.dart';

@HiveType(typeId: 1)
class CoinEntity extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int minYear;
  @HiveField(3)
  final int maxYear;
  @HiveField(4)
  final num? weight;
  @HiveField(5)
  final num? size;
  @HiveField(6)
  final num? thickness;
  @HiveField(7)
  final String? obverseThumbnail;
  @HiveField(8)
  final String? reverseThumbnail;
  @HiveField(9)
  final String? edge;
  @HiveField(10)
  final String issuer;
  @HiveField(11)
  final String? description;

   CoinEntity({
    required this.title,
    required this.description,
    required this.id,
    required this.minYear,
    required this.maxYear,
    required this.size,
    required this.weight,
    required this.thickness,
    required this.obverseThumbnail,
    required this.reverseThumbnail,
    required this.edge,
    required this.issuer,
  });

  factory CoinEntity.fromCoin(ExpandedCoinData coin) => CoinEntity(
        title: coin.title,
        description: coin.description,
        id: coin.id,
        minYear: coin.minYear,
        maxYear: coin.maxYear,
        size: coin.size,
        weight: coin.weight,
        thickness: coin.thickness,
        obverseThumbnail: coin.obverseThumbnail,
        reverseThumbnail: coin.reverseThumbnail,
        edge: coin.edge,
        issuer: coin.issuer,
      );
      
        @override
        List<Object?> get props => [id];
}