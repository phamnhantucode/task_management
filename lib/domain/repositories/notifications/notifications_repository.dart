import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/domain/notification/notification.dart';
import '../../../models/dtos/notification/notification_dto.dart';

class NotificationRepository {
  NotificationRepository._privateConstructor();

  static final NotificationRepository _instance =
      NotificationRepository._privateConstructor();

  static NotificationRepository get instance => _instance;

  final CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<void> addNotification(NotificationDto notification) =>
      _notificationCollection.doc(notification.id).set(notification.toJson());

  //update
  Future<void> updateNotification(NotificationDto notification) =>
      _notificationCollection
          .doc(notification.id)
          .update(notification.toJson());

  //mark as read
  Future<void> markAsRead(String notificationId) =>
      _notificationCollection.doc(notificationId).update({
        'isRead': true,
      });

  //mark all as read
  Future<void> markAllAsRead(String userId) => _notificationCollection
      .where('userReceiveNotificationId', isEqualTo: userId)
      .where('isRead', isEqualTo: false)
      .get()
      .then((snapshot) async => Future.wait(snapshot.docs.map((doc) async {
            final notificationDto =
                NotificationDto.fromJson(doc.data() as Map<String, dynamic>);
            return updateNotification(notificationDto.copyWith(isRead: true));
          })));

  //get Notification by id
  Future<NotificationDm?> getNotificationById(String notificationId) async {
    try {
      final doc = await _notificationCollection.doc(notificationId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()! as Map<String, dynamic>;

      return NotificationDm.fromNotificationDto(NotificationDto.fromJson(data));
    } catch (e) {
      print('Error retrieving notification: $e');
      return null; // Error occurred while retrieving the notification
    }
  }

  //get list notification by userId as userReceiver
  Stream<List<NotificationDm>> getListNotification(String userId) {
    return _notificationCollection
        .where('userReceiveNotificationId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async =>
            await Future.wait(snapshot.docs.map((doc) async {
              return NotificationDm.fromNotificationDto(
                  NotificationDto.fromJson(doc.data() as Map<String, dynamic>));
            })));
  }
}
