import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();

  static Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
    // Handle your navigation logic here if needed
  }

  // Basic Notification with Optional Image
  static Future<void> showBasicNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidDetails;

    try {
      BigPictureStyleInformation? bigPictureStyle;
      if (message.notification?.android?.imageUrl != null) {
        final response =
            await http.get(Uri.parse(message.notification!.android!.imageUrl!));
        if (response.statusCode == 200) {
          bigPictureStyle = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(response.bodyBytes)),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(response.bodyBytes)),
          );
        }
      }

      androidDetails = AndroidNotificationDetails(
        'channel_id', // replace with a descriptive channel ID
        'channel_name', // replace with a descriptive channel name
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
        playSound: true,
      );
    } catch (error) {
      androidDetails = const AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      log('Failed to load notification image: ${error.toString()}');
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode, // Use a unique ID for each notification
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(), // Optional: pass additional data
    );
  }
}
