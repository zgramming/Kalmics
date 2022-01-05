import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/session_model.dart';
import '../../domain/repository/session_repository.dart';
import '../../utils/enum_state.dart';
import '../../utils/failure.dart';

part 'session_state.dart';

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier({
    required this.repository,
  }) : super(const SessionState());

  final SessionRepository repository;

  void get() {
    try {
      final result = repository.get();
      state = state.init(result);
    } catch (e) {
      final message = (e as CommonFailure).message;
      state = state.onError(message: message);
    }
  }

  Future<void> setSessionOnboarding({
    required bool value,
  }) async {
    try {
      final message = await repository.setOnboardingSession(value: value);
      state = state.setOnboardingState(value: value, message: message);
    } catch (e) {
      final message = (e as CommonFailure).message;
      state = state.onError(message: message);
    }
  }
}
