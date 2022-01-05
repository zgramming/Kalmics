import 'package:hive_flutter/hive_flutter.dart';

import '../model/session_model.dart';

abstract class SessionLocalDataSource {
  SessionModel get();
  Future<String> setOnboardingSession({
    required bool value,
  });
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  const SessionLocalDataSourceImpl({
    required this.sessionOnboardingBox,
  });

  final Box<bool> sessionOnboardingBox;

  String get _keyOnboarding => 'onboarding';

  @override
  SessionModel get() {
    final getSessionOnboarding = sessionOnboardingBox.get(_keyOnboarding) ?? false;
    return SessionModel(isAlreadyOnboarding: getSessionOnboarding);
  }

  @override
  Future<String> setOnboardingSession({
    required bool value,
  }) async {
    await sessionOnboardingBox.put(_keyOnboarding, value);
    return 'Berhasil menyimpan session onboarding';
  }
}
