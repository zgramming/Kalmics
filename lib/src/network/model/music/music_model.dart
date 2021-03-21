import 'dart:typed_data';

import 'package:audiotagger/models/tag.dart';
import 'package:equatable/equatable.dart';

class MusicModel extends Equatable {
  final String idMusic;
  final Tag? tag;
  final Uint8List? artwork;
  final String? pathFile;
  final Duration? totalDuration;
  const MusicModel({
    this.idMusic = '',
    this.tag,
    this.artwork,
    this.pathFile,
    this.totalDuration,
  });
  @override
  List get props {
    return [
      idMusic,
      tag,
      artwork,
      pathFile,
      totalDuration,
    ];
  }

  @override
  bool get stringify => true;

  MusicModel copyWith({
    String? idMusic,
    Tag? tag,
    Uint8List? artwork,
    String? pathFile,
    Duration? totalDuration,
  }) {
    return MusicModel(
      idMusic: idMusic ?? this.idMusic,
      tag: tag ?? this.tag,
      artwork: artwork ?? this.artwork,
      pathFile: pathFile ?? this.pathFile,
      totalDuration: totalDuration ?? this.totalDuration,
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
