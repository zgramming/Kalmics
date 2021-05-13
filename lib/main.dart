import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import './src/app.dart';
import './src/network/my_network.dart';
import './src/provider/my_provider.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 4;

  @override
  void write(BinaryWriter writer, Duration value) => writer.writeInt(value.inMicroseconds);

  @override
  Duration read(BinaryReader reader) => Duration(microseconds: reader.readInt());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(MusicModelAdapter())
    ..registerAdapter(TagMetaDataModelAdapter())
    ..registerAdapter(RecentPlayModelAdapter())
    ..registerAdapter(DurationAdapter());

  await Hive.openBox(SettingProvider.boxSettingKey);
  await Hive.openBox<MusicModel>(MusicProvider.musicBoxKey);
  await Hive.openBox<RecentPlayModel>(RecentPlayProvider.recentPlayBoxKey);

  colorPallete.configuration(
    primaryColor: const Color(0xFF52057b),
    accentColor: const Color(0xFF7B0569),
    monochromaticColor: const Color(0xFF7307AC),
    onboardingColor1: const Color(0xFFDE385E),
    onboardingColor2: const Color(0xFFA70071),
    onboardingColor3: const Color(0xFF52057B),
  );

  timeago.setLocaleMessages('id', timeago.IdMessages());
  appConfig.configuration(nameLogoAsset: 'Kalmics.png');

  runApp(ProviderScope(child: MyApp()));
}
