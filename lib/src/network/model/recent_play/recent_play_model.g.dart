// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_play_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentPlayModelAdapter extends TypeAdapter<RecentPlayModel> {
  @override
  final int typeId = 3;

  @override
  RecentPlayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentPlayModel(
      id: fields[0] as String,
      music: fields[1] as MusicModel,
      createDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentPlayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.music)
      ..writeByte(2)
      ..write(obj.createDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentPlayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
