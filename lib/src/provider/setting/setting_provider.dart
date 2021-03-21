import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../network/my_network.dart';

class SettingProvider extends StateNotifier<SettingModel> {
  SettingProvider([SettingModel? state]) : super(state ?? const SettingModel());
  static const _keyBox = 'boxSettingProvider';
  static const _isPassedOnboardingKey = '_isPassedOnboardingKey';

  /// Save setting to flag user already success Onboardingscreen
  Future<void> saveSettingOnboardingScreen({
    required bool value,
  }) async {
    final box = Hive.box<bool>(_keyBox);

    box.put(_isPassedOnboardingKey, value);
    state = state.copyWith(isPassedOnboarding: value);
  }

  Future<void> readSettingProvider() async {
    final box = await Hive.openBox<bool>(_keyBox);
    final bool sessionOnboarding = box.get(_isPassedOnboardingKey, defaultValue: false) ?? false;
    state = state.copyWith(isPassedOnboarding: sessionOnboarding);
  }
}

final settingProvider = StateNotifierProvider((ref) => SettingProvider());
