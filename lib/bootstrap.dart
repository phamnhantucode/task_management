import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_master_app/common/constant.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'common/di/service_locator.dart';
import 'common/error_screen.dart';
import 'common/logger/logger.dart';

Future<void> initializeFlutterApp() async {

  final logger = ServiceLocator.inject<Logger>();
  FlutterError.onError = (FlutterErrorDetails details) {
    logger(details.exceptionAsString(), stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logger(error.toString(), error: error, stackTrace: stack);
    return true;
  };

  EquatableConfig.stringify = true;
  Bloc.observer = AppBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  ErrorWidget.builder = (details) => ErrorScreen(details: details);


  Gemini.init(
    apiKey: AppConstants.apiKey,
  );

  runApp(const App());
}
