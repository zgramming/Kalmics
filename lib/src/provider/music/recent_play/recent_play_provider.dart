import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:kalmics/src/network/my_network.dart';
import 'package:uuid/uuid.dart';

class RecentPlayProvider extends StateNotifier<List<RecentPlayModel>> {
  RecentPlayProvider([List<RecentPlayModel>? state]) : super(state ?? []);
  static const recentPlayBoxKey = 'recent_play';

  void _init(List<RecentPlayModel> recentsPlay) {
    final tempList = [...recentsPlay];
    state = [...tempList];
  }

  void add(MusicModel music) {
    const uuid = Uuid();
    final recentPlay = RecentPlayModel(music: MusicModel());

    final result = recentPlay.copyWith(id: uuid.v1(), music: music, createDate: DateTime.now());
    final box = Hive.box<RecentPlayModel>(recentPlayBoxKey);
    box.put(uuid.v1(), result);
    state = [...box.values.toList()];
  }

  void removeAllHistory() {
    final box = Hive.box<RecentPlayModel>(recentPlayBoxKey);
    box.deleteAll(box.keys);
    state = [];
  }

  void addList(List<RecentPlayModel> recentsPlay) {}

  // void setTotalListenDuration(RecentPlayModel recentPlayModel) {
  //   final box = Hive.box<RecentPlayModel>(recentPlayBoxKey);
  //   final result = state.firstWhere(
  //       (element) => element.music?.idMusic == recentPlayModel.music?.idMusic,
  //       orElse: () => RecentPlayModel());
  // }
}

final recentPlayProvider = StateNotifierProvider((ref) => RecentPlayProvider());

final initRecentPlayList = FutureProvider<List<RecentPlayModel>>((ref) async {
  final _recentPlayProvider = ref.watch(recentPlayProvider);
  final boxs = Hive.box<RecentPlayModel>(RecentPlayProvider.recentPlayBoxKey).values.toList();

  // if (boxs.isNotEmpty) {
  // }
  _recentPlayProvider._init(boxs);

  return boxs;
});

final recentsPlayList = StateProvider<List<RecentPlayModel>>((ref) {
  final recentsPlay = ref.watch(recentPlayProvider.state);

  var tempList = <RecentPlayModel>[...recentsPlay];

  ///* Sorting song by create_date
  tempList.sort((a, b) => (b.createDate!).compareTo(a.createDate!));

  ///* Remove duplicate title song
  ///
  ///* It for case if you play multiple same song, and want distinct it
  final distinct = tempList.map((e) => e.music.title).toSet();
  tempList.retainWhere((element) => distinct.remove(element.music.title));

  if (tempList.isEmpty) {
    return [];
  }

  ///* This application limit to 10 recents song
  if (tempList.length >= 10) {
    tempList = tempList.take(10).toList();
  }

  return tempList;
});

final recentsDateRangeStatistic = StateProvider.autoDispose<String>((ref) {
  final now = DateTime.now();
  return GlobalFunction.formatYM(now);
});

final recentsPlayLineChart = StateProvider<List<FlSpot>>((ref) {
  final _recentsPlay = ref.watch(recentPlayProvider.state);

  final tempListSpot = <FlSpot>[];

  for (int i = 1; i <= 12; i++) {
    final totalPlaySong = _recentsPlay
        .where((element) {
          final dateFromDatabase = DateTime(
            element.createDate!.year,
            element.createDate!.month,
          );
          final dateSearching = DateTime(
            DateTime.now().year,
            i,
          );
          return dateFromDatabase == dateSearching;
        })
        .toList()
        .length;

    tempListSpot.add(
      FlSpot(
        i.toDouble(),
        totalPlaySong.toDouble(),
      ),
    );
  }

  return tempListSpot;
});

final recentsPlayMostPlayingSong = StateProvider<Map<String, dynamic>>((ref) {
  final _recentsPlay = ref.watch(recentPlayProvider.state);

  ///* Save title song as key
  final tempMap = <String, int>{};

  for (final recent in _recentsPlay) {
    final original = tempMap[recent.music.idMusic];
    if (original == null) {
      tempMap[recent.music.idMusic] = 1;
    } else {
      final currentValue = tempMap[recent.music.idMusic] ?? 9999;
      final result = currentValue + 1;
      tempMap[recent.music.idMusic] = result;
    }
  }

  if (tempMap.isEmpty) {
    return {};
  }

  final mostPlaying = tempMap.entries.reduce((a, b) => a.value > b.value ? a : b);
  final music = _recentsPlay.firstWhere((element) => element.music.idMusic == mostPlaying.key);

  return <String, dynamic>{
    'model': music,
    'total': mostPlaying.value,
  };
});
