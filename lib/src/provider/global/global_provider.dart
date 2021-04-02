import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/config/my_config.dart';

/// For loading builder in ProviderListener
final isLoading = StateProvider.autoDispose<bool>((ref) => false);

/// Global Context
final globalContext = StateProvider<BuildContext?>((ref) => null);

/// Animation Controller MusicPlayerDetailScreen
final globalSizeAnimationController = StateProvider<AnimationController?>((ref) => null);

/// Handling Toggle Search & TextFormField
final globalSearch = StateProvider.autoDispose<bool>((ref) => false);

/// Handling query Search
final searchQuery = StateProvider<String>((ref) => '');

/// Initialize Class AudioPlayers
final globalAudioPlayers = StateProvider<AssetsAudioPlayer>((ref) {
  final result = AssetsAudioPlayer.withId(ConstString.idAssetAudioPlayer);
  return result;
});

/// Global Timer to stop song when timer end
final globalTimer = StateProvider<Timer?>((ref) => null);

/// Global file artwork, this usefull for update artwork
/// When pick from storage / camera
final globalFileArtwork = StateProvider<File?>((ref) => null);
