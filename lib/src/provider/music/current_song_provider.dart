import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/network/my_network.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kalmics/src/shared/my_shared.dart';

class CurrentSongProvider extends StateNotifier<CurrentSongModel> {
  CurrentSongProvider([CurrentSongModel? state])
      : super(state ??
            const CurrentSongModel(
              song: MusicModel(),
              isPlaying: false,
              isFloating: false,
              currentIndex: -1,
              currentDuration: Duration.zero,
            ));

  final sharedParameter = SharedParameter();
  void _setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void _setPlaying(bool value) {
    state = state.copyWith(isPlaying: value);
  }

  void _setFloating(bool value) {
    state = state.copyWith(isFloating: value);
  }

  void _setCurrentSong(MusicModel music) {
    state = state.copyWith(song: music);
  }

  void setDuration(Duration currentDuration) {
    state = state.copyWith(currentDuration: currentDuration);
  }

  void playSong(
    MusicModel music, {
    int? index,
    bool isPlaying = true,
    bool isFloating = true,
  }) {
    _setCurrentSong(music);
    _setPlaying(isPlaying);
    _setFloating(isFloating);
    _setCurrentIndex(index ?? state.currentIndex);
  }

  void pauseSong() {
    _setPlaying(false);
  }

  void stopSong() {
    _setPlaying(false);
    _setFloating(false);
    setDuration(Duration.zero);
  }

  MusicModel nextSong(
    List<MusicModel> musics, {
    required BuildContext context,
    required AssetsAudioPlayer players,
    required LoopModeSetting loopModeSetting,
  }) {
    final lastIndex = musics.length - 1;
    final currentIndex = state.currentIndex;
    var nextIndex = 0;
    if (musics.length > 1) {
      /// Check if current index + 1 exceeds the last index
      /// if [true] play first index song
      /// else play next index song
      nextIndex = (currentIndex + 1 > lastIndex) ? 0 : currentIndex + 1;
    }
    var nextSong = const MusicModel();
    switch (loopModeSetting) {
      case LoopModeSetting.all:
        nextSong = musics[nextIndex];
        playSong(nextSong, index: nextIndex);
        players.open(
          Audio.file(nextSong.pathFile ?? '', metas: sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            context,
            musics: musics,
          ),
        );
        break;
      case LoopModeSetting.single:
        nextSong = musics[currentIndex];
        playSong(nextSong, index: currentIndex);
        players.open(
          Audio.file(nextSong.pathFile ?? '', metas: sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            context,
            musics: musics,
          ),
        );
        break;
      case LoopModeSetting.none:
        nextSong = const MusicModel();
        stopSong();
        players.stop();
        break;
      default:
    }

    return nextSong;
  }

  MusicModel previousSong(List<MusicModel> musics) {
    final lastIndex = musics.length - 1;
    final currentIndex = state.currentIndex;
    var nextIndex = 0;
    if (musics.length > 1) {
      /// Check if current index - 1 is Negative
      /// if [true] play last index song
      /// else play previous index song

      nextIndex = (currentIndex - 1 < 0) ? lastIndex : currentIndex - 1;
    }
    final nextSong = musics[nextIndex];
    playSong(nextSong, index: nextIndex);
    return nextSong;
  }
}

final currentSongProvider = StateNotifierProvider((ref) => CurrentSongProvider());
