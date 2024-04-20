import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:room_master_app/domain/repositories/auth/auth_repository_impl.dart';
import 'package:room_master_app/domain/repositories/test_repository.dart';
import 'package:room_master_app/domain/repositories/test_repository_impl.dart';

import '../../domain/repositories/auth/auth_repository.dart';
import '../logger/impl/debug_logger.dart';
import '../logger/logger.dart';

part 'service_locator_initializer.dart';

class ServiceLocator {
  ServiceLocator._();

  static final _getIt = GetIt.instance;

  static void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? onDispose,
  }) {
    _getIt.registerSingleton<T>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: (param) {

      },
    );
  }

  static void registerSingletonAsync<T extends Object>(
    Future<T> Function() asyncInstance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? onDispose,
  }) {
    _getIt.registerSingletonAsync(
      asyncInstance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: onDispose,
    );
  }

  static void registerLazySingleton<T extends Object>(
    T Function() asyncInstance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? onDispose,
  }) {
    _getIt.registerLazySingleton(
      asyncInstance,
      instanceName: instanceName,
      dispose: onDispose,
    );
  }

  static void registerLazySingletonAsync<T extends Object>(
    Future<T> Function() asyncInstance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? onDispose,
  }) {
    _getIt.registerLazySingletonAsync(
      asyncInstance,
      instanceName: instanceName,
      dispose: onDispose,
    );
  }

  static T inject<T extends Object>({String? instanceName}) =>
      _getIt.get<T>(instanceName: instanceName);

  static Future<T> injectAsync<T extends Object>({String? instanceName}) =>
      _getIt.getAsync<T>(instanceName: instanceName);
}
