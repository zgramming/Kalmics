import 'dart:typed_data';

import 'package:audiotagger/models/tag.dart';
import 'package:equatable/equatable.dart';

class MusicModel extends Equatable {
  final String idMusic;
  final String? title;
  final String? pathFile;
  final Tag? tag;
  final Uint8List? artwork;
  final Duration? songDuration;
  const MusicModel({
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
      tag,
      title,
      artwork,
      pathFile,
      songDuration,
    ];
  }

  @override
  bool get stringify => true;

  MusicModel copyWith({
    String? idMusic,
    Tag? tag,
    String? title,
    Uint8List? artwork,
    String? pathFile,
    Duration? songDuration,
  }) {
    return MusicModel(
      idMusic: idMusic ?? this.idMusic,
      tag: tag ?? this.tag,
      title: title ?? this.title,
      artwork: artwork ?? this.artwork,
      pathFile: pathFile ?? this.pathFile,
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
