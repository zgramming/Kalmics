import '../../data/model/session_model.dart';

abstract class SessionRepository {
  SessionModel get();
  Future<String> setOnboardingSession({
    required bool value,
  });
}
