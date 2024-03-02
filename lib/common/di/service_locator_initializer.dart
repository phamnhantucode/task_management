part of 'service_locator.dart';

abstract interface class ServiceLocatorInitializer {
  ServiceLocatorInitializer._();

  static void init() {
    _configureAppModule();
    _configureNetworkModule();
  }

  static void _configureNetworkModule() {
    ServiceLocator.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);

    ServiceLocator.registerSingleton<TestRepository>(
        TestRepositoryImpl(ServiceLocator.inject()));
  }

  static void _configureAppModule() {
    ServiceLocator.registerLazySingleton<Logger>(() {
      final Logger logger = DebugLogger();
      return logger;
    });
  }
}
