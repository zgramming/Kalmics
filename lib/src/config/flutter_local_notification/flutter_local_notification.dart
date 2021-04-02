import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/network/my_network.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ConfigFlutterLocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init({
    required Future Function(String? payload) onSelectNotification,
  }) {
    /// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    /// This application right now only supports the android platform
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<String?> _generateLargeIconNotification(
    BuildContext context, {
    required String pathFile,
  }) async {
    final _music = context
        .read(musicProvider.state)
        .firstWhere((element) => element.pathFile == pathFile, orElse: () => MusicModel());
    if (_music.idMusic.isNotEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${basenameWithoutExtension(pathFile)}';
      final fileLargeIcon = File(path);
      Uint8List byteFile;
      if (_music.artwork == null) {
        byteFile = (await rootBundle.load(appConfig.fullPathImageAsset)).buffer.asUint8List();
      } else {
        byteFile = _music.artwork!;
      }

      fileLargeIcon.writeAsBytes(byteFile);
      return fileLargeIcon.path;
    } else {
      return null;
    }
  }

  Future<void> showNotificationChangesToSong({
    required String title,
    required String body,
    required String pathFile,
    required BuildContext context,
    String payload = '',
  }) async {
    const uuid = Uuid();
    final generateLargeIcon =
        await _generateLargeIconNotification(context, pathFile: pathFile) ?? '';

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      uuid.v1(),
      'Listen File Changes',
      'Detect if files in storage is remove, add, modify',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      largeIcon: FilePathAndroidBitmap(generateLargeIcon),
      styleInformation: const BigTextStyleInformation(''),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    final now = DateTime.now();
    final String id = '${now.second}${now.millisecond}';
    await flutterLocalNotificationsPlugin.show(
      int.tryParse(id) ?? 0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
