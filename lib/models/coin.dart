import 'package:equatable/equatable.dart';
import 'package:pp_22_copy/services/database/entities/coin_entity.dart';

abstract class Coin {
  final int id;
  final String title;
  final int minYear;
  final int maxYear;
  final String issuer;
  final String? obverseThumbnail;
  final String? reverseThumbnail;

  const Coin({
    required this.id,
    required this.title,
    required this.issuer,
    required this.minYear,
    required this.maxYear,
    required this.obverseThumbnail,
    required this.reverseThumbnail,
  });
}

class ShortenedCoinData implements Coin {
  @override
  final int id;
  @override
  final String title;

  @override
  final String issuer;
  @override
  final int minYear;
  @override
  final int maxYear;
  @override
  final String? obverseThumbnail;
  @override
  final String? reverseThumbnail;

  ShortenedCoinData({
    required this.id,
    required this.title,
    required this.issuer,
    required this.minYear,
    required this.maxYear,
    required this.obverseThumbnail,
    required this.reverseThumbnail,
  });

  ShortenedCoinData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? "Coin title",
        issuer = (json['issuer'] as Map<String, dynamic>)['name'],
        minYear = json['min_year'],
        maxYear = json['max_year'],
        obverseThumbnail = json['obverse_thumbnail'],
        reverseThumbnail = json['reverse_thumbnail'];
}

class ExpandedCoinData with EquatableMixin implements Coin  {
  @override
  final int id;
  @override
  final String title;
  @override
  final int minYear;
  @override
  final int maxYear;
  final num? weight;
  final num? size;
  final num? thickness;
  @override
  final String? obverseThumbnail;
  @override
  final String? reverseThumbnail;
  final String? edge;
  @override
  final String issuer;
  final String? description;

  const ExpandedCoinData({
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

  ExpandedCoinData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? "Coin title",
        description =
            (json['obverse'] as Map<String, dynamic>?)?['description'],
        minYear = json['min_year'],
        maxYear = json['max_year'],
        weight = json['weight'],
        size = json['size'],
        thickness = json['thickness'],
        issuer = (json['issuer'] as Map<String, dynamic>?)?['name'],
        obverseThumbnail =
            (json['obverse'] as Map<String, dynamic>?)?['thumbnail'],
        reverseThumbnail =
            (json['reverse'] as Map<String, dynamic>?)?['thumbnail'],
        edge = (json['edge'] as Map<String, dynamic>?)?['description'];

  factory ExpandedCoinData.fromEntity(CoinEntity coinEntity) =>
      ExpandedCoinData(
        title: coinEntity.title,
        description: coinEntity.description,
        id: coinEntity.id,
        minYear: coinEntity.minYear,
        maxYear: coinEntity.maxYear,
        size: coinEntity.size,
        weight: coinEntity.weight,
        thickness: coinEntity.thickness,
        obverseThumbnail: coinEntity.obverseThumbnail,
        reverseThumbnail: coinEntity.reverseThumbnail,
        edge: coinEntity.edge,
        issuer: coinEntity.issuer,
      );
      
        @override
        List<Object?> get props => [id];
}