import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'src/data/datasource/session_local_datasource.dart';
import 'src/data/repository/session_repository_impl.dart';
import 'src/domain/repository/session_repository.dart';
import 'src/presentation/riverpod/session_notifier.dart';
import 'src/utils/constant.dart';

///! Riverpod
final sessionNotifier = StateNotifierProvider<SessionNotifier, SessionState>(
  (ref) => SessionNotifier(
    repository: ref.watch(_sessionRepository),
  ),
);

///! End Riverpod

///! Repository
final _sessionRepository = Provider<SessionRepository>(
  (ref) => SessionRepositoryImpl(
    localDataSource: ref.watch(_sessionLocalDataSource),
  ),
);

///! End Repository

///! Remote DataSource
///! End Remote DataSource

///! Local DataSource
final _sessionLocalDataSource = Provider<SessionLocalDataSource>(
  (ref) => SessionLocalDataSourceImpl(
    sessionOnboardingBox: ref.watch(_sessionOnboardingBox),
  ),
);

///! End Local DataSource

///! Utils
final _sessionOnboardingBox = Provider<Box<bool>>(
  (ref) => Hive.box(sessionOnboardingHiveKey),
);
///! End Utils
