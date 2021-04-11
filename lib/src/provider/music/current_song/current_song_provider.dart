import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/config/my_config.dart';

import '../../../network/my_network.dart';
import '../../../shared/my_shared.dart';
import '../../my_provider.dart';

class CurrentSongProvider extends StateNotifier<CurrentSongModel> {
  CurrentSongProvider([CurrentSongModel? state])
      : super(state ??
            CurrentSongModel(
              song: MusicModel(),
              isPlaying: false,
              isFloating: false,
              currentIndex: -1,
              currentDuration: Duration.zero,
            ));

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

  void resumeSong() {
    _setPlaying(true);
  }

  void pauseSong() {
    _setPlaying(false);
  }

  void stopSong() {
    _setPlaying(false);
    _setFloating(false);
    setDuration(Duration.zero);
  }

  void _setInitSong(
    MusicModel music, {
    int? index,
    bool isPlaying = true,
    bool isFloating = true,
  }) {
    _setCurrentSong(music);
    _setPlaying(isPlaying);
    _setFloating(isFloating);
    _setCurrentIndex(index ?? state.currentIndex);
    setDuration(Duration.zero);
  }
}

final currentSongProvider = StateNotifierProvider((ref) => CurrentSongProvider());

final playSong = FutureProvider.family<void, Map<String, dynamic>>((ref, map) async {
  final _musics = ref.read(filteredMusic).state;
  final _players = ref.read(globalAudioPlayers).state;
  final _globalContext = ref.read(globalContext).state;
  final _currentSongProvider = ref.read(currentSongProvider);
  final _recentPlayProvider = ref.read(recentPlayProvider);

  final sharedParameter = SharedParameter();

  final music = map['music'] as MusicModel;
  final currentIndex = map['index'] as int;
  try {
    await _players.open(
      Audio.file(music.pathFile ?? '', metas: sharedParameter.metas(music)),
      showNotification: true,
      notificationSettings: sharedParameter.notificationSettings(
        _globalContext!,
        musics: _musics,
      ),
    );

    _currentSongProvider._setInitSong(music, index: currentIndex);

    ///* Save History Recents Play
    _recentPlayProvider.add(music);
  } on PlatformException catch (platformException) {
    var message = ConstString.defaultErrorPlayingSong;
    if (platformException.code == 'OPEN') {
      message = ConstString.songNotFoundInDirectory;
    }
    _currentSongProvider.stopSong();
    throw message;
  } catch (e) {
    _currentSongProvider.stopSong();
    rethrow;
  }
});

final previousSong = FutureProvider<MusicModel>((ref) async {
  final _globalContext = ref.read(globalContext).state;
  final _musics = ref.read(filteredMusic).state;
  final _players = ref.read(globalAudioPlayers).state;
  final _currentSongProvider = ref.read(currentSongProvider);
  final _currentSong = ref.read(currentSongProvider.state);
  final _recentPlayProvider = ref.read(recentPlayProvider);

  final sharedParameter = SharedParameter();

  final lastIndex = _musics.length - 1;
  final currentIndex = _currentSong.currentIndex;

  try {
    ///* Save Listen Song Duration Every Song
    ref.read(setListenSong(_currentSong.song));

    var nextIndex = 0;
    if (_musics.length > 1) {
      /// Check if current index - 1 is Negative
      /// if [true] play last index song
      /// else play previous index song

      nextIndex = (currentIndex - 1 < 0) ? lastIndex : currentIndex - 1;
    }
    final previousSong = _musics[nextIndex];

    await _players.open(
      Audio.file(
        previousSong.pathFile ?? '',
        metas: sharedParameter.metas(previousSong),
      ),
      showNotification: true,
      notificationSettings: sharedParameter.notificationSettings(
        _globalContext!,
        musics: _musics,
      ),
    );
    _currentSongProvider._setInitSong(previousSong, index: nextIndex);

    ///* Save History Recents Play
    _recentPlayProvider.add(previousSong);

    return previousSong;
  } on PlatformException catch (platformException) {
    var message = ConstString.defaultErrorPlayingSong;
    if (platformException.code == 'OPEN') {
      message = ConstString.songNotFoundInDirectory;
    }
    _currentSongProvider.stopSong();
    throw message;
  } catch (e) {
    _currentSongProvider.stopSong();
    rethrow;
  }
});

final nextSong = FutureProvider<MusicModel>((ref) async {
  final _globalContext = ref.read(globalContext).state;
  final _musics = ref.read(filteredMusic).state;
  final _players = ref.read(globalAudioPlayers).state;
  final _currentSongProvider = ref.read(currentSongProvider);
  final _currentSong = ref.read(currentSongProvider.state);
  final _recentPlayProvider = ref.read(recentPlayProvider);
  final loopModeSetting = ref.read(settingProvider.state).loopMode;

  try {
    final lastIndex = _musics.length - 1;
    final currentIndex = _currentSong.currentIndex;

    final sharedParameter = SharedParameter();
    var nextSong = MusicModel();
    var nextIndex = 0;

    if (_musics.length > 1) {
      /// Check if current index + 1 exceeds the last index
      /// if [true] play first index song
      /// else play next index song
      nextIndex = (currentIndex + 1 > lastIndex) ? 0 : currentIndex + 1;
    }

    ///* Save Listen Current Song Duration Every Song
    ref.read(setListenSong(_currentSong.song));

    switch (loopModeSetting) {
      case LoopModeSetting.all:
        nextSong = _musics[nextIndex];

        await _players.open(
          Audio.file(nextSong.pathFile ?? '', metas: sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );

        _currentSongProvider._setInitSong(nextSong, index: nextIndex);
        break;
      case LoopModeSetting.single:
        nextSong = _musics[currentIndex];
        await _players.open(
          Audio.file(nextSong.pathFile ?? '', metas: sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );

        _currentSongProvider._setInitSong(nextSong, index: currentIndex);
        break;
      case LoopModeSetting.none:
        nextSong = MusicModel();
        await _players.stop();
        _currentSongProvider.stopSong();
        break;
      default:
    }

    ///* Save History Recents Play
    _recentPlayProvider.add(nextSong);

    return nextSong;
  } on PlatformException catch (platformException) {
    var message = ConstString.defaultErrorPlayingSong;
    if (platformException.code == 'OPEN') {
      message = ConstString.songNotFoundInDirectory;
    }
    _currentSongProvider.stopSong();
    throw message;
  } catch (e) {
    _currentSongProvider.stopSong();
    rethrow;
  }
});
