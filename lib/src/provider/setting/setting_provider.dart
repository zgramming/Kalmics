import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';

import '../../config/my_config.dart';
import '../../network/my_network.dart';

class SettingProvider extends StateNotifier<SettingModel> {
  SettingProvider([SettingModel? state]) : super(state ?? const SettingModel());
  static const boxSettingKey = 'boxSettingProvider';

  static const _isPassedOnboardingKey = '_isPassedOnboardingKey';
  static const _isShuffleKey = '_isShuffleKey';
  static const _loopModeKey = '_loopModeKey';
  static const _sortByTypeKey = '_sortByTypeKey';
  static const _sortChoice = '_sortChoice';
  static const _timerDuration = '_timerDuration';

  /// Save setting to flag user already success Onboardingscreen
  Future<void> setSettingOnboardingScreen({
    required bool value,
  }) async {
    final box = Hive.box(boxSettingKey);

    box.put(_isPassedOnboardingKey, value);
    state = state.copyWith(isPassedOnboarding: value);
  }

  /// Save flag setting sort [ascending/descending]
  /// Change this if hive_generator have fully support null safety
  /// So we can directly save object to hive
  Future<void> setSortByType(SortByType type) async {
    final box = Hive.box(boxSettingKey);
    final result =
        (type == SortByType.ascending) ? ConstString.ascendingValue : ConstString.descendingValue;
    box.put(_sortByTypeKey, result);
    state = state.copyWith(sortByType: type);
  }

  Future<void> setSortChoice(String choice) async {
    final box = Hive.box(boxSettingKey);
    box.put(_sortChoice, choice);
    state = state.copyWith(sortChoice: choice);
  }

  Future<void> setShuffle({required bool value}) async {
    final box = Hive.box(boxSettingKey);
    box.put(_isShuffleKey, value);
    state = state.copyWith(isShuffle: value);
  }

  /// Change this if hive_generator have fully support null safety
  /// So we can directly save object to hive
  Future<void> setLoopMode(LoopModeSetting loopMode) async {
    var value = ConstString.loopModeAll;
    var _loopMode = LoopModeSetting.all;

    /// Increate LoopMode with this scenario
    /// 1. [none => single]
    /// 2. [single => all]
    /// 3. [all => none]

    switch (loopMode) {
      case LoopModeSetting.none:
        value = ConstString.loopModelSingle;
        _loopMode = LoopModeSetting.single;
        break;
      case LoopModeSetting.single:
        value = ConstString.loopModeAll;
        _loopMode = LoopModeSetting.all;
        break;
      case LoopModeSetting.all:
        value = ConstString.loopModelNone;
        _loopMode = LoopModeSetting.none;
        break;
      default:
        value = ConstString.loopModelNone;
        _loopMode = LoopModeSetting.none;
        break;
    }

    final box = Hive.box(boxSettingKey);
    box.put(_loopModeKey, value);
    state = state.copyWith(loopMode: _loopMode);
  }

  Future<void> setTimerDuration(Duration duration) async {
    final box = Hive.box(boxSettingKey);
    box.put(_timerDuration, duration);
    state = state.copyWith(timerDuration: duration);
  }

  Future<void> readSettingProvider() async {
    final box = Hive.box(boxSettingKey);

    final sessionOnboarding =
        box.get(_isPassedOnboardingKey, defaultValue: ConstString.notFinishedOnboarding) as bool;
    final sessionSortByType =
        box.get(_sortByTypeKey, defaultValue: ConstString.ascendingValue) as int;
    final sessionSortChoice =
        box.get(_sortChoice, defaultValue: ConstString.sortChoiceByTitle) as String;
    final sessionShuffle = box.get(_isShuffleKey, defaultValue: ConstString.notUseShuffle) as bool;
    final sessionLoopMode = box.get(_loopModeKey, defaultValue: ConstString.loopModeAll) as String;

    var loopMode = LoopModeSetting.all;
    switch (sessionLoopMode) {
      case ConstString.loopModelSingle:
        loopMode = LoopModeSetting.single;
        break;

      case ConstString.loopModelNone:
        loopMode = LoopModeSetting.none;
        break;

      default:
        loopMode = LoopModeSetting.all;
        break;
    }

    state = state.copyWith(
      isPassedOnboarding: sessionOnboarding,
      sortByType: sessionSortByType == ConstString.ascendingValue
          ? SortByType.ascending
          : SortByType.descending,
      sortChoice: sessionSortChoice,
      isShuffle: sessionShuffle,
      loopMode: loopMode,
    );
  }
}

final settingProvider = StateNotifierProvider((ref) => SettingProvider());

final iconLoopMode = StateProvider.family<Widget, BuildContext>((ref, context) {
  final _settingProvider = ref.watch(settingProvider.state);

  IconData icon = Icons.loop;

  switch (_settingProvider.loopMode) {
    case LoopModeSetting.none:
      icon = Icons.repeat;
      break;
    case LoopModeSetting.single:
      icon = Icons.repeat_one_rounded;
      break;
    case LoopModeSetting.all:
      icon = Icons.repeat;
      break;
    default:
      icon = Icons.repeat_one_rounded;
      break;
  }
  final color = _settingProvider.loopMode == LoopModeSetting.all
      ? colorPallete.accentColor!
      : Colors.transparent;
  return CircleAvatar(
    backgroundColor: color,
    foregroundColor: Colors.white,
    radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
    child: FittedBox(
      child: Icon(
        icon,
        size: ConstSize.iconActionMusicPlayerDetail(context),
      ),
    ),
  );
});

final styleAscDescButton = StateProvider.family<ButtonStyle, int>((ref, value) {
  final _settingProvider = ref.watch(settingProvider.state);

  final sortBy = (_settingProvider.sortByType == SortByType.ascending)
      ? ConstString.ascendingValue
      : ConstString.descendingValue;

  if (value == sortBy) {
    return ElevatedButton.styleFrom(
      primary: colorPallete.accentColor,
      onPrimary: Colors.white,
    );
  } else {
    return ElevatedButton.styleFrom(
      primary: Colors.white,
      onPrimary: colorPallete.accentColor,
    );
  }
});
