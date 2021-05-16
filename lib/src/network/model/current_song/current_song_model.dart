import 'package:equatable/equatable.dart';

import 'package:kalmics/src/network/my_network.dart';

class CurrentSongModel extends Equatable {
  final MusicModel song;
  final int currentIndex;
  final bool isPlaying;
  final bool isFloating;

  const CurrentSongModel({
    required this.song,
    required this.currentIndex,
    required this.isPlaying,
    required this.isFloating,
  });
  @override
  List<Object> get props {
    return [
      song,
      currentIndex,
      isPlaying,
      isFloating,
    ];
  }

  @override
  bool get stringify => true;

  CurrentSongModel copyWith({
    MusicModel? song,
    int? currentIndex,
    bool? isPlaying,
    bool? isFloating,
  }) {
    return CurrentSongModel(
      song: song ?? this.song,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isFloating: isFloating ?? this.isFloating,
    );
  }
}
