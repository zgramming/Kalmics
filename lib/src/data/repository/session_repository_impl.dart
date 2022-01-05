import '../../domain/repository/session_repository.dart';
import '../../utils/failure.dart';
import '../datasource/session_local_datasource.dart';
import '../model/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl({
    required this.localDataSource,
  });

  final SessionLocalDataSource localDataSource;

  @override
  SessionModel get() {
    try {
      final result = localDataSource.get();
      return result;
    } catch (e) {
      throw CommonFailure(e.toString());
    }
  }

  @override
  Future<String> setOnboardingSession({required bool value}) async {
    try {
      final result = await localDataSource.setOnboardingSession(value: value);
      return result;
    } catch (e) {
      throw CommonFailure(e.toString());
    }
  }
}
