import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/my_config.dart';
import '../../network/my_network.dart';

class MusicProvider extends StateNotifier<List<MusicModel>> {
  MusicProvider([List<MusicModel>? state]) : super(state ?? []);

  void addListMusic(
    List<MusicModel> musics, {
    bool withSync = true,
  }) {
    final tempList = <MusicModel>[];

    for (final MusicModel music in musics) {
      if (withSync) {
        final isExists = tempList.firstWhere(
          (element) =>
              (element.pathFile ?? '').toLowerCase().contains((music.pathFile ?? '').toLowerCase()),
          orElse: () => const MusicModel(),
        );

        if (isExists.tag?.title == null) {
          tempList.add(music);
        }
      }
    }

    tempList.sort(
        (a, b) => (a.tag?.title?.toLowerCase() ?? '').compareTo(b.tag?.title?.toLowerCase() ?? ''));
    state = [...tempList];
  }

  Future<void> addMusic(String path) async {
    log('add music from background');
    const uuid = Uuid();
    final players = AssetsAudioPlayer();
    final tagger = Audiotagger();
    if (path.endsWith('.mp3')) {
      /// get information meta from [.mp3]
      final tag = await tagger.readTags(path: path);

      /// get artwork/image from [.mp3]
      final artwork = await tagger.readArtwork(path: path);

      /// Filter where title [.mp3] not empty
      /// if [true] process to create list of music
      if (tag.title?.isNotEmpty ?? false) {
        final isExists = state.firstWhere(
          (element) => (element.pathFile ?? '').toLowerCase().contains(path.toLowerCase()),
          orElse: () => const MusicModel(),
        );
        if (isExists.tag?.title == null) {
          await players.open(Audio.file(path), autoStart: false);

          final _result = await players.current.first;
          final music = MusicModel(
            idMusic: uuid.v1(),
            artwork: artwork,
            pathFile: path,
            tag: tag,
            songDuration: _result?.audio.duration,
          );
          state = [...state, music]..sort((a, b) =>
              (a.tag?.title ?? '').toLowerCase().compareTo((b.tag?.title ?? '').toLowerCase()));
        }
      }
    }
  }

  void syncMusic() {}
  void removeMusic(String path) {
    final tempList = state.where((element) => element.pathFile != path).toList();
    state = [...tempList];
  }

  List<MusicModel> searchMusic(String query) {
    final result = state
        .where((element) => (element.tag?.title ?? '').toLowerCase().contains(query.toLowerCase()))
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
    final totalSongDuration = state.fold<int>(
      0,
      (previousValue, currentValue) => previousValue + (currentValue.songDuration?.inSeconds ?? 0),
    );
    return Duration(seconds: totalSongDuration);
  }
}

final musicProvider = StateNotifierProvider((ref) => MusicProvider());

final filteredMusic = StateProvider<List<MusicModel>>((ref) {
  final _searchQuery = ref.watch(searchQuery).state;
  final _musicProvider = ref.watch(musicProvider.state);
  var result = <MusicModel>[];
  if (_searchQuery.isEmpty) {
    result = _musicProvider;
  } else {
    result = _musicProvider
        .where((element) => (element.tag?.title ?? '').toLowerCase().contains(_searchQuery))
        .toList();
  }
  return result.isEmpty ? [] : result;
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

final futureShowListMusic = FutureProvider<void>((ref) async {
  final _musicProvider = ref.watch(musicProvider);
  const uuid = Uuid();
  final players = AssetsAudioPlayer();
  final tagger = Audiotagger();

  /// Folder to find music for platform [android], Not yet support for IOS
  Directory dir = Directory('');
  if (Platform.isAndroid) {
    dir = Directory(ConstString.androidPathStorage);
  } else {
    /// This line for another Platform [IOS/WINDOWS/LINUX/etc...]
  }

  List<FileSystemEntity> _files;

  /// Search music folder with path directory[dir] declare before
  _files = dir.listSync(recursive: true, followLinks: false);

  final tempList = <MusicModel>[];
  for (final FileSystemEntity file in _files) {
    /// Filter only file with extension [.mp3]
    if (file.path.endsWith('.mp3')) {
      final path = file.path;

      /// get information meta from [.mp3]
      final tag = await tagger.readTags(path: path);

      /// get artwork/image from [.mp3]
      final artwork = await tagger.readArtwork(path: path);

      /// Filter where title [.mp3] not empty
      /// if [true] process to create list of music
      if (tag.title?.isNotEmpty ?? false) {
        await players.open(Audio.file(path), autoStart: false);

        final _result = await players.current.first;
        final music = MusicModel(
          idMusic: uuid.v1(),
          artwork: artwork,
          pathFile: path,
          tag: tag,
          songDuration: _result?.audio.duration,
        );

        /// For Music Playing
        tempList.add(music);
      }
    }
  }
  tempList.sort(
      (a, b) => (a.tag?.title ?? '').toLowerCase().compareTo((b.tag?.title ?? '').toLowerCase()));
  _musicProvider.addListMusic(tempList);
});
