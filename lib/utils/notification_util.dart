
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationUtil{

  static final  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;
        if(!granted){
          _requestPermissions();
        }
    }
  }
  static Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // final bool? granted = await androidImplementation?.requestPermission();

    }
  }

  static Future<void> showNotificationWithNoSound(String title , String content,{String? payload,}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('chatNotificationId', 'chatNotificationName',
        channelDescription: 'chatNotificationDescription',
        playSound: false,
        styleInformation: DefaultStyleInformation(true, true));
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    const MacOSNotificationDetails macOSPlatformChannelSpecifics =
    MacOSNotificationDetails(presentSound: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, content, platformChannelSpecifics,payload: payload);
  }

}