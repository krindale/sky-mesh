import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import '../../core/interfaces/location_service.dart';

/// Concrete implementation of LocationService using Geolocator
/// Follows SRP - only responsible for location operations
class GeolocatorService implements LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    await _checkLocationServiceAndPermissions();
    
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kIsWeb) {
        throw Exception('Cannot get location. Please ensure you\'re using HTTPS and allow location access.');
      } else {
        throw Exception('Failed to get current location: $e');
      }
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Private method to handle location service and permission checks
  Future<void> _checkLocationServiceAndPermissions() async {
    // Check if running on web and provide specific guidance
    if (kIsWeb) {
      try {
        bool serviceEnabled = await isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled. Please enable location in your browser settings.');
        }
      } catch (e) {
        throw Exception('Web location not available. Please use HTTPS or allow location access.');
      }
    } else {
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        if (kIsWeb) {
          throw Exception('Location permission denied. Please allow location access in your browser.');
        } else {
          throw Exception('Location permissions are denied');
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kIsWeb) {
        throw Exception('Location permanently blocked. Please reset site permissions in browser settings.');
      } else {
        throw Exception('Location permissions are permanently denied. Please enable in app settings.');
      }
    }
  }
}