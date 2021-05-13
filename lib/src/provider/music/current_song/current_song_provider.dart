import 'dart:math';

import 'package:rxdart/rxdart.dart';
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

final totalCurrentSongDurationFormat = StateProvider.autoDispose<String>((ref) {
  final _currentSong = ref.watch(currentSongProvider.state);
  final _musics = ref.watch(musicProvider.state);
  var totalDurationInMinute = 0;
  var _totalRemainingSecond = '';

  final totalDuration = _musics[_currentSong.currentIndex].songDuration;
  totalDurationInMinute = totalDuration.inMinutes;
  final totalRemainingSecond = (totalDuration.inSeconds) % 60;
  _totalRemainingSecond =
      (totalRemainingSecond > 9) ? '$totalRemainingSecond' : '0$totalRemainingSecond';

  return '$totalDurationInMinute.$_totalRemainingSecond';
});

final playSong = FutureProvider.family<void, MusicModel>((ref, music) async {
  final _players = ref.read(globalAudioPlayers).state;
  final _globalContext = ref.read(globalContext).state;

  ///* Get All musics
  final _musics = ref.read(musicProvider.state);

  ///* Initialize Current Song
  final _currentSongProvider = ref.read(currentSongProvider);

  ///* For Saving History Recents Play
  final _recentPlayProvider = ref.read(recentPlayProvider);

  try {
    final sharedParameter = SharedParameter();

    final currentIndex = _musics.indexWhere((element) => element.idMusic == music.idMusic);
    await _players.open(
      Audio.file(music.pathFile ?? '', metas: await sharedParameter.metas(music)),
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
    if (platformException.code == ConstString.codeErrorCantOpenSong) {
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
  final _players = ref.read(globalAudioPlayers).state;

  final _globalContext = ref.read(globalContext).state;

  ///* Get All Music
  final _musics = ref.read(musicProvider.state);

  ///* For Set/Initialize current song
  final _currentSongProvider = ref.read(currentSongProvider);

  ///* Get Detail Current Song
  final _currentSong = ref.read(currentSongProvider.state);

  ///* For Save history recents Play
  final _recentPlayProvider = ref.read(recentPlayProvider);

  ///* For get [Mode Loop , Mode Shuffle]
  final _settingProvider = ref.read(settingProvider.state);

  try {
    final loopModeSetting = _settingProvider.loopMode;
    final isShuffle = _settingProvider.isShuffle;

    final sharedParameter = SharedParameter();

    var previousSong = MusicModel();
    var previousIndex = 0;

    final lastIndex = _musics.length - 1;
    final currentIndex = _currentSong.currentIndex;

    if (_musics.length > 1) {
      /**
       * Check if current index - 1 is Negative
       * if [true] play last index song
       * else play previous index song
       * 
       */

      previousIndex = (currentIndex - 1 < 0) ? lastIndex : currentIndex - 1;

      if (isShuffle) {
        final randomIndex = Random().nextInt(_musics.length);
        previousIndex = randomIndex;
      }
    }

    ///* Save Listen Song Duration Every Song
    ref.read(setListenSong(_currentSong.song));

    switch (loopModeSetting) {
      case LoopModeSetting.all:
        previousSong = _musics[previousIndex];
        await _players.open(
          Audio.file(previousSong.pathFile!, metas: await sharedParameter.metas(previousSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );
        _currentSongProvider._setInitSong(previousSong, index: previousIndex);
        break;
      case LoopModeSetting.single:
        previousSong = _musics[currentIndex];
        await _players.open(
          Audio.file(previousSong.pathFile!, metas: await sharedParameter.metas(previousSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );
        _currentSongProvider._setInitSong(
          previousSong,
          index: currentIndex,
        );

        break;
      case LoopModeSetting.none:
        previousSong = MusicModel();
        await _players.stop();
        _currentSongProvider.stopSong();
        break;
      default:
    }

    ///* Save History Recents Play
    _recentPlayProvider.add(previousSong);

    return previousSong;
  } on PlatformException catch (platformException) {
    var message = ConstString.defaultErrorPlayingSong;
    if (platformException.code == ConstString.codeErrorCantOpenSong) {
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
  final _players = ref.read(globalAudioPlayers).state;
  final _globalContext = ref.read(globalContext).state;

  ///* Get All Music
  final _musics = ref.read(musicProvider.state);

  ///* Set/Initialize Current Song
  final _currentSongProvider = ref.read(currentSongProvider);

  ///* Get Detail Current Song
  final _currentSong = ref.read(currentSongProvider.state);

  ///* For saving to history recents play
  final _recentPlayProvider = ref.read(recentPlayProvider);

  ///* For get [Mode Loop , Mode Shuffle]
  final _settingProvider = ref.read(settingProvider.state);

  try {
    final loopModeSetting = _settingProvider.loopMode;
    final isShuffle = _settingProvider.isShuffle;

    final sharedParameter = SharedParameter();

    var nextSong = MusicModel();
    var nextIndex = 0;

    final lastIndex = _musics.length - 1;
    final currentIndex = _currentSong.currentIndex;

    if (_musics.length > 1) {
      /**
       * Check if current index + 1 exceeds the last index
       * if [true] play first index song
       * else play next index song
       * 
       */

      nextIndex = (currentIndex + 1 > lastIndex) ? 0 : currentIndex + 1;

      if (isShuffle) {
        final randomIndex = Random().nextInt(_musics.length);
        nextIndex = randomIndex;
      }
    }

    ///* Save Listen Current Song Duration Every Song
    ref.read(setListenSong(_currentSong.song));

    switch (loopModeSetting) {
      case LoopModeSetting.all:
        nextSong = _musics[nextIndex];

        await _players.open(
          Audio.file(nextSong.pathFile ?? '', metas: await sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );

        _currentSongProvider._setInitSong(
          nextSong,
          index: nextIndex,
        );

        break;
      case LoopModeSetting.single:
        nextSong = _musics[currentIndex];

        await _players.open(
          Audio.file(nextSong.pathFile!, metas: await sharedParameter.metas(nextSong)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            _globalContext!,
            musics: _musics,
          ),
        );

        _currentSongProvider._setInitSong(
          nextSong,
          index: currentIndex,
        );
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
    if (platformException.code == ConstString.codeErrorCantOpenSong) {
      message = ConstString.songNotFoundInDirectory;
    }
    _currentSongProvider.stopSong();
    throw message;
  } catch (e) {
    _currentSongProvider.stopSong();
    rethrow;
  }
});

final currentSongPosition = StreamProvider.autoDispose((ref) {
  final AssetsAudioPlayer player = ref.watch(globalAudioPlayers).state;

  final Stream<double> currentDuration =
      player.currentPosition.map((event) => event.inSeconds.toDouble());
  final Stream<double> maxDuration =
      player.current.map((event) => event?.audio.duration.inSeconds.toDouble() ?? 0.0);

  final tempList = [currentDuration, maxDuration];
  return CombineLatestStream.list(tempList);
});
