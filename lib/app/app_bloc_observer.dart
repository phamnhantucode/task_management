import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/di/service_locator.dart';
import '../common/logger/logger.dart';

final class AppBlocObserver extends BlocObserver {
  final _logger = ServiceLocator.inject<Logger>();
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.v('onChange: ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
