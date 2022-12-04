import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  LocalNoticeService.e(){
    setup();
  }

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSetting);
    await localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
    tzData.initializeTimeZones();
  }


  Future<void> addNotification({String id = 'fgfdggfd', String title = 'title', String body = 'body'}) async {
    print('TIME:::: ${tz.TZDateTime.now(tz.local)}');
    await localNotificationsPlugin.zonedSchedule(
        0,
        'It is Pumba time!',
        'Have a little dance, monkey',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description', importance: Importance.high)),
        androidAllowWhileIdle: true,
        payload: "",
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}

