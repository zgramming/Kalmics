import 'package:equatable/equatable.dart';

enum SortByType { ascending, descending }

class SettingModel extends Equatable {
  final bool isPassedOnboarding;
  final SortByType sortByType;
  final String sortChoice;
  const SettingModel({
    this.isPassedOnboarding = false,
    this.sortByType = SortByType.ascending,
    this.sortChoice = 'title',
  });

  @override
  List<Object> get props => [isPassedOnboarding, sortByType, sortChoice];

  @override
  bool get stringify => true;

  SettingModel copyWith({
    bool? isPassedOnboarding,
    SortByType? sortByType,
    String? sortChoice,
  }) {
    return SettingModel(
      isPassedOnboarding: isPassedOnboarding ?? this.isPassedOnboarding,
      sortByType: sortByType ?? this.sortByType,
      sortChoice: sortChoice ?? this.sortChoice,
    );
  }
}
