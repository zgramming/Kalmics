// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 1;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      idMusic: fields[0] as String,
      title: fields[1] as String?,
      pathFile: fields[2] as String?,
      tag: fields[3] as TagMetaDataModel?,
      artwork: fields[4] as Uint8List?,
      songDuration: fields[5] as Duration?,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idMusic)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.pathFile)
      ..writeByte(3)
      ..write(obj.tag)
      ..writeByte(4)
      ..write(obj.artwork)
      ..writeByte(5)
      ..write(obj.songDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
