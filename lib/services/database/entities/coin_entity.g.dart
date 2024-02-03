// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoinEntityAdapter extends TypeAdapter<CoinEntity> {
  @override
  final int typeId = 1;

  @override
  CoinEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoinEntity(
      title: fields[1] as String,
      description: fields[11] as String?,
      id: fields[0] as int,
      minYear: fields[2] as int,
      maxYear: fields[3] as int,
      size: fields[5] as num?,
      weight: fields[4] as num?,
      thickness: fields[6] as num?,
      obverseThumbnail: fields[7] as String?,
      reverseThumbnail: fields[8] as String?,
      edge: fields[9] as String?,
      issuer: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CoinEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.minYear)
      ..writeByte(3)
      ..write(obj.maxYear)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.thickness)
      ..writeByte(7)
      ..write(obj.obverseThumbnail)
      ..writeByte(8)
      ..write(obj.reverseThumbnail)
      ..writeByte(9)
      ..write(obj.edge)
      ..writeByte(10)
      ..write(obj.issuer)
      ..writeByte(11)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
