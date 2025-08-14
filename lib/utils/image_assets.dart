import 'dart:math';

/// Asset 이미지 경로 관리 클래스
class ImageAssets {
  static const String _baseLocationPath = 'assets/location_images';
  
  // 날씨 타입
  static const List<String> weatherTypes = [
    'cloudy',
    'foggy', 
    'rainy',
    'snowy',
    'sunny',
    'sunset',
  ];
  
  // 지역별 도시들
  static const Map<String, List<String>> regionCities = {
    'asia': ['seoul', 'tokyo', 'beijing', 'bangkok', 'singapore', 'manila', 'jakarta', 'kuala_lumpur', 'ho_chi_minh', 'bangalore', 'mumbai', 'shanghai', 'taipei'],
    'middle_east': ['dubai', 'tehran', 'riyadh', 'tel_aviv'],
    'europe': ['paris', 'london', 'berlin', 'rome', 'amsterdam', 'barcelona', 'prague', 'stockholm', 'vienna', 'zurich', 'moscow', 'istanbul'],
    'north_america': ['new_york', 'los_angeles', 'san_francisco', 'seattle', 'chicago', 'boston', 'miami', 'washington_dc', 'toronto', 'vancouver', 'mexico_city'],
    'south_america': ['buenos_aires', 'rio_de_janeiro', 'santiago', 'sao_paulo'],
    'africa': ['cairo', 'johannesburg', 'nairobi', 'casablanca', 'lagos'],
    'oceania': ['sydney', 'melbourne'],
  };
  
  // 지역별 fallback 이미지들
  static const List<String> regionalFallbacks = [
    'central_asia',
    'china_inland',
    'east_africa',
    'eastern_europe',
    'northern_andes',
    'northern_india',
    'oceania_extended',
    'southeast_asia_extended',
    'southern_china',
    'west_africa',
  ];
  
  /// 모든 가능한 이미지 경로 목록을 생성
  static List<String> getAllImagePaths() {
    List<String> allPaths = [];
    
    // 지역별 도시 이미지들 추가
    regionCities.forEach((region, cities) {
      for (String city in cities) {
        for (String weather in weatherTypes) {
          allPaths.add('$_baseLocationPath/regions/$region/${city}_$weather.png');
        }
      }
    });
    
    // 지역별 fallback 이미지들 추가
    for (String region in regionalFallbacks) {
      for (String weather in weatherTypes) {
        allPaths.add('$_baseLocationPath/regional_fallback/$region/${region}_$weather.png');
      }
    }
    
    return allPaths;
  }
  
  /// 랜덤한 이미지 경로 반환
  static String getRandomImagePath() {
    final allPaths = getAllImagePaths();
    final random = Random();
    return allPaths[random.nextInt(allPaths.length)];
  }
  
  /// 특정 날씨 타입의 랜덤 이미지 경로 반환
  static String getRandomImagePathByWeather(String weather) {
    if (!weatherTypes.contains(weather)) {
      throw ArgumentError('Invalid weather type: $weather');
    }
    
    List<String> weatherPaths = [];
    
    // 지역별 도시 이미지들에서 해당 날씨 찾기
    regionCities.forEach((region, cities) {
      for (String city in cities) {
        weatherPaths.add('$_baseLocationPath/regions/$region/${city}_$weather.png');
      }
    });
    
    // 지역별 fallback 이미지들에서 해당 날씨 찾기
    for (String region in regionalFallbacks) {
      weatherPaths.add('$_baseLocationPath/regional_fallback/$region/${region}_$weather.png');
    }
    
    final random = Random();
    return weatherPaths[random.nextInt(weatherPaths.length)];
  }
  
  /// 특정 도시의 이미지 경로 반환
  static String? getCityImagePath(String city, String weather) {
    if (!weatherTypes.contains(weather)) {
      return null;
    }
    
    // 지역별로 도시 찾기
    for (MapEntry<String, List<String>> entry in regionCities.entries) {
      if (entry.value.contains(city)) {
        return '$_baseLocationPath/regions/${entry.key}/${city}_$weather.png';
      }
    }
    
    return null;
  }
  
  /// 특정 지역의 fallback 이미지 경로 반환
  static String? getRegionalFallbackPath(String region, String weather) {
    if (!weatherTypes.contains(weather) || !regionalFallbacks.contains(region)) {
      return null;
    }
    
    return '$_baseLocationPath/regional_fallback/$region/${region}_$weather.png';
  }
}