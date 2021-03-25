import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:kalmics/src/provider/my_provider.dart';

import 'src/app.dart';

const musicBox = 'musicBox';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  appConfig.configuration(nameLogoAsset: 'Kalmics.png');

  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //custom action
    return true; //true : handled, does not notify others listeners
    //false : enable others listeners to handle it
  });

  AssetsAudioPlayer.addNotificationOpenAction((notification) {
    //custom action
    return false; //true : handled, does not notify others listeners
    //false : enable others listeners to handle it
  });

  await Hive.initFlutter();
  await Hive.openBox(SettingProvider.boxSettingKey);
  colorPallete.configuration(
    primaryColor: const Color(0xFF52057b),
    accentColor: const Color(0xFFA70071),
    monochromaticColor: const Color(0xFF7307AC),
    onboardingColor1: const Color(0xFFDE385E),
    onboardingColor2: const Color(0xFFA70071),
    onboardingColor3: const Color(0xFF52057B),
  );
  runApp(ProviderScope(child: MyApp()));
}
