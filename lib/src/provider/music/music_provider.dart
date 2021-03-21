import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/network/model/music/music_model.dart';
import 'package:uuid/uuid.dart';

class MusicProvider extends StateNotifier<List<MusicModel>> {
  MusicProvider([List<MusicModel>? state]) : super(state ?? []);

  void addListMusic(List<MusicModel> musics) {
    final tempState = state;
    final tempList = <MusicModel>[];
    for (final MusicModel music in musics) {
      final isExists = tempState.any((element) => element.tag?.title == music.tag?.title);
      if (!isExists) {
        tempList.add(music);
      }
    }

    tempList.sort((a, b) {
      return (a.tag?.title?.toLowerCase() ?? '').compareTo(b.tag?.title?.toLowerCase() ?? '');
    });

    state = [...tempList];
  }
}

final musicProvider = StateNotifierProvider((ref) => MusicProvider());

final futureShowListMusic = FutureProvider<List<MusicModel>>((ref) async {
  final _musicProvider = ref.watch(musicProvider);
  const uuid = Uuid();
  final players = AssetsAudioPlayer();
  final tagger = Audiotagger();

  /// Folder to find music for platform [android], Not yet support for IOS
  Directory dir = Directory('');
  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/');
  } else {
    /// This line for another Platform [IOS/WINDOWS/LINUX/etc...]
  }

  List<FileSystemEntity> _files;
  final List<MusicModel> _tempMusic = [];

  /// Search music folder with path directory[dir] declare before
  _files = dir.listSync(recursive: true, followLinks: false);

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
          totalDuration: _result?.audio.duration,
        );

        /// For Music Playing
        _tempMusic.add(music);
      }
    }
  }

  /// Add list of music to [musicProvider]
  _musicProvider.addListMusic(_tempMusic);
  return _tempMusic;
});
