import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/my_config.dart';

/// Initialize Class AudioPlayers
final globalAudioPlayers = StateProvider<AssetsAudioPlayer>((ref) {
  final result = AssetsAudioPlayer.withId(ConstString.idAssetAudioPlayer);
  return result;
});

/// For loading builder in ProviderListener
final isLoading = StateProvider.autoDispose<bool>((ref) => false);

/// Global Context
final globalContext = StateProvider<BuildContext?>((ref) => null);

/// Handling Toggle Search & TextFormField
final isModeSearch = StateProvider.autoDispose<bool>((ref) => false);

/// Handling query Search
final searchQuery = StateProvider.autoDispose<String>((ref) => '');

/// Global remaining timer
final globalRemainingTimer = StateProvider<int>((ref) => -1);

/// Global Timer
final globalTimer = StateProvider<Timer?>((ref) => null);

/// Global file artwork, this usefull for update artwork
/// When pick from storage / camera
final globalFileArtwork = StateProvider.autoDispose<File?>((ref) => null);
