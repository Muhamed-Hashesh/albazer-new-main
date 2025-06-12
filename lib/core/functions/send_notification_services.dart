// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;

// Future<String> getAccessToken() async {
//   final jsonString = await rootBundle.loadString(
//     'assets/notifications_key/albazar-70cdd-e6ef120fb540.json',
//   );

//   final accountCredentials =
//       auth.ServiceAccountCredentials.fromJson(jsonString);

//   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//   final client = await auth.clientViaServiceAccount(accountCredentials, scopes);

//   return client.credentials.accessToken.data;
// }

// Future<void> sendNotification(
//     {required String token,
//     required String title,
//     required String body,
//     required Map<String, String> data}) async {
//   final String accessToken = await getAccessToken();
//   const String fcmUrl =
//       'https://fcm.googleapis.com/v1/projects/albazar-70cdd/messages:send';

//        try {
//     final dio = Dio();

//     final response = await dio.post(
//       fcmUrl,
//       options: Options(
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//       ),
//       data: {
//         'message': {
//           'token': token,
//           'notification': {
//             'title': title,
//             'body': body,
//           },
//           'data': data,
//           'android': {
//             'notification': {
//               'sound': 'custom_sound',
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'channel_id': 'high_importance_channel',
//             },
//           },
//           'apns': {
//             'payload': {
//               'aps': {
//                 'sound': 'custom_sound.caf',
//                 'content-available': 1,
//               },
//             },
//           },
//         },
//       },
//     );

//     print('Notification sent: ${response.statusCode}');
//   } catch (e) {
//     print('Error sending push notification: $e');
//   }
  

  
// }

// void handleNotification(BuildContext context, Map<String, dynamic> data) {
//   String route = data['route'];
//   String id = data['id'];

//   if (route == '/product_detials') {
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //       builder: (context) => ProductDetailsScreen(productId: id)),
//     // );
//   }
// }