import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  Future<void> showPlanNotification({
    required String title,
    required String body,
    String payload = '',
  }) async {
    const uuid = Uuid();
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        uuid.v1(), 'Listen File Changes', 'Detect if files in storage is remove, add, modify',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const BigTextStyleInformation(''));
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
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
