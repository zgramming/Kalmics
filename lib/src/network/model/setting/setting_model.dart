import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final bool isPassedOnboarding;

  const SettingModel({
    this.isPassedOnboarding = false,
  });

  @override
  List get props => [isPassedOnboarding];

  @override
  bool get stringify => true;

  SettingModel copyWith({
    bool? isPassedOnboarding,
  }) {
    return SettingModel(
      isPassedOnboarding: isPassedOnboarding ?? this.isPassedOnboarding,
    );
  }
}
