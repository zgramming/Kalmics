// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_metadata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagMetaDataModelAdapter extends TypeAdapter<TagMetaDataModel> {
  @override
  final int typeId = 2;

  @override
  TagMetaDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TagMetaDataModel(
      title: fields[0] as String?,
      artist: fields[1] as String?,
      genre: fields[2] as String?,
      trackNumber: fields[3] as String?,
      trackTotal: fields[4] as String?,
      discNumber: fields[5] as String?,
      discTotal: fields[6] as String?,
      lyrics: fields[7] as String?,
      comment: fields[8] as String?,
      album: fields[9] as String?,
      albumArtist: fields[10] as String?,
      year: fields[11] as String?,
      artwork: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TagMetaDataModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.trackNumber)
      ..writeByte(4)
      ..write(obj.trackTotal)
      ..writeByte(5)
      ..write(obj.discNumber)
      ..writeByte(6)
      ..write(obj.discTotal)
      ..writeByte(7)
      ..write(obj.lyrics)
      ..writeByte(8)
      ..write(obj.comment)
      ..writeByte(9)
      ..write(obj.album)
      ..writeByte(10)
      ..write(obj.albumArtist)
      ..writeByte(11)
      ..write(obj.year)
      ..writeByte(12)
      ..write(obj.artwork);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagMetaDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
