import 'dart:developer';
import 'package:albazar_app/core/errors/firebase_error_handeler.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationFactory {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase Messaging and request permissions

  Future<Either<dynamic, bool>> initialize() async {
    log("NotificationFactory.initialize() called");
    try {
      final permission = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log("Notification permissions granted: ${permission.authorizationStatus}");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Foreground Notification: ${message.notification?.title}");
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      final tokenResult = await getFCMToken();
      tokenResult.fold(
        (error) => log("Error fetching FCM token: $error"),
        (token) => log("FCM Token: $token"),
      );

      return right(true);
    } catch (e) {
      log("Error in NotificationFactory.initialize(): $e");
      return left(e.toString());
    }
  }

  // Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log("Background Notification: ${message.notification?.title}");
  }

  // Get the current FCM token
  Future<Either<dynamic, String>> getFCMToken() async {
    log("Get FCM Token In Factory Function");
    try {
      final response = await _firebaseMessaging.getToken();
      log("FCM Token In Factory Function :- $response");
      return right(response.toString());
    } on FirebaseException catch (e) {
      log("Error In Get FCM Token :- ${e.toString()}");
      return left(FirebaseMessagingHandler.handleMessagingError(e));
    } catch (e) {
      return left(e.toString());
    }
  }

  // Listen for token refresh
  void onTokenRefresh(void Function(String token) callback) {
    log("Refresh FCM Token In Factory Function");
    _firebaseMessaging.onTokenRefresh.listen(callback);
  }
}
