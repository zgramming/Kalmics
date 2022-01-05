part of 'session_notifier.dart';

class SessionState extends Equatable {
  const SessionState({
    this.item = const SessionModel(),
    this.message = '',
    this.state = RequestState.empty,
  });

  final SessionModel item;
  final String message;
  final RequestState state;

  SessionState init(SessionModel value) => copyWith(item: value);
  SessionState setOnboardingState({
    required bool value,
    required String message,
  }) =>
      copyWith(
        item: item.copyWith(isAlreadyOnboarding: value),
        message: message,
      );

  SessionState onError({
    required String message,
  }) =>
      copyWith(
        message: message,
        state: RequestState.error,
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [item, message, state];

  SessionState copyWith({
    SessionModel? item,
    String? message,
    RequestState? state,
  }) {
    return SessionState(
      item: item ?? this.item,
      message: message ?? this.message,
      state: state ?? this.state,
    );
  }
}
