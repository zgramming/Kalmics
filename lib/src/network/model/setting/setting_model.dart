import 'package:equatable/equatable.dart';

enum SortByType { ascending, descending }

class SettingModel extends Equatable {
  final bool isPassedOnboarding;
  final SortByType sortByType;
  final String sortChoice;
  final Duration timerDuration;
  const SettingModel({
    this.isPassedOnboarding = false,
    this.sortByType = SortByType.ascending,
    this.sortChoice = 'title',
    this.timerDuration = Duration.zero,
  });

  @override
  List<Object> get props => [isPassedOnboarding, sortByType, sortChoice, timerDuration];

  @override
  bool get stringify => true;

  SettingModel copyWith({
    bool? isPassedOnboarding,
    SortByType? sortByType,
    String? sortChoice,
    Duration? timerDuration,
  }) {
    return SettingModel(
      isPassedOnboarding: isPassedOnboarding ?? this.isPassedOnboarding,
      sortByType: sortByType ?? this.sortByType,
      sortChoice: sortChoice ?? this.sortChoice,
      timerDuration: timerDuration ?? this.timerDuration,
    );
  }
}
