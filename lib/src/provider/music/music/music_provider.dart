import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
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

  Future<void> _addListMusic(List<MusicModel> musics) async {
    final musicBox = Hive.box<MusicModel>(musicBoxKey);

    /// Always truncate music database if sync is fired
    await musicBox.deleteAll(musicBox.keys);

    for (final MusicModel music in musics) {
      final isExists = musicBox.values.firstWhere(
        (element) =>
            (element.pathFile ?? '').toLowerCase().contains((music.pathFile ?? '').toLowerCase()),
        orElse: () => MusicModel(),
      );

      if (isExists.tag?.title == null) {
        musicBox.put(music.idMusic, music);
      }
    }
    final listMusic = musicBox.values.toList()
      ..sort((a, b) => (a.title?.toLowerCase() ?? '').compareTo(b.title?.toLowerCase() ?? ''));

    state = [...listMusic];
  }

  void _addMusic(MusicModel music) {
    state = [...state, music]
      ..sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
  }

  void _editMusic(String idMusic, TagMetaDataModel tag) {
    state = [
      for (var item in state)
        if (item.idMusic == idMusic) item.copyWith(tag: tag, title: tag.title) else item
    ];
  }

  void _editArtworkMusic(String idMusic, Uint8List artwork) {
    state = [
      for (var item in state)
        if (item.idMusic == idMusic) item.copyWith(artwork: artwork) else item
    ];
  }

  void _removeMusic(String path) {
    final tempList = state.where((element) => element.pathFile != path).toList();
    state = [...tempList];
  }

  void _setListenSong(MusicModel music, Duration newDuration) {
    state = [
      for (var item in state)
        if (item.idMusic == music.idMusic) item.copyWith(totalListenSong: newDuration) else item
    ];
  }
}

final musicProvider = StateNotifierProvider((ref) => MusicProvider());

final totalSongDuration = StateProvider.autoDispose<Duration>((ref) {
  final _musics = ref.watch(musicProvider.state);
  final totalSongDuration = _musics.fold<int>(0, (previousValue, currentValue) {
    return previousValue + (currentValue.songDuration.inSeconds);
  });

  return Duration(seconds: totalSongDuration);
});

final musicById = StateProvider.family<MusicModel, String>((ref, idMusic) {
  final musics = ref.watch(musicProvider.state);
  final result =
      musics.firstWhere((element) => element.idMusic == idMusic, orElse: () => MusicModel());
  if (result.idMusic.isEmpty) {
    return MusicModel();
  }

  return result;
});

final filteredMusic = StateProvider.autoDispose<List<MusicModel>>((ref) {
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

  if (result.isEmpty) {
    return [];
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
          sortingChoice = (a.songDuration.inSeconds).compareTo(b.songDuration.inSeconds);
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
          sortingChoice = (a.songDuration.inSeconds).compareTo(b.songDuration.inSeconds);
        }
        return sortingChoice;
      });
    }
  }

  return result;
});

final totalMusic = StateProvider.autoDispose<int>((ref) {
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

final removeMusic = FutureProvider.family<void, String>((ref, path) async {
  final musics = ref.read(musicProvider.state);
  final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);
  final music =
      musics.firstWhere((element) => element.pathFile == path, orElse: () => MusicModel());
  if (music.idMusic.isEmpty) {
    throw Exception('Failed to remove song from application');
  }
  musicBox.delete(music.idMusic).then((_) => ref.read(musicProvider)._removeMusic(path));
  log('Trigger Remove Background Music');
});

final addMusic = FutureProvider.family<void, String>((ref, path) async {
  final players = AssetsAudioPlayer();
  final _musicProvider = ref.read(musicProvider);
  final musics = ref.read(musicProvider.state);
  const uuid = Uuid();
  final tagger = Audiotagger();
  final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);

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

    final isExists = musics.firstWhere(
        (element) => (element.pathFile ?? '').toLowerCase().contains(path.toLowerCase()),
        orElse: () => MusicModel());
    log('IS EXISTS ||| $isExists');

    if (isExists.idMusic.isEmpty) {
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
        songDuration: _result!.audio.duration,
      );

      musicBox.put(music.idMusic, music);
      _musicProvider._addMusic(music);
    }
  }
  log('Trigger Add Background Music');
});

final setListenSong = FutureProvider.family<void, MusicModel>((ref, music) async {
  final currentSongDuration = ref.read(currentSongProvider.state).currentDuration;
  final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);

  final calculateTotalDuration = music.totalListenSong.inSeconds + currentSongDuration.inSeconds;
  await musicBox.put(
    music.idMusic,
    music.copyWith(totalListenSong: Duration(seconds: calculateTotalDuration)),
  );

  ref.read(musicProvider)._setListenSong(music, Duration(seconds: calculateTotalDuration));
});

final editSong = FutureProvider.family<void, Map<String, dynamic>>((ref, map) async {
  final _musics = ref.read(musicProvider.state);
  final music = map['music'] as MusicModel;
  final tagMetaData = map['tag'] as TagMetaDataModel;

  final result = _musics.firstWhere((element) => element.idMusic == music.idMusic);

  if (result.idMusic.isNotEmpty) {
    final tagger = Audiotagger();
    final processEdit = await tagger.writeTags(
          path: music.pathFile!,
          tag: Tag(
            title: tagMetaData.title,
            artist: tagMetaData.artist,
            album: tagMetaData.album,
            genre: tagMetaData.genre,
          ),
        ) ??
        false;

    if (!processEdit) {
      throw Exception("Error when update music");
    }

    final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);
    await musicBox.put(music.idMusic, music.copyWith(tag: tagMetaData));
    ref.read(musicProvider)._editMusic(music.idMusic, tagMetaData);
  }
});

final editArtworkSong = FutureProvider.family<void, MusicModel>((ref, music) async {
  final _musics = ref.read(musicProvider.state);
  final result = _musics.firstWhere((element) => element.idMusic == music.idMusic);
  if (result.idMusic.isNotEmpty) {
    final tagger = Audiotagger();
    final fileArtwork = ref.read(globalFileArtwork).state!;
    final artwork = await fileArtwork.readAsBytes();

    final processEdit =
        await tagger.writeTags(path: music.pathFile!, tag: Tag(artwork: fileArtwork.path)) ?? false;
    if (!processEdit) {
      throw Exception("Error when update artwork music");
    }
    final musicBox = Hive.box<MusicModel>(MusicProvider.musicBoxKey);
    await musicBox.put(music.idMusic, music.copyWith(artwork: artwork));
    ref.read(musicProvider)._editArtworkMusic(music.idMusic, artwork);
  }
});

final initializeMusicFromStorage = FutureProvider.autoDispose<void>((ref) async {
  final _musicProvider = ref.watch(musicProvider);
  final players = AssetsAudioPlayer.withId(ConstString.idAssetAudioPlayer);
  final tagger = Audiotagger();

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
      await players.open(Audio.file(path), autoStart: false);
      final songDuration = (await players.current.first)!.audio.duration;

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

      final title =
          (readTag.title?.isNotEmpty ?? false) ? readTag.title : basenameWithoutExtension(path);

      final music = MusicModel(
        idMusic: uuid.v1(),
        title: title,
        artwork: artwork,
        pathFile: path,
        tag: tagMetaData,
        songDuration: songDuration,
      );

      /// For Music Playing
      tempList.add(music);
    }
  }

  tempList.sort((a, b) => (a.title ?? '').toLowerCase().compareTo((b.title ?? '').toLowerCase()));
  await _musicProvider._addListMusic(tempList);
});
