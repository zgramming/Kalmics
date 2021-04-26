import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:kalmics/src/network/my_network.dart';

part 'music_model.g.dart';

@HiveType(typeId: 1)
class MusicModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String idMusic;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? pathFile;
  @HiveField(3)
  final TagMetaDataModel? tag;
  @HiveField(4)
  final Uint8List? artwork;
  @HiveField(5)
  final Duration songDuration;
  @HiveField(6)
  final Duration totalListenSong;

  MusicModel({
    this.idMusic = '',
    this.title,
    this.pathFile,
    this.tag,
    this.artwork,
    this.songDuration = Duration.zero,
    this.totalListenSong = Duration.zero,
  });

  @override
  List get props {
    return [
      idMusic,
      title,
      pathFile,
      tag,
      artwork,
      songDuration,
      totalListenSong,
    ];
  }

  @override
  bool get stringify => true;

  MusicModel copyWith({
    String? idMusic,
    String? title,
    String? pathFile,
    TagMetaDataModel? tag,
    Uint8List? artwork,
    Duration? songDuration,
    Duration? totalListenSong,
  }) {
    return MusicModel(
      idMusic: idMusic ?? this.idMusic,
      title: title ?? this.title,
      pathFile: pathFile ?? this.pathFile,
      tag: tag ?? this.tag,
      artwork: artwork ?? this.artwork,
      songDuration: songDuration ?? this.songDuration,
      totalListenSong: totalListenSong ?? this.totalListenSong,
    );
  }
}
