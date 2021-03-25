import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import '../../network/my_network.dart';

class SettingProvider extends StateNotifier<SettingModel> {
  SettingProvider([SettingModel? state]) : super(state ?? const SettingModel());
  static const boxSettingKey = 'boxSettingProvider';

  static const _isPassedOnboardingKey = '_isPassedOnboardingKey';
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
  Future<void> setSortByType(SortByType type) async {
    final box = Hive.box(boxSettingKey);
    final result = (type == SortByType.ascending) ? 0 : 1;
    box.put(_sortByTypeKey, result);
    state = state.copyWith(sortByType: type);
  }

  Future<void> setSortChoice(String choice) async {
    final box = Hive.box(boxSettingKey);
    box.put(_sortChoice, choice);
    state = state.copyWith(sortChoice: choice);
  }

  Future<void> setTimerDuration(Duration duration) async {
    final box = Hive.box(boxSettingKey);
    box.put(_timerDuration, duration);
    state = state.copyWith(timerDuration: duration);
  }

  Future<void> readSettingProvider() async {
    final box = Hive.box(boxSettingKey);
    final sessionOnboarding = box.get(_isPassedOnboardingKey, defaultValue: false) as bool;
    final sessionSortByType = box.get(_sortByTypeKey, defaultValue: 0) as int;
    final sessionSortChoice = box.get(_sortChoice, defaultValue: 'title') as String;
    state = state.copyWith(
      isPassedOnboarding: sessionOnboarding,
      sortByType: sessionSortByType == 0 ? SortByType.ascending : SortByType.descending,
      sortChoice: sessionSortChoice,
    );
  }
}

final settingProvider = StateNotifierProvider((ref) => SettingProvider());

final styleAscDescButton = StateProvider.family<ButtonStyle, int>((ref, value) {
  final _settingProvider = ref.watch(settingProvider.state);

  final sortBy = (_settingProvider.sortByType == SortByType.ascending) ? 0 : 1;

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
