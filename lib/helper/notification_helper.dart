import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../src/router/route_list.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async {
  // handle action
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    if (payload.toLowerCase().contains("reminder") || payload.toLowerCase().contains("client")) {
      navigationKey.currentState?.popAndPushNamed(RouteList.reminder);
    }
  }
}

class HelperNotification {
  static Future<void> onDidReceiveLocalNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      if (payload.toLowerCase().contains("reminder") || payload.toLowerCase().contains("client")) {
        navigationKey.currentState!.pushNamed(RouteList.reminder);
      }
    }
    // display a dialog with the notification details, tap ok to go to another page
  }

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings("@drawable/ic_launcher");
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await HelperNotification.showNotification(message, flutterLocalNotificationsPlugin, channel, true);
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      try {
        if (message.notification!.title!.toLowerCase().contains("reminder") ||
            message.notification!.title!.toLowerCase().contains("client")) {
          navigationKey.currentState?.pushNamed(RouteList.reminder);
        }
      } catch (e) {
        rethrow;
      }
    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      AndroidNotificationChannel channel, bool data) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await Future.delayed(Duration.zero);
    if (isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission()
          .then((status) async {
        await Future.delayed(Duration.zero);
        if (message.notification != null) {
          await flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
              ),
            ),
            payload: message.notification?.title.toString(),
          );
        }
      });
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions()
          .then((status) async {
        await Future.delayed(Duration.zero);
        if (message.notification != null) {
          await flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              iOS: const DarwinNotificationDetails(presentBadge: true, presentAlert: true, presentSound: true),
            ),
            payload: message.notification?.title.toString(),
          );
        }
      });
    }
  }
}
