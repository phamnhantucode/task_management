import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_master_app/domain/repositories/notifications/notifications_repository.dart';

import '../../../models/domain/notification/notification.dart';

part 'notification_state.dart';
part 'notification_cubit.freezed.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  late StreamSubscription _notificationSubscription;
  late String _userId;

  void init(String userId) {
    _userId = userId;
    _notificationSubscription = NotificationRepository.instance
        .getListNotification(userId)
        .listen((notifications) {
      final notificationsUnRead = notifications.where((element) => !element.isRead).toList();
      final notificationRecent = notifications.where((element) => element.isRead).toList();
      emit(NotificationState(notifications: notificationRecent, notificationsUnRead: notificationsUnRead, error: null));
    }, onError: (error) {
      emit(NotificationState(notifications: [], notificationsUnRead: [], error: error.toString()));
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription.cancel();
    return super.close();
  }
}
