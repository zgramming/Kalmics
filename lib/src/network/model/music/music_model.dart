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
  final Duration? songDuration;

  MusicModel({
    this.idMusic = '',
    this.title,
    this.pathFile,
    this.tag,
    this.artwork,
    this.songDuration,
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
  }) {
    return MusicModel(
      idMusic: idMusic ?? this.idMusic,
      title: title ?? this.title,
      pathFile: pathFile ?? this.pathFile,
      tag: tag ?? this.tag,
      artwork: artwork ?? this.artwork,
      songDuration: songDuration ?? this.songDuration,
    );
  }
}

class RecentMusicPlay extends Equatable {
  final int id;
  final int idMusic;
  final DateTime? date;
  final int totalPlay;
  const RecentMusicPlay({
    this.id = 1,
    this.idMusic = 1,
    this.date,
    this.totalPlay = 0,
  });

  @override
  List get props => [id, idMusic, date, totalPlay];

  @override
  bool get stringify => true;

  RecentMusicPlay copyWith({
    int? id,
    int? idMusic,
    DateTime? date,
    int? totalPlay,
  }) {
    return RecentMusicPlay(
      id: id ?? this.id,
      idMusic: idMusic ?? this.idMusic,
      date: date ?? this.date,
      totalPlay: totalPlay ?? this.totalPlay,
    );
  }
}
