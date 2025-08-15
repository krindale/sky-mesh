import 'weather_module.dart';

/// Service locator for dependency injection following DIP (Dependency Inversion Principle)
/// This ensures loose coupling between components and follows SOLID principles
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final ServiceContainer _container = ServiceContainer();

  /// Register dependencies using modular approach
  void registerDependencies() {
    // Use weather module to configure all weather-related services
    WeatherModule.configureServices(_container);
  }

  /// Get registered service
  T get<T>() {
    return _container.get<T>();
  }

  /// Register a service manually (useful for testing)
  void register<T>(T Function() factory) {
    _container.registerSingleton<T>(factory);
  }

  /// Clear all services (useful for testing)
  void clear() {
    _container.clear();
  }

  /// Check if service is registered
  bool isRegistered<T>() {
    return _container.isRegistered<T>();
  }

  /// Get the container for advanced operations
  ServiceContainer get container => _container;
}