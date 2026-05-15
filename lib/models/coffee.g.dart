// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoffeeAdapter extends TypeAdapter<Coffee> {
  @override
  final int typeId = 2;

  @override
  Coffee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coffee(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as String,
      imageUrl: fields[3] as String,
      description: fields[4] as String,
      category: fields[5] as String,
      rating: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Coffee obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoffeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
