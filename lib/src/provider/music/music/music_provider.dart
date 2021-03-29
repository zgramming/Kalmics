import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../../../config/my_config.dart';
import '../../../network/my_network.dart';
import '../../my_provider.dart';

class MusicProvider extends StateNotifier<List<MusicModel>> {
  MusicProvider([List<MusicModel>? state]) : super(state ?? []);
  static const musicBoxKey = 'music_box';

  void _initListMusic(List<MusicModel> musics) {
    state = [...musics];
  }

  void addListMusic(
    List<MusicModel> musics, {
    bool withSync = true,
  }) {
    const uuid = Uuid();
    final musicBox = Hive.box<MusicModel>(musicBoxKey);
    if (withSync) {
      for (final MusicModel music in musics) {
        final isExists = musicBox.values.firstWhere(
          (element) =>
              (element.pathFile ?? '').toLowerCase().contains((music.pathFile ?? '').toLowerCase()),
          orElse: () => MusicModel(),
        );

        if (isExists.tag?.title == null) {
          musicBox.put(uuid.v1(), music);
        }
      }
    }
    final listMusic = musicBox.values.toList()
      ..sort((a, b) => (a.title?.toLowerCase() ?? '').compareTo(b.title?.toLowerCase() ?? ''));

    state = [...listMusic];
  }

  Future<void> addMusic(String path) async {
    log('add music from background');
    const uuid = Uuid();
    final players = AssetsAudioPlayer();
    final tagger = Audiotagger();
    final musicBox = Hive.box<MusicModel>(musicBoxKey);

    /// Filter only file with extension [.mp3] & Exclude [Constring.excludePathFile]
    if (path.endsWith('.mp3') && !path.toLowerCase().contains(ConstString.excludePathFile)) {
      /// get information meta from [.mp3]
      final readTag = await tagger.readTags(path: path);

      final tagMetaData = TagMetaDataModel(
        album: readTag.album,
        albumArtist: readTag.albumArtist,
        artist: readTag.artist,
        artwork: readTag.artwork,
        comment: readTag.comment,
        discNumber: readTag.discNumber,
        discTotal: readTag.discTotal,
        genre: readTag.genre,
        lyrics: readTag.lyrics,
        title: readTag.title,
        trackNumber: readTag.trackNumber,
        trackTotal: readTag.trackTotal,
      );

      /// get artwork/image from [.mp3]
      final artwork = await tagger.readArtwork(path: path);

      final isExists = state.firstWhere(
        (element) => (element.pathFile ?? '').toLowerCase().contains(path.toLowerCase()),
        orElse: () => MusicModel(),
      );
      if (isExists.tag?.title == null) {
        await players.open(Audio.file(path), autoStart: false);

        final _result = await players.current.first;

        final music = MusicModel(
          idMusic: uuid.v1(),
          artwork: artwork,
          pathFile: path,
          tag: tagMetaData,
          songDuration: _result?.audio.duration,
        );

        musicBox.put(music.idMusic, music);

        state = [...state, music]
          ..sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
      }
    }
  }

  void removeMusic(String path) {
    final musicBox = Hive.box<MusicModel>(musicBoxKey);
    final music = state.firstWhere((element) => element.pathFile == path);
    musicBox.delete(music.idMusic);
    final tempList = state.where((element) => element.pathFile != path).toList();
    state = [...tempList];
  }

  List<MusicModel> searchMusic(String query) {
    final result = state
        .where((element) => (element.title ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (result.isEmpty) {
      return [];
    }

    if (query.isEmpty) {
      return state;
    }

    return result;
  }

  Duration totalSongDuration() {
    final totalSongDuration = state.fold<int>(0, (previousValue, currentValue) {
      return previousValue + (currentValue.songDuration?.inSeconds ?? 0);
    });

    return Duration(seconds: totalSongDuration);
  }
}

final musicProvider = StateNotifierProvider((ref) => MusicProvider());

final totalDurationFormat = StateProvider<String>((ref) {
  final _currentSong = ref.watch(currentSongProvider.state);
  final _musics = ref.watch(musicProvider.state);

  var totalDurationInMinute = 0;
  String _totalRemainingSecond = '';
  final totalDuration = _musics[_currentSong.currentIndex].songDuration;
  totalDurationInMinute = totalDuration?.inMinutes ?? 0;
  final totalRemainingSecond = (totalDuration?.inSeconds ?? 0) % 60;
  _totalRemainingSecond =
      (totalRemainingSecond > 9) ? '$totalRemainingSecond' : '0$totalRemainingSecond';

  return '$totalDurationInMinute.$_totalRemainingSecond';
});

final filteredMusic = StateProvider<List<MusicModel>>((ref) {
  final _searchQuery = ref.watch(searchQuery).state;
  final _musicProvider = ref.watch(musicProvider.state);
  final _settingProvider = ref.watch(settingProvider.state);

  var result = <MusicModel>[];
  if (_searchQuery.isEmpty) {
    result = _musicProvider;
  } else {
    result = _musicProvider
        .where((element) => (element.title ?? '').toLowerCase().contains(_searchQuery))
        .toList();
  }

  if (result.isNotEmpty) {
    /// Sorting [Ascending/Descending]
    if (_settingProvider.sortByType == SortByType.ascending) {
      result.sort((a, b) {
        /// Sorting [Title,Artis,Duration][Ascending]

        int sortingChoice = 0;
        if (_settingProvider.sortChoice == "title") {
          sortingChoice = (a.title ?? '').compareTo(b.title ?? '');
        }
        if (_settingProvider.sortChoice == "artist") {
          sortingChoice = (a.tag?.artist ?? '').compareTo(b.tag?.artist ?? '');
        }
        if (_settingProvider.sortChoice == "duration") {
          sortingChoice =
              (a.songDuration?.inSeconds ?? -1).compareTo(b.songDuration?.inSeconds ?? -1);
        }
        return sortingChoice;
      });
    } else {
      result.sort((b, a) {
        /// Sorting [Title,Artis,Duration][Descending]

        int sortingChoice = 0;
        if (_settingProvider.sortChoice == ConstString.sortChoiceByTitle) {
          sortingChoice = (a.title ?? '').compareTo(b.title ?? '');
        }
        if (_settingProvider.sortChoice == ConstString.sortChoiceByArtist) {
          sortingChoice = (a.tag?.artist ?? '').compareTo(b.tag?.artist ?? '');
        }
        if (_settingProvider.sortChoice == ConstString.sortChoiceByDuration) {
          sortingChoice =
              (a.songDuration?.inSeconds ?? -1).compareTo(b.songDuration?.inSeconds ?? -1);
        }
        return sortingChoice;
      });
    }
  }

  if (result.isEmpty) {
    return [];
  }

  /// Shuffle Mode
  if (_settingProvider.isShuffle) {
    final tempListShuffle = [...result]..shuffle();
    return tempListShuffle;
  }
  return result;
});

final totalMusic = StateProvider<int>((ref) {
  final _filteredMusic = ref.watch(filteredMusic).state;
  final _musicProvider = ref.watch(musicProvider.state);

  int result = -1;
  if (ref.watch(searchQuery).state.isEmpty) {
    result = _musicProvider.length;
  } else {
    if (_filteredMusic.isEmpty) {
      result = 0;
    } else {
      result = _filteredMusic.length;
    }
  }
  return result;
});

final initListMusic = FutureProvider<bool>((ref) async {
  final _musicProvider = ref.watch(musicProvider);
  final listMusic = Hive.box<MusicModel>(MusicProvider.musicBoxKey).values.toList();
  _musicProvider._initListMusic(listMusic);
  return true;
});

final futureShowListMusic = FutureProvider.family.autoDispose<void, bool>((ref, withSync) async {
  final _musicProvider = ref.watch(musicProvider);
  final players = AssetsAudioPlayer.withId(ConstString.idAssetAudioPlayer);
  final tagger = Audiotagger();
  final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);

  /// Folder to find music for platform [android], Not yet support for IOS
  Directory dir = Directory('');
  if (Platform.isAndroid) {
    dir = Directory(ConstString.internalPathStorageAndroid);
  } else {
    /// This line for another Platform [IOS/WINDOWS/LINUX/etc...]
  }

  List<FileSystemEntity> _files;

  /// Search music folder with path directory[dir] declare before
  _files = dir.listSync(recursive: true, followLinks: false);

  final tempList = <MusicModel>[];
  for (final FileSystemEntity file in _files) {
    /// Filter only file with extension [.mp3] & Exclude [Constring.excludePathFile]

    if (file.path.endsWith('.mp3') &&
        !file.path.toLowerCase().contains(ConstString.excludePathFile)) {
      const uuid = Uuid();

      final path = file.path;

      /// get information meta from [.mp3]
      final readTag = await tagger.readTags(path: path);
      final tagMetaData = TagMetaDataModel(
        album: readTag.album,
        albumArtist: readTag.albumArtist,
        artist: readTag.artist,
        artwork: readTag.artwork,
        comment: readTag.comment,
        discNumber: readTag.discNumber,
        discTotal: readTag.discTotal,
        genre: readTag.genre,
        lyrics: readTag.lyrics,
        title: readTag.title,
        trackNumber: readTag.trackNumber,
        trackTotal: readTag.trackTotal,
      );

      /// get artwork/image from [.mp3]
      final artwork = await tagger.readArtwork(path: path);

      await players.open(Audio.file(path), autoStart: false);

      final _result = await players.current.first;

      final title =
          (readTag.title?.isNotEmpty ?? false) ? readTag.title : basenameWithoutExtension(path);

      final music = MusicModel(
        idMusic: uuid.v1(),
        title: title,
        artwork: artwork,
        pathFile: path,
        tag: tagMetaData,
        songDuration: _result?.audio.duration,
      );

      /// For Music Playing
      tempList.add(music);
      if (!withSync) {
        musicBox.put(music.idMusic, music);
      }
    }
  }

  tempList.sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
  _musicProvider.addListMusic(tempList, withSync: withSync);
});
