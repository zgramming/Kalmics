import 'package:equatable/equatable.dart';

import 'package:kalmics/src/network/my_network.dart';

class CurrentSongModel extends Equatable {
  final MusicModel song;
  final Duration currentDuration;
  final int currentIndex;
  final bool isPlaying;
  final bool isFloating;

  const CurrentSongModel({
    required this.song,
    required this.currentDuration,
    required this.currentIndex,
    required this.isPlaying,
    required this.isFloating,
  });
  @override
  List<Object> get props {
    return [
      song,
      currentDuration,
      currentIndex,
      isPlaying,
      isFloating,
    ];
  }

  @override
  bool get stringify => true;

  CurrentSongModel copyWith({
    MusicModel? song,
    Duration? currentDuration,
    int? currentIndex,
    bool? isPlaying,
    bool? isFloating,
  }) {
    return CurrentSongModel(
      song: song ?? this.song,
      currentDuration: currentDuration ?? this.currentDuration,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isFloating: isFloating ?? this.isFloating,
    );
  }
}
