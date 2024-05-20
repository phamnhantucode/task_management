import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:room_master_app/common/extensions/extensions.dart';
import 'package:room_master_app/domain/repositories/notifications/notifications_repository.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/dtos/notification/action.dart';
import 'package:room_master_app/models/dtos/notification/notification_dto.dart';

import '../../models/domain/firebase_notification_dto.dart';
import '../../models/domain/notification/notification.dart';
import '../../navigation/navigation.dart';

class NotificationService {
  static final NotificationService instance =
      NotificationService._privateConstructor();

  NotificationService._privateConstructor();

  static String key =
      'AAAAIYjA4js:APA91bHb5DHvE4cOPvDSyjJqLdwsYrwcnbZhRQvLJwRJ6s2wPq68rBylZpxR5Y2PjAoNVv0MtgBv-11p3NWcvC671FKFomqkOS8ykt6cMhzexqVWYnJtsw9UaTAha761GYInZn4rfC7n';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('User declined or has not accepted permission');
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {},
    );
  }

  void firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        final title = notification!.title;
        message.data['isRead'] = (message.data['isRead'] as String).parseBool();
        getNotificationBody(context,

                NotificationDto.fromJson(message.data))
            .then((value) => showNotification(message, title, value));
      }

      // handleMessage(context, message);
    });
  }

  Future<void> showNotification(
      RemoteMessage message, String? title, String body) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        sound:
            const RawResourceAndroidNotificationSound('notification_sound_1'));

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      enableVibration: true,
      vibrationPattern: Int64List.fromList([500, 1000]),
      sound: channel.sound,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('token: $token');
    return token;
  }

  void isTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    final notification = NotificationDto.fromJson(message.data);
    log(notification.targetType.toString());
    if (notification.targetType == TargetType.project) {
      context.push(NavigationPath.detailProject, extra: notification.targetId);
    }
  }

  void pushNotifications(List<String> tokens, NotificationDto notification) {
    Future.forEach(tokens, (token) async {
      var data = {
        'to': token,
        'notification': {
          'title': notification.title,
          'body': notification.body,
          "sound": "notification_sound_1.mp3"
        },
        "data": notification.toJson(),
      };

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$key',
        },
      ).then((value) {
        if (kDebugMode) {
          print(value.body.toString());
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
      });
    });
  }

  void pushNotification(String token, NotificationDto notification) {
    var data = FirebaseNotificationDto(
        to: token,
        notification:
            FireBaseNotificationInfo(title: notification.title, body: '')
                .toJson(),
        data: notification.toJson());

    log('=>> ${jsonEncode(data.toJson())}');
    Dio()
        .post(
      'https://fcm.googleapis.com/fcm/send',
      data: data.toJson(),
      options: Options(headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$key',
      }),
    )
        .then((value) {
      if (kDebugMode) {
        print(value.data.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  Future<String> getNotificationBody(
      BuildContext context, NotificationDto notification) async {
    final notificationn = await NotificationRepository.instance
        .getNotificationById(notification.id);
    if (notificationn == null) {
      return '';
    } else if (notificationn.action == ActionNotification.changeProjectName) {
      final notify = (notificationn as NotifyChangeProjectNameDm);
      return context.l10n.text_someone_had_change_project_name(
          (notification as NotifyChangeProjectNameDto).newProjectName,
          notify.target.name,
          notify.author.firstName ?? '');
    } else {
      return '';
    }
  }
}
