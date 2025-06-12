abstract class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class GetFCMTokenLoading extends NotificationState {}

final class GetFCMTokenSuccess extends NotificationState {}

final class GetFCMTokenError extends NotificationState {
  // String errorModel;
  // GetFCMTokenError(this.errorModel);
}

final class SendFCMTokenSuccess extends NotificationState {}

final class SendFCMTokenError extends NotificationState {
  String errorModel;
  SendFCMTokenError(this.errorModel);
}

// final class GetMyNotificationsSuccess extends NotificationState {
//   NotificationModel notificationModel;
//   GetMyNotificationsSuccess(this.notificationModel);
// }

final class GetMyNotificationsError extends NotificationState {
  String errorModel;
  GetMyNotificationsError(this.errorModel);
}

final class GetMyNotificationsCountSuccess extends NotificationState {
  int notificationCount;
  GetMyNotificationsCountSuccess(this.notificationCount);
}

final class GetMyNotificationsCountError extends NotificationState {
  String errorModel;
  GetMyNotificationsCountError(this.errorModel);
}

final class UpdateNotificationsSuccess extends NotificationState {
  UpdateNotificationsSuccess();
}

final class UpdateNotificationsError extends NotificationState {
  String errorModel;
  UpdateNotificationsError(this.errorModel);
}

final class MarkAsReadNSuccess extends NotificationState {
  MarkAsReadNSuccess();
}
