import 'dart:math';

class LocationImageService {
  // 도시별 이미지 매핑 (우선순위 1)
  static const Map<String, List<String>> _cityImages = {
    // 아시아
    'seoul': ['seoul'],
    'tokyo': ['tokyo'], 
    'beijing': ['beijing'],
    'bangkok': ['bangkok'],
    'singapore': ['singapore'],
    'manila': ['manila'],
    'jakarta': ['jakarta'],
    'kuala_lumpur': ['kuala_lumpur'],
    'ho_chi_minh': ['ho_chi_minh'],
    'bangalore': ['bangalore'],
    'mumbai': ['mumbai'],
    'shanghai': ['shanghai'],
    'taipei': ['taipei'],
    
    // 중동
    'dubai': ['dubai'],
    'tehran': ['tehran'],
    'riyadh': ['riyadh'],
    'tel_aviv': ['tel_aviv'],
    
    // 유럽
    'paris': ['paris'],
    'london': ['london'],
    'berlin': ['berlin'],
    'rome': ['rome'],
    'amsterdam': ['amsterdam'],
    'barcelona': ['barcelona'],
    'prague': ['prague'],
    'stockholm': ['stockholm'],
    'vienna': ['vienna'],
    'zurich': ['zurich'],
    'moscow': ['moscow'],
    'istanbul': ['istanbul'],
    
    // 북미
    'new_york': ['new_york'],
    'los_angeles': ['los_angeles'],
    'san_francisco': ['san_francisco'],
    'seattle': ['seattle'],
    'chicago': ['chicago'],
    'boston': ['boston'],
    'miami': ['miami'],
    'washington_dc': ['washington_dc'],
    'toronto': ['toronto'],
    'vancouver': ['vancouver'],
    'mexico_city': ['mexico_city'],
    
    // 남미  
    'buenos_aires': ['buenos_aires'],
    'rio_de_janeiro': ['rio_de_janeiro'],
    'santiago': ['santiago'],
    'sao_paulo': ['sao_paulo'],
    
    // 아프리카
    'cairo': ['cairo'],
    'johannesburg': ['johannesburg'],
    'nairobi': ['nairobi'],
    'casablanca': ['casablanca'],
    'lagos': ['lagos'],
    
    // 오세아니아
    'sydney': ['sydney'],
    'melbourne': ['melbourne'],
  };

  // 도시별 위도/경도 정보 (거리 계산용)
  static const Map<String, List<double>> _cityCoordinates = {
    // 아시아
    'seoul': [37.5665, 126.9780],
    'tokyo': [35.6762, 139.6503],
    'beijing': [39.9042, 116.4074],
    'bangkok': [13.7563, 100.5018],
    'singapore': [1.3521, 103.8198],
    'manila': [14.5995, 120.9842],
    'jakarta': [-6.2088, 106.8456],
    'kuala_lumpur': [3.1390, 101.6869],
    'ho_chi_minh': [10.8231, 106.6297],
    'bangalore': [12.9716, 77.5946],
    'mumbai': [19.0760, 72.8777],
    'shanghai': [31.2304, 121.4737],
    'taipei': [25.0330, 121.5654],
    
    // 중동
    'dubai': [25.2048, 55.2708],
    'tehran': [35.6892, 51.3890],
    'riyadh': [24.7136, 46.6753],
    'tel_aviv': [32.0853, 34.7818],
    
    // 유럽
    'paris': [48.8566, 2.3522],
    'london': [51.5074, -0.1278],
    'berlin': [52.5200, 13.4050],
    'rome': [41.9028, 12.4964],
    'amsterdam': [52.3676, 4.9041],
    'barcelona': [41.3851, 2.1734],
    'prague': [50.0755, 14.4378],
    'stockholm': [59.3293, 18.0686],
    'vienna': [48.2082, 16.3738],
    'zurich': [47.3769, 8.5417],
    'moscow': [55.7558, 37.6176],
    'istanbul': [41.0082, 28.9784],
    
    // 북미
    'new_york': [40.7128, -74.0060],
    'los_angeles': [34.0522, -118.2437],
    'san_francisco': [37.7749, -122.4194], // Mountain View: 37.3861, -122.0839와 가장 가까운 도시
    'seattle': [47.6062, -122.3321],
    'chicago': [41.8781, -87.6298],
    'boston': [42.3601, -71.0589],
    'miami': [25.7617, -80.1918],
    'washington_dc': [38.9072, -77.0369],
    'toronto': [43.6532, -79.3832],
    'vancouver': [49.2827, -123.1207],
    'mexico_city': [19.4326, -99.1332],
    
    // 남미
    'buenos_aires': [-34.6118, -58.3960],
    'rio_de_janeiro': [-22.9068, -43.1729],
    'santiago': [-33.4489, -70.6693],
    'sao_paulo': [-23.5505, -46.6333],
    
    // 아프리카
    'cairo': [30.0444, 31.2357],
    'johannesburg': [-26.2041, 28.0473],
    'nairobi': [-1.2921, 36.8219],
    'casablanca': [33.5731, -7.5898],
    'lagos': [6.5244, 3.3792],
    
    // 오세아니아
    'sydney': [-33.8688, 151.2093],
    'melbourne': [-37.8136, 144.9631],
  };

  // 국가별 도시 매핑 (우선순위 2)
  static const Map<String, List<String>> _countryToCities = {
    // 아시아
    'KR': ['seoul'], 
    'JP': ['tokyo'],
    'CN': ['beijing', 'shanghai'],
    'TH': ['bangkok'],
    'SG': ['singapore'],
    'PH': ['manila'],
    'ID': ['jakarta'],
    'MY': ['kuala_lumpur'],
    'VN': ['ho_chi_minh'],
    'IN': ['bangalore', 'mumbai'],
    'TW': ['taipei'],
    
    // 중동
    'AE': ['dubai'],
    'IR': ['tehran'],
    'SA': ['riyadh'],
    'IL': ['tel_aviv'],
    
    // 유럽
    'FR': ['paris'],
    'GB': ['london'],
    'DE': ['berlin'],
    'IT': ['rome'],
    'NL': ['amsterdam'],
    'ES': ['barcelona'],
    'CZ': ['prague'],
    'SE': ['stockholm'],
    'AT': ['vienna'],
    'CH': ['zurich'],
    'RU': ['moscow'],
    'TR': ['istanbul'],
    
    // 북미
    'US': ['san_francisco', 'los_angeles', 'seattle', 'new_york', 'chicago', 'boston', 'miami', 'washington_dc'],
    'CA': ['toronto', 'vancouver'],
    'MX': ['mexico_city'],
    
    // 남미
    'AR': ['buenos_aires'],
    'BR': ['rio_de_janeiro', 'sao_paulo'],
    'CL': ['santiago'],
    
    // 아프리카
    'EG': ['cairo'],
    'ZA': ['johannesburg'],
    'KE': ['nairobi'],
    'MA': ['casablanca'],
    'NG': ['lagos'],
    
    // 오세아니아
    'AU': ['sydney', 'melbourne'],
  };

  // 지역별 폴백 이미지 (실제 존재하는 폴더만) (우선순위 3)
  static const Map<String, String> _regionFallback = {
    // 동아시아
    'KR': 'southeast_asia_extended',
    'CN': 'china_inland', 
    'JP': 'southeast_asia_extended',
    'TW': 'southeast_asia_extended',
    
    // 동남아시아
    'TH': 'southeast_asia_extended',
    'VN': 'southeast_asia_extended',
    'SG': 'southeast_asia_extended',
    'MY': 'southeast_asia_extended',
    'ID': 'southeast_asia_extended',
    'PH': 'oceania_extended',
    
    // 남아시아
    'IN': 'northern_india',
    'PK': 'northern_india',
    'BD': 'northern_india',
    
    // 중앙아시아
    'IR': 'central_asia',
    'AF': 'central_asia',
    'UZ': 'central_asia',
    'KZ': 'central_asia',
    
    // 중동
    'AE': 'central_asia',
    'SA': 'central_asia',
    'QA': 'central_asia',
    
    // 아프리카
    'EG': 'east_africa',
    'ET': 'east_africa',
    'KE': 'east_africa',
    'NG': 'west_africa',
    'GH': 'west_africa',
    
    // 유럽 (존재하는 폴더로 매핑)
    'FR': 'eastern_europe',
    'DE': 'eastern_europe', 
    'IT': 'eastern_europe',
    'ES': 'eastern_europe',
    'GB': 'eastern_europe',
    'RU': 'eastern_europe',
    'PL': 'eastern_europe',
    'TR': 'eastern_europe',
    
    // 북미 (존재하는 폴더로 매핑)
    'US': 'central_asia', // 임시로 central_asia 사용
    'CA': 'central_asia', // 임시로 central_asia 사용
    'MX': 'northern_andes',
    
    // 남미
    'BR': 'northern_andes', // south_america 폴더가 없어서 northern_andes 사용
    'AR': 'northern_andes', // south_america 폴더가 없어서 northern_andes 사용
    'CO': 'northern_andes',
    'PE': 'northern_andes',
    
    // 오세아니아
    'AU': 'oceania_extended',
    'NZ': 'oceania_extended',
  };

  // 날씨 상태 매핑
  static const Map<String, String> _weatherMapping = {
    'clear sky': 'sunny',
    'few clouds': 'sunny',
    'scattered clouds': 'cloudy',
    'broken clouds': 'cloudy',
    'overcast clouds': 'cloudy',
    'shower rain': 'rainy',
    'rain': 'rainy',
    'thunderstorm': 'rainy',
    'snow': 'snowy',
    'mist': 'foggy',
    'fog': 'foggy',
    'haze': 'foggy',
    'smoke': 'foggy',
  };

  /// 위치와 날씨에 기반한 이미지 경로 선택
  /// 
  /// 우선순위:
  /// 1. 정확한 도시명 매치
  /// 2. 같은 나라의 가장 가까운 도시 (위치정보 있을 때) 또는 랜덤 도시
  /// 3. 지역 폴백 이미지 (같은 나라에 도시 없을 때)
  /// 4. 랜덤 도시 이미지 (최종 폴백)
  static String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
  }) {
    final weather = _mapWeatherCondition(weatherDescription);
    print('🌍 Location: $cityName, $countryCode ($latitude, $longitude)');
    print('🌤️  Weather: $weatherDescription → $weather');
    
    // 우선순위 1: 정확한 도시명 매치 (예: 'seoul' → seoul_cloudy.png)
    final cityKey = cityName.toLowerCase().replaceAll(' ', '');
    if (_cityImages.containsKey(cityKey)) {
      final cityImageNames = _cityImages[cityKey]!;
      final selectedCity = cityImageNames[Random().nextInt(cityImageNames.length)];
      final imagePath = _buildImagePath(selectedCity, weather, latitude: latitude, longitude: longitude);
      print('✅ [1] Exact city match: $imagePath');
      return imagePath;
    }
    
    // 우선순위 2: 같은 나라에 지원하는 도시가 있는지 확인
    if (_countryToCities.containsKey(countryCode)) {
      final countryCities = _countryToCities[countryCode]!;
      
      // 2a. 위치정보 있으면 같은 나라에서 가장 가까운 도시
      if (latitude != null && longitude != null) {
        final nearestCity = _findNearestCity(latitude, longitude, candidateCities: countryCities);
        final cityImageNames = _cityImages[nearestCity]!;
        final selectedCityImage = cityImageNames[Random().nextInt(cityImageNames.length)];
        final imagePath = _buildImagePath(selectedCityImage, weather, latitude: latitude, longitude: longitude);
        print('✅ [2a] Same country nearest city: $imagePath');
        return imagePath;
      }
      
      // 2b. 위치정보 없으면 같은 나라의 랜덤 도시
      final selectedCity = countryCities[Random().nextInt(countryCities.length)];
      final cityImageNames = _cityImages[selectedCity]!;
      final selectedCityImage = cityImageNames[Random().nextInt(cityImageNames.length)];
      final imagePath = _buildImagePath(selectedCityImage, weather, latitude: latitude, longitude: longitude);
      print('✅ [2b] Same country random city: $imagePath');
      return imagePath;
    }
    
    // 우선순위 3: 지역 폴백 이미지 (같은 나라에 도시 없을 때)
    if (_regionFallback.containsKey(countryCode)) {
      final regionName = _regionFallback[countryCode]!;
      final imagePath = _buildRegionalImagePath(regionName, weather);
      print('✅ [3] Region fallback: $imagePath');
      return imagePath;
    }
    
    // 우선순위 4: 최종 랜덤 폴백
    final allCities = _cityImages.keys.toList();
    final randomCity = allCities[Random().nextInt(allCities.length)];
    final cityImageNames = _cityImages[randomCity]!;
    final selectedCityImage = cityImageNames[Random().nextInt(cityImageNames.length)];
    final imagePath = _buildImagePath(selectedCityImage, weather, latitude: latitude, longitude: longitude);
    print('⚡ [4] Final random fallback: $imagePath');
    return imagePath;
  }

  /// 날씨 상태 매핑
  static String _mapWeatherCondition(String weatherDescription) {
    final description = weatherDescription.toLowerCase();
    
    for (final entry in _weatherMapping.entries) {
      if (description.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // 시간대별 특별 처리
    final hour = DateTime.now().hour;
    if ((hour >= 17 && hour <= 19) || (hour >= 5 && hour <= 7)) {
      return 'sunset';
    }
    
    return 'sunny'; // 기본값
  }

  /// 도시 이미지 경로 생성 (지역별 폴더 구조)
  static String _buildImagePath(String cityName, String weather, {double? latitude, double? longitude}) {
    final region = _getCityRegion(cityName);
    return 'assets/location_images/regions/$region/${cityName}_${weather}.png';
  }

  /// 도시가 속한 지역 반환
  static String _getCityRegion(String cityName) {
    const Map<String, String> cityToRegion = {
      // 아시아
      'seoul': 'asia',
      'tokyo': 'asia',
      'beijing': 'asia',
      'bangkok': 'asia',
      'singapore': 'asia',
      'manila': 'asia',
      'jakarta': 'asia',
      'kuala_lumpur': 'asia',
      'ho_chi_minh': 'asia',
      'bangalore': 'asia',
      'mumbai': 'asia',
      
      // 중동
      'dubai': 'middle_east',
      'tehran': 'middle_east',
      'riyadh': 'middle_east',
      'tel_aviv': 'middle_east',
      
      // 유럽
      'paris': 'europe',
      'london': 'europe',
      'berlin': 'europe',
      'rome': 'europe',
      'amsterdam': 'europe',
      'barcelona': 'europe',
      'prague': 'europe',
      'stockholm': 'europe',
      'vienna': 'europe',
      'zurich': 'europe',
      'moscow': 'europe',
      'istanbul': 'europe',
      
      // 북미
      'new_york': 'north_america',
      'los_angeles': 'north_america',
      'san_francisco': 'north_america',
      'seattle': 'north_america',
      'chicago': 'north_america',
      'boston': 'north_america',
      'miami': 'north_america',
      'washington_dc': 'north_america',
      'toronto': 'north_america',
      'vancouver': 'north_america',
      'mexico_city': 'north_america',
      
      // 남미
      'buenos_aires': 'south_america',
      'rio_de_janeiro': 'south_america',
      'santiago': 'south_america',
      'sao_paulo': 'south_america',
      
      // 아프리카
      'cairo': 'africa',
      'johannesburg': 'africa',
      'nairobi': 'africa',
      'casablanca': 'africa',
      
      // 오세아니아
      'sydney': 'oceania',
    };
    
    return cityToRegion[cityName] ?? 'asia'; // 기본값
  }

  /// 지역 폴백 이미지 경로 생성
  static String _buildRegionalImagePath(String regionName, String weather) {
    return 'assets/location_images/regional_fallback/${regionName}/${regionName}_${weather}.png';
  }

  /// 사용 가능한 모든 도시 목록 반환
  static List<String> getAllSupportedCities() {
    return _cityImages.keys.toList();
  }

  /// 특정 국가의 지원 도시 목록 반환
  static List<String> getCitiesForCountry(String countryCode) {
    return _countryToCities[countryCode] ?? [];
  }


  /// 두 지점 간의 거리 계산 (Haversine formula)
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * 
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// 가장 가까운 도시 찾기
  static String _findNearestCity(double latitude, double longitude, {List<String>? candidateCities}) {
    List<String> searchCities = candidateCities ?? _cityCoordinates.keys.toList();
    
    String nearestCity = searchCities.first;
    double minDistance = double.infinity;
    
    for (String city in searchCities) {
      if (!_cityCoordinates.containsKey(city)) continue;
      
      List<double> coords = _cityCoordinates[city]!;
      double distance = _calculateDistance(latitude, longitude, coords[0], coords[1]);
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    }
    
    print('📍 Nearest city: $nearestCity (${minDistance.toStringAsFixed(1)}km away)');
    return nearestCity;
  }
}