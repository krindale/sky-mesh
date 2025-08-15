import '../interfaces/weather_repository.dart';
import '../interfaces/location_service.dart';
import '../interfaces/image_service.dart';
import '../interfaces/weather_interfaces.dart';
import '../../data/services/openweather_api_service.dart';
import '../../data/services/geolocator_service.dart';
import '../../data/services/location_image_service_impl.dart';

/// Weather module for dependency injection following DIP
/// This module defines how weather-related dependencies are wired together
class WeatherModule {
  static void configureServices(ServiceContainer container) {
    // Register core services
    container.registerSingleton<LocationService>(() => GeolocatorService());
    container.registerSingleton<ImageService>(() => LocationImageServiceImpl());
    
    // Register weather services following ISP
    container.registerSingleton<WeatherRepository>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    // Register specific weather service interfaces
    container.registerSingleton<CurrentWeatherService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    container.registerSingleton<WeatherForecastService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    container.registerSingleton<RandomWeatherService>(() => OpenWeatherApiService(
      locationService: container.get<LocationService>(),
    ));
    
    // Register configuration service
    container.registerSingleton<WeatherConfigurationService>(() => WeatherConfiguration());
    
    // Register validator
    container.registerSingleton<WeatherDataValidator>(() => WeatherDataValidatorImpl());
  }
}

/// Simple service container for dependency injection
class ServiceContainer {
  final Map<Type, dynamic Function()> _factories = {};
  final Map<Type, dynamic> _singletons = {};

  void registerSingleton<T>(T Function() factory) {
    _factories[T] = factory;
  }

  void registerTransient<T>(T Function() factory) {
    _factories[T] = factory;
  }

  T get<T>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    final factory = _factories[T];
    if (factory == null) {
      throw Exception('Service of type $T is not registered');
    }

    final instance = factory() as T;
    _singletons[T] = instance;
    return instance;
  }

  bool isRegistered<T>() {
    return _factories.containsKey(T);
  }

  void clear() {
    _factories.clear();
    _singletons.clear();
  }
}

/// Implementation of weather configuration service
class WeatherConfiguration implements WeatherConfigurationService {
  String _apiKey = 'a179131038d53e44738851b4938c5cd0';
  String _units = 'metric';
  Duration _timeout = const Duration(seconds: 10);

  @override
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  @override
  void setUnits(String units) {
    if (['metric', 'imperial', 'kelvin'].contains(units)) {
      _units = units;
    } else {
      throw ArgumentError('Invalid units: $units. Must be metric, imperial, or kelvin');
    }
  }

  @override
  void setTimeout(Duration timeout) {
    _timeout = timeout;
  }

  @override
  String get currentUnits => _units;

  @override
  Duration get currentTimeout => _timeout;

  String get apiKey => _apiKey;
}

/// Implementation of weather data validator
class WeatherDataValidatorImpl implements WeatherDataValidator {
  @override
  bool isValidWeatherData(data) {
    if (data == null) return false;
    
    return isValidTemperature(data.temperature) &&
           isValidHumidity(data.humidity) &&
           data.cityName.isNotEmpty &&
           data.country.isNotEmpty &&
           data.description.isNotEmpty;
  }

  @override
  bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 &&
           longitude >= -180 && longitude <= 180;
  }

  @override
  bool isValidTemperature(double temperature) {
    // Reasonable temperature range in Celsius: -100 to +60
    return temperature >= -100 && temperature <= 60;
  }

  @override
  bool isValidHumidity(int humidity) {
    return humidity >= 0 && humidity <= 100;
  }
}