import '../../core/interfaces/image_service.dart';
import '../../utils/image_assets.dart';
import '../../services/location_image_service.dart' as legacy;

/// Concrete implementation of ImageService following SRP
/// Only responsible for image selection and management
class LocationImageServiceImpl implements ImageService {
  @override
  String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
  }) {
    // Delegate to existing LocationImageService for now
    // This maintains backward compatibility while following new architecture
    return legacy.LocationImageService.selectBackgroundImage(
      cityName: cityName,
      countryCode: countryCode,
      weatherDescription: weatherDescription,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  String getRandomImagePath() {
    return ImageAssets.getRandomImagePath();
  }

  @override
  List<String> getAvailableImages() {
    // This could be expanded to return all available image paths
    // For now, return empty list as the original implementation doesn't provide this
    return [];
  }
}