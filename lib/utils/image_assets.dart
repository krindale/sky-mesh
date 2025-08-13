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
  
  // 시간대별 도시들
  static const Map<String, List<String>> timezonesCities = {
    'utc_minus_3': ['buenos_aires', 'rio_de_janeiro', 'santiago', 'sao_paulo'],
    'utc_minus_5': ['boston', 'miami', 'new_york', 'toronto', 'washington_dc'],
    'utc_minus_6': ['chicago', 'mexico_city'],
    'utc_minus_8': ['los_angeles', 'san_francisco', 'seattle', 'vancouver'],
    'utc_plus_0': ['casablanca', 'london'],
    'utc_plus_1': ['amsterdam', 'barcelona', 'berlin', 'paris', 'prague', 'rome', 'stockholm', 'vienna', 'zurich'],
    'utc_plus_2': ['cairo', 'johannesburg', 'tel_aviv'],
    'utc_plus_3': ['istanbul', 'moscow', 'nairobi', 'riyadh'],
    'utc_plus_3_30': ['tehran'],
    'utc_plus_4': ['dubai'],
    'utc_plus_5_30': ['bangalore', 'mumbai'],
    'utc_plus_7': ['bangkok', 'ho_chi_minh', 'jakarta'],
    'utc_plus_8': ['beijing', 'kuala_lumpur', 'manila', 'singapore'],
    'utc_plus_9': ['seoul', 'tokyo'],
    'utc_plus_10': ['sydney'],
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
    
    // 시간대별 도시 이미지들 추가
    timezonesCities.forEach((timezone, cities) {
      for (String city in cities) {
        for (String weather in weatherTypes) {
          allPaths.add('$_baseLocationPath/timezones/$timezone/${city}_$weather.png');
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
    
    // 시간대별 도시 이미지들에서 해당 날씨 찾기
    timezonesCities.forEach((timezone, cities) {
      for (String city in cities) {
        weatherPaths.add('$_baseLocationPath/timezones/$timezone/${city}_$weather.png');
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
    
    // 시간대별로 도시 찾기
    for (MapEntry<String, List<String>> entry in timezonesCities.entries) {
      if (entry.value.contains(city)) {
        return '$_baseLocationPath/timezones/${entry.key}/${city}_$weather.png';
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