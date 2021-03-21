import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// For loading builder in ProviderListener
final isLoading = StateProvider.autoDispose<bool>((ref) => false);

/// Initialize Class AudioPlayers
final globalAudioPlayers = StateProvider<AssetsAudioPlayer>((ref) {
  const uuid = Uuid();
  final result = AssetsAudioPlayer.withId(uuid.v1());
  return result;
});
