import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'tag_metadata_model.g.dart';

@HiveType(typeId: 2)
class TagMetaDataModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? artist;
  @HiveField(2)
  final String? genre;
  @HiveField(3)
  final String? trackNumber;
  @HiveField(4)
  final String? trackTotal;
  @HiveField(5)
  final String? discNumber;
  @HiveField(6)
  final String? discTotal;
  @HiveField(7)
  final String? lyrics;
  @HiveField(8)
  final String? comment;
  @HiveField(9)
  final String? album;
  @HiveField(10)
  final String? albumArtist;
  @HiveField(11)
  final String? year;
  @HiveField(12)
  final String? artwork;

  TagMetaDataModel({
    this.title,
    this.artist,
    this.genre,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.lyrics,
    this.comment,
    this.album,
    this.albumArtist,
    this.year,
    this.artwork,
  });
  @override
  // TODO: implement props
  List get props {
    return [
      title,
      artist,
      genre,
      trackNumber,
      trackTotal,
      discNumber,
      discTotal,
      lyrics,
      comment,
      album,
      albumArtist,
      year,
      artwork,
    ];
  }

  TagMetaDataModel copyWith({
    String? title,
    String? artist,
    String? genre,
    String? trackNumber,
    String? trackTotal,
    String? discNumber,
    String? discTotal,
    String? lyrics,
    String? comment,
    String? album,
    String? albumArtist,
    String? year,
    String? artwork,
  }) {
    return TagMetaDataModel(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      genre: genre ?? this.genre,
      trackNumber: trackNumber ?? this.trackNumber,
      trackTotal: trackTotal ?? this.trackTotal,
      discNumber: discNumber ?? this.discNumber,
      discTotal: discTotal ?? this.discTotal,
      lyrics: lyrics ?? this.lyrics,
      comment: comment ?? this.comment,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      year: year ?? this.year,
      artwork: artwork ?? this.artwork,
    );
  }

  @override
  bool get stringify => true;
}
