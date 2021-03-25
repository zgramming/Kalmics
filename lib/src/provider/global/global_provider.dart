import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// For loading builder in ProviderListener
final isLoading = StateProvider<bool>((ref) => false);

/// Animation Controller MusicPlayerDetailScreen
final globalSizeAnimationController = StateProvider<AnimationController?>((ref) => null);

/// Handling Toggle Search & TextFormField
final globalSearch = StateProvider.autoDispose<bool>((ref) => false);

/// Handling query Search
final searchQuery = StateProvider<String>((ref) => '');

/// Initialize Class AudioPlayers
final globalAudioPlayers = StateProvider<AssetsAudioPlayer>((ref) {
  const uuid = Uuid();
  final result = AssetsAudioPlayer.withId(uuid.v1());
  return result;
});

final globalTimer = StateProvider<Timer?>((ref) {});
