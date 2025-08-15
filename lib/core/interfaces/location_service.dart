import 'package:geolocator/geolocator.dart';

/// Location service interface following DIP (Dependency Inversion Principle)
abstract class LocationService {
  Future<Position> getCurrentLocation();
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
}