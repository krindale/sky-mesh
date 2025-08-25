/// Image service interface following DIP (Dependency Inversion Principle)
abstract class ImageService {
  String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
    DateTime? sunrise,
    DateTime? sunset,
  });
  
  String getRandomImagePath();
  List<String> getAvailableImages();
}