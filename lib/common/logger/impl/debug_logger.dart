import 'dart:io';

import '../logger.dart';
import 'package:logger/logger.dart' as l;

final class DebugLogger implements Logger {
  DebugLogger({
    l.LogFilter? filter,
    l.LogPrinter? printer,
    l.LogOutput? output,
    l.Level? level,
  }) {
    _logger = l.Logger(
      level: level,
      filter: filter,
      output: output,
      printer: printer ?? l.PrettyPrinter(colors: !Platform.isIOS),
    );
  }

  late final l.Logger _logger;

  @override
  void call(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  @override
  void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void v(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.t(message, error: error, stackTrace: stackTrace);

  @override
  void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  @override
  void wtf(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.log(l.Level.fatal, message, error: error, stackTrace: stackTrace);
}
