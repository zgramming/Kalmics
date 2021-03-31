import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:kalmics/src/network/my_network.dart';

part 'recent_play_model.g.dart';

@HiveType(typeId: 3)
class RecentPlayModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final MusicModel music;
  @HiveField(2)
  final DateTime? createDate;

  RecentPlayModel({
    this.id = '',
    required this.music,
    this.createDate,
  });

  @override
  // TODO: implement props
  List get props => [id, music, createDate];

  @override
  bool get stringify => true;

  RecentPlayModel copyWith({
    String? id,
    MusicModel? music,
    DateTime? createDate,
    Duration? totalListenSong,
  }) {
    return RecentPlayModel(
      id: id ?? this.id,
      music: music ?? this.music,
      createDate: createDate ?? this.createDate,
    );
  }
}
