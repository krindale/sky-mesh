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
    
    // 베이징 하위 구들
    'dongcheng': ['beijing'],    // 동성구
    'xicheng': ['beijing'],     // 서성구
    'chaoyang': ['beijing'],    // 조양구
    'fengtai': ['beijing'],     // 풍대구
    'shijingshan': ['beijing'], // 석경산구
    'haidian': ['beijing'],     // 해정구
    'mentougou': ['beijing'],   // 문두구
    'fangshan': ['beijing'],    // 방산구
    'tongzhou': ['beijing'],    // 통주구
    'shunyi': ['beijing'],      // 순의구
    'changping': ['beijing'],   // 창평구
    'daxing': ['beijing'],      // 대흥구
    'huairou': ['beijing'],     // 회유구
    'pinggu': ['beijing'],      // 평곡구
    'miyun': ['beijing'],       // 밀운구
    'yanqing': ['beijing'],     // 연경구
    
    // 베이징 주변 지역들
    'dayangfang': ['beijing'],  // 다양팡 (베이징 주변)
    'beijing_suburb': ['beijing'], // 베이징 교외
    'changping_county': ['beijing'], // 창평현
    'shunyi_county': ['beijing'],   // 순의현
    'daxing_county': ['beijing'],   // 대흥현
    'fangshan_county': ['beijing'], // 방산현
    'mentougou_county': ['beijing'], // 문두구현
    'huairou_county': ['beijing'],  // 회유현
    'pinggu_county': ['beijing'],   // 평곡현
    'miyun_county': ['beijing'],    // 밀운현
    'yanqing_county': ['beijing'],  // 연경현
    
    // 상하이 하위 구들
    'huangpu': ['shanghai'],    // 황포구
    'xuhui': ['shanghai'],      // 서휘구
    'changning': ['shanghai'],  // 장녕구
    'jingan': ['shanghai'],     // 정안구
    'putuo': ['shanghai'],      // 보타구
    'hongkou': ['shanghai'],    // 홍구구
    'yangpu': ['shanghai'],     // 양포구
    'minhang': ['shanghai'],    // 민행구
    'baoshan': ['shanghai'],    // 보산구
    'jiading': ['shanghai'],    // 가정구
    'pudong': ['shanghai'],     // 포동신구
    'jinshan': ['shanghai'],    // 금산구
    'songjiang': ['shanghai'],  // 송강구
    'qingpu': ['shanghai'],     // 청포구
    'fengxian': ['shanghai'],   // 봉현구
    'chongming': ['shanghai'],  // 숭명구
    'luwan': ['shanghai'],      // 루완구 (현재는 황포구에 합병됨)
    
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
    'KP': ['seoul'],  // 북한
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

  // 중국 남부 지역 도시들 (광둥, 광시, 하이난, 푸젠, 홍콩, 마카오 등)
  static const List<String> _southernChinaCities = [
    'guangzhou', 'shenzhen', 'hong_kong', 'macau', 'xiamen', 'fuzhou', 
    'nanning', 'haikou', 'sanya', 'zhuhai', 'foshan', 'dongguan'
  ];

  // 지역별 폴백 이미지 (지원 도시가 없는 국가들만) (우선순위 3)
  static const Map<String, String> _regionFallback = {
    // 남아시아 (지원 도시 없는 국가들)
    'PK': 'northern_india',  // 파키스탄
    'BD': 'northern_india',  // 방글라데시
    'LK': 'northern_india',  // 스리랑카
    'NP': 'northern_india',  // 네팔
    'BT': 'northern_india',  // 부탄
    'IN': 'northern_india',  // 인도 (뭄바이 외 지역)
    
    // 중앙아시아 (지원 도시 없는 국가들)
    'AF': 'central_asia',    // 아프가니스탄
    'UZ': 'central_asia',    // 우즈베키스탄
    'KZ': 'central_asia',    // 카자흐스탄
    'TM': 'central_asia',    // 투르크메니스탄
    'TJ': 'central_asia',    // 타지키스탄
    'KG': 'central_asia',    // 키르기스스탄
    
    // 동남아시아 (지원 도시 없는 국가들)
    'LA': 'southeast_asia_extended', // 라오스
    'KH': 'southeast_asia_extended', // 캄보디아
    'MM': 'southeast_asia_extended', // 미얀마
    'BN': 'southeast_asia_extended', // 브루나이
    'TL': 'southeast_asia_extended', // 동티모르
    
    // 중동 (지원 도시 없는 국가들)  
    'QA': 'middle_east',     // 카타르
    'KW': 'middle_east',     // 쿠웨이트
    'BH': 'middle_east',     // 바레인
    'OM': 'middle_east',     // 오만
    'JO': 'middle_east',     // 요단
    'LB': 'middle_east',     // 레바논
    'SY': 'middle_east',     // 시리아
    'IQ': 'middle_east',     // 이라크
    'YE': 'middle_east',     // 예멘
    
    // 북아프리카 (지원 도시 없는 국가들)
    'LY': 'middle_east',     // 리비아
    'TN': 'middle_east',     // 튀니지
    'DZ': 'middle_east',     // 알제리
    'SD': 'middle_east',     // 수단
    'SS': 'middle_east',     // 남수단
    
    // 아프리카 (지원 도시 없는 국가들)
    'ET': 'east_africa',     // 에티오피아
    'TZ': 'east_africa',     // 탄자니아
    'UG': 'east_africa',     // 우간다
    'RW': 'east_africa',     // 르완다
    'BI': 'east_africa',     // 부룬디
    'ER': 'east_africa',     // 에리트레아
    'DJ': 'east_africa',     // 지부티
    'SO': 'east_africa',     // 소말리아
    'BW': 'east_africa',     // 보츠와나
    'NA': 'east_africa',     // 나미비아
    'ZW': 'east_africa',     // 짐바브웨
    'GH': 'west_africa',     // 가나
    'SN': 'west_africa',     // 세네갈
    'ML': 'west_africa',     // 말리
    'BF': 'west_africa',     // 부르키나파소
    'CI': 'west_africa',     // 코트디부아르
    'LR': 'west_africa',     // 라이베리아
    'SL': 'west_africa',     // 시에라리온
    'GN': 'west_africa',     // 기니
    'GW': 'west_africa',     // 기니비사우
    'GM': 'west_africa',     // 감비아
    'CV': 'west_africa',     // 카보베르데
    'NE': 'west_africa',     // 니제르
    'TG': 'west_africa',     // 토고
    'BJ': 'west_africa',     // 베냉
    'TD': 'west_africa',     // 차드
    'CF': 'west_africa',     // 중앙아프리카공화국
    'CM': 'west_africa',     // 카메룬
    'CG': 'west_africa',     // 콩고공화국
    'CD': 'west_africa',     // 콩고민주공화국
    
    // 유럽 (지원 도시 없는 국가들)
    'PL': 'eastern_europe',  // 폴란드
    'SK': 'eastern_europe',  // 슬로바키아
    'HU': 'eastern_europe',  // 헝가리
    'RO': 'eastern_europe',  // 루마니아
    'BG': 'eastern_europe',  // 불가리아
    'SI': 'eastern_europe',  // 슬로베니아
    'HR': 'eastern_europe',  // 크로아티아
    'BA': 'eastern_europe',  // 보스니아헤르체고비나
    'RS': 'eastern_europe',  // 세르비아
    'ME': 'eastern_europe',  // 몬테네그로
    'MK': 'eastern_europe',  // 북마케도니아
    'AL': 'eastern_europe',  // 알바니아
    'XK': 'eastern_europe',  // 코소보
    'EE': 'eastern_europe',  // 에스토니아
    'LV': 'eastern_europe',  // 라트비아
    'LT': 'eastern_europe',  // 리투아니아
    'BY': 'eastern_europe',  // 벨라루스
    'UA': 'eastern_europe',  // 우크라이나
    'MD': 'eastern_europe',  // 몰도바
    'CZ': 'eastern_europe',  // 체코
    'NO': 'eastern_europe',  // 노르웨이
    'DK': 'eastern_europe',  // 덴마크
    'FI': 'eastern_europe',  // 핀란드
    'IS': 'eastern_europe',  // 아이슬란드
    'GR': 'eastern_europe',  // 그리스
    'BE': 'eastern_europe',  // 벨기에
    'IE': 'eastern_europe',  // 아일랜드
    'PT': 'eastern_europe',  // 포르투갈
    
    // 남미 (지원 도시 없는 국가들)
    'CO': 'northern_andes',  // 콜롬비아
    'PE': 'northern_andes',  // 페루
    'EC': 'northern_andes',  // 에콰도르
    'VE': 'northern_andes',  // 베네수엘라
    'BO': 'northern_andes',  // 볼리비아
    'PA': 'northern_andes',  // 파나마
    'CU': 'northern_andes',  // 쿠바
    'JM': 'northern_andes',  // 자메이카
    'DO': 'northern_andes',  // 도미니카공화국
    'GT': 'northern_andes',  // 과테말라
    'CR': 'northern_andes',  // 코스타리카
    'NI': 'northern_andes',  // 니카라과
    
    // 오세아니아 (지원 도시 없는 국가들)
    'NZ': 'oceania_extended', // 뉴질랜드
    'FJ': 'oceania_extended', // 피지
    'PG': 'oceania_extended', // 파푸아뉴기니
    'VU': 'oceania_extended', // 바누아투
    'SB': 'oceania_extended', // 솔로몬 제도
    'WS': 'oceania_extended', // 사모아
    'TO': 'oceania_extended', // 통가
    'PW': 'oceania_extended', // 팔라우
    'FM': 'oceania_extended', // 미크로네시아
    'MH': 'oceania_extended', // 마셜 제도
    'NR': 'oceania_extended', // 나우루
    'KI': 'oceania_extended', // 키리바시
    'TV': 'oceania_extended', // 투발루
    
    // 중국은 특별 처리 유지 (베이징/상하이 외 도시들을 위한 지역별 폴백)
    'CN': 'china_inland',
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
      
      // 중국의 경우: 특별한 지역별 처리를 위해 조건부 스킵
      if (countryCode == 'CN' && !countryCities.contains(cityKey)) {
        // 중국이지만 지원하지 않는 도시인 경우, 지역 폴백으로 넘어감
        print('🇨🇳 Unsupported Chinese city, checking regional fallback...');
      } 
      // 인도의 경우: 방갈로르/뭄바이가 아닌 도시는 지역 폴백 사용
      else if (countryCode == 'IN' && !countryCities.contains(cityKey)) {
        // 인도이지만 방갈로르/뭄바이가 아닌 경우, 지역 폴백으로 넘어감
        print('🇮🇳 Non-Bangalore/Mumbai Indian city, using regional fallback...');
      } else {
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
    }
    
    // 우선순위 3: 지역 폴백 이미지 (같은 나라에 도시 없을 때)
    if (_regionFallback.containsKey(countryCode)) {
      String regionName = _regionFallback[countryCode]!;
      
      // 중국의 경우 특별 처리
      if (countryCode == 'CN') {
        regionName = _getChinaRegionByLocation(cityName, latitude, longitude);
      }
      
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
      'lagos': 'africa',
      'shanghai': 'asia',
      'taipei': 'asia',
      
      // 오세아니아
      'sydney': 'oceania',
      'melbourne': 'oceania',
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

  /// 중국의 경우 지역별 이미지 결정
  static String _getChinaRegionByLocation(String cityName, double? latitude, double? longitude) {
    final cityKey = cityName.toLowerCase().replaceAll(' ', '').replaceAll('-', '_');
    
    // 1. 도시명으로 남부 중국 판단
    if (_southernChinaCities.contains(cityKey)) {
      print('🇨🇳 Southern China city detected: $cityName');
      return 'southern_china';
    }
    
    // 2. 위도 기반 판단 (위도 정보가 있는 경우)
    if (latitude != null) {
      // 남부 중국: 위도 26도 이남 (광둥, 광시, 하이난, 푸젠 남부, 후난 남부 등)
      if (latitude < 26.0) {
        print('🇨🇳 Southern China by latitude: $latitude');
        return 'southern_china';
      }
    }
    
    // 3. 기본값: 중국 내륙
    print('🇨🇳 China inland fallback for: $cityName');
    return 'china_inland';
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