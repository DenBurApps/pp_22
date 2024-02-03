// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionEntityAdapter extends TypeAdapter<CollectionEntity> {
  @override
  final int typeId = 0;

  @override
  CollectionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionEntity(
      name: fields[1] as String,
      coins: (fields[2] as List).cast<CoinEntity>(),
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.coins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
