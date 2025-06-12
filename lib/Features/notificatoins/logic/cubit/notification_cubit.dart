import 'dart:developer';
import 'package:albazar_app/Features/notificatoins/logic/cubit/notification_state.dart';
import 'package:albazar_app/Features/notificatoins/notifications_factory.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  // final NotificationFactory notificationFactory;
  // final NotificationRepo notificationRepository;

  NotificationCubit(NotificationFactory notificationFactory)
      : super(NotificationInitial());
  static NotificationCubit get(context) => BlocProvider.of(context);
  final Dio dio = Dio();
  Future<void> updateNotification({String? userToken, String? fcmToken}) async {
    emit(GetFCMTokenLoading());
    await dio.put(AppUrls.updateToken,
        options: Options(headers: {
          "Authorization": "Bearer $userToken",
          "Content-Type": "application/json",
        }),
        data: {
          "fcmToken": fcmToken,
        }).then((v) {
      if (v.statusCode == 200) {
        log("FCM Token Updated Successfully");
        emit(GetFCMTokenSuccess());
      } else {
        log("Error In Update FCM Token");
        emit(GetFCMTokenError());
      }
    }).catchError((e, s) {
      if (e is DioException) {
        log("Error In Update FCM Token: ${e.response?.data} StackTrace: $s");
        emit(GetFCMTokenError());
      } else {
        log("Error In Update FCM Token: $e  StackTrace: $s");
        emit(GetFCMTokenError());
      }
    });
  }
}
