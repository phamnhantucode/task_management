part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default([]) List<NotificationDm> notifications,
    @Default([]) List<NotificationDm> notificationsUnRead,
    String? error,
  }) = _NotificationState;
}
