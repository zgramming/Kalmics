import 'package:equatable/equatable.dart';

enum SortByType { ascending, descending }
enum LoopModeSetting { all, single, none }

class SettingModel extends Equatable {
  final bool isPassedOnboarding;
  final bool isShuffle;
  final bool isFirstLoad;
  final LoopModeSetting loopMode;
  final Duration timerDuration;
  final SortByType sortByType;
  final String sortChoice;
  const SettingModel({
    this.isPassedOnboarding = false,
    this.isShuffle = false,
    this.isFirstLoad = true,
    this.loopMode = LoopModeSetting.all,
    this.timerDuration = Duration.zero,
    this.sortByType = SortByType.ascending,
    this.sortChoice = 'title',
  });

  @override
  List<Object> get props {
    return [
      isPassedOnboarding,
      isShuffle,
      isFirstLoad,
      loopMode,
      timerDuration,
      sortByType,
      sortChoice,
    ];
  }

  @override
  bool get stringify => true;

  SettingModel copyWith({
    bool? isPassedOnboarding,
    bool? isShuffle,
    bool? isFirstLoad,
    LoopModeSetting? loopMode,
    Duration? timerDuration,
    SortByType? sortByType,
    String? sortChoice,
  }) {
    return SettingModel(
      isPassedOnboarding: isPassedOnboarding ?? this.isPassedOnboarding,
      isShuffle: isShuffle ?? this.isShuffle,
      isFirstLoad: isFirstLoad ?? this.isFirstLoad,
      loopMode: loopMode ?? this.loopMode,
      timerDuration: timerDuration ?? this.timerDuration,
      sortByType: sortByType ?? this.sortByType,
      sortChoice: sortChoice ?? this.sortChoice,
    );
  }
}
