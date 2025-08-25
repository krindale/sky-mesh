/// 이미지 에셋 경로 관리 유틸리티
/// 
/// 이 파일은 SkyMesh 앱에서 사용하는 모든 로우폴리 배경 이미지의
/// 경로를 체계적으로 관리합니다. 68개 주요 도시와 10개 지역별
/// fallback 이미지들의 경로를 동적으로 생성하고 관리합니다.
/// 
/// ## 이미지 구조
/// ```
/// assets/location_images/
/// ├── regions/                     # 주요 도시별 이미지
/// │   ├── asia/                   # 아시아 13개 도시
/// │   ├── middle_east/            # 중동 4개 도시
/// │   ├── europe/                 # 유럽 12개 도시
/// │   ├── north_america/          # 북미 11개 도시
/// │   ├── south_america/          # 남미 4개 도시
/// │   ├── africa/                 # 아프리카 5개 도시
/// │   └── oceania/               # 오세아니아 2개 도시
/// └── regional_fallback/          # 지역별 대체 이미지
///     ├── central_asia/          # 중앙아시아
///     ├── china_inland/          # 중국 내륙
///     └── ... (10개 지역)
/// ```
/// 
/// ## 날씨 조건
/// 각 위치별로 6가지 날씨 조건의 이미지 제공:
/// - cloudy: 흐림
/// - foggy: 안개
/// - rainy: 비
/// - snowy: 눈
/// - sunny: 맑음
/// - sunset: 석양
/// 
/// ## 총 이미지 수
/// - 도시별 이미지: 83개 도시 × 6개 날씨 = 498개
/// - 지역별 fallback: 10개 지역 × 6개 날씨 = 60개
/// - **총 558개 로우폴리 배경 이미지**
/// 
/// @author krindale
/// @since 1.0.0

import 'dart:math';  // Random 클래스 사용

/// 로우폴리 배경 이미지 에셋 경로 관리 클래스
/// 
/// 이 클래스는 SkyMesh 앱의 모든 배경 이미지 경로를 체계적으로 관리하며,
/// 위치와 날씨 조건에 따른 적절한 이미지 선택을 지원합니다.
/// 
/// ## 설계 원칙
/// - **SRP**: 이미지 경로 관리만 담당
/// - **OCP**: 새로운 도시나 날씨 조건 추가 시 확장 용이
/// - **성능**: 정적 상수로 빠른 접근
/// - **유지보수**: 중앙집중식 경로 관리
/// 
/// ## 사용 패턴
/// ```dart
/// // 랜덤 이미지
/// final randomPath = ImageAssets.getRandomImagePath();
/// 
/// // 특정 도시 이미지
/// final seoulPath = ImageAssets.getCityImagePath('seoul', 'sunny');
/// 
/// // 날씨별 랜덤 이미지
/// final rainyPath = ImageAssets.getRandomImagePathByWeather('rainy');
/// ```
class ImageAssets {
  /// 이미지 에셋의 기본 경로
  /// 모든 위치 관련 이미지가 저장된 루트 디렉토리
  static const String _baseLocationPath = 'assets/location_images';
  
  /// 지원하는 날씨 조건 타입들
  /// 
  /// 각 위치별로 6가지 날씨 조건의 로우폴리 이미지를 제공합니다.
  /// 이미지 파일명의 suffix로 사용되며, 정확한 철자가 중요합니다.
  /// 
  /// ## 날씨 조건 설명
  /// - **cloudy**: 흐린 날씨 (구름 많음)
  /// - **foggy**: 안개 낀 날씨 (시야 제한)
  /// - **rainy**: 비 오는 날씨 (강수)
  /// - **snowy**: 눈 오는 날씨 (적설)
  /// - **sunny**: 맑은 날씨 (쾌청)
  /// - **sunset**: 석양 시간대 (황혼)
  /// 
  /// ## 이미지 스타일
  /// 모든 날씨 조건은 로우폴리 아트 스타일로 제작되어
  /// 기하학적이고 현대적인 느낌을 제공합니다.
  static const List<String> weatherTypes = [
    'cloudy',    // 흐림 - 회색 톤의 구름 표현
    'foggy',     // 안개 - 흐릿하고 몽환적인 분위기
    'rainy',     // 비 - 어두운 톤과 빗줄기 표현
    'snowy',     // 눈 - 밝고 차가운 톤의 설경
    'sunny',     // 맑음 - 밝고 생동감 있는 색상
    'sunset',    // 석양 - 따뜻한 오렌지/핑크 톤
  ];
  
  /// 지역별 주요 도시 목록
  /// 
  /// 전 세계 83개 주요 도시를 7개 지역으로 분류하여 관리합니다.
  /// 각 도시는 해당 지역의 대표적인 랜드마크를 배경으로 한
  /// 6가지 날씨 조건의 이미지를 보유합니다.
  /// 
  /// ## 지역 분류 기준
  /// - **지리적 근접성**: 인접한 국가들을 그룹화
  /// - **문화적 유사성**: 비슷한 건축양식과 문화권
  /// - **시간대 고려**: 유사한 시간대의 도시들
  /// - **경제적 중요성**: 각 지역의 주요 경제 허브
  /// 
  /// ## 도시 선정 기준
  /// - 인구 100만 이상의 대도시
  /// - 국제적 인지도가 높은 도시
  /// - 독특한 랜드마크를 보유한 도시
  /// - 다양한 기후 조건을 대표하는 도시
  static const Map<String, List<String>> regionCities = {
    /// 아시아 지역 (18개 도시)
    /// 동아시아, 동남아시아, 남아시아의 주요 경제 허브들
    'asia': [
      'seoul',         // 서울 - N서울타워
      'tokyo',         // 도쿄 - 도쿄타워/스카이트리
      'beijing',       // 베이징 - 자금성
      'bangkok',       // 방콕 - 왓 아룬
      'singapore',     // 싱가포르 - 마리나베이샌즈
      'manila',        // 마닐라 - 인트라무로스
      'jakarta',       // 자카르타 - 모나스
      'kuala_lumpur',  // 쿠알라룸푸르 - 페트로나스 트윈타워
      'ho_chi_minh',   // 호치민 - 통일궁
      'bangalore',     // 방갈로르 - 비단나 사우다
      'mumbai',        // 뭄바이 - 게이트웨이 오브 인디아
      'shanghai',      // 상하이 - 와이탄
      'taipei',        // 타이베이 - 타이베이 101
      'sapporo',       // 삿포로 - 삿포로 TV타워
      'bali',          // 발리 - 울루와뚜 사원
      'phuket',        // 푸켓 - 빅 부다
      'angkor_wat',    // 앙코르와트 - 앙코르와트 유적
      'maldives',      // 몰디브 - 산호초와 리조트
    ],
    
    /// 중동 지역 (5개 도시)
    /// 서아시아의 주요 경제 및 문화 중심지들
    'middle_east': [
      'dubai',         // 두바이 - 부르즈 할리파
      'tehran',        // 테헤란 - 아자디 타워
      'riyadh',        // 리야드 - 킹덤 센터
      'tel_aviv',      // 텔아비브 - 해변가 스카이라인
      'petra',         // 페트라 - 고대 나바테아 도시
    ],
    
    /// 유럽 지역 (15개 도시)
    /// 서유럽, 동유럽, 남유럽의 역사적 문화 도시들
    'europe': [
      'paris',         // 파리 - 에펠탑
      'london',        // 런던 - 빅벤
      'berlin',        // 베를린 - 브란덴부르크 문
      'rome',          // 로마 - 콜로세움
      'amsterdam',     // 암스테르담 - 운하
      'barcelona',     // 바르셀로나 - 사그라다 파밀리아
      'prague',        // 프라하 - 프라하 성
      'stockholm',     // 스톡홀름 - 감라스탄
      'vienna',        // 비엔나 - 쇤부른 궁전
      'zurich',        // 취리히 - 알프스 전망
      'moscow',        // 모스크바 - 크렘린
      'istanbul',      // 이스탄불 - 하기아 소피아
      'dubrovnik',     // 두브로브니크 - 구시가지 성벽
      'zermatt',       // 체르마트 - 마터호른 전망
      'santorini',     // 산토리니 - 에게해 절벽 마을
    ],
    
    /// 북미 지역 (13개 도시)
    /// 미국, 캐나다, 멕시코의 주요 대도시들
    'north_america': [
      'new_york',      // 뉴욕 - 엠파이어 스테이트 빌딩
      'los_angeles',   // 로스앤젤레스 - 할리우드 사인
      'san_francisco', // 샌프란시스코 - 골든게이트 브리지
      'seattle',       // 시애틀 - 스페이스 니들
      'chicago',       // 시카고 - 윌리스 타워
      'boston',        // 보스턴 - 프리덤 트레일
      'miami',         // 마이애미 - 아르데코 건축
      'washington_dc', // 워싱턴 DC - 캐피톨 빌딩
      'toronto',       // 토론토 - CN 타워
      'vancouver',     // 밴쿠버 - 산과 바다
      'mexico_city',   // 멕시코시티 - 소칼로
      'cancun',        // 칸쿤 - 마야 리비에라
      'aspen',         // 아스펜 - 록키산맥 스키리조트
    ],
    
    /// 남미 지역 (5개 도시)
    /// 남아메리카의 주요 경제 중심지들
    'south_america': [
      'buenos_aires',  // 부에노스아이레스 - 오벨리스크
      'rio_de_janeiro',// 리우데자네이루 - 그리스도상
      'santiago',      // 산티아고 - 안데스 산맥 전망
      'sao_paulo',     // 상파울루 - 스카이라인
      'machu_picchu',  // 마추픽추 - 잉카 고대 유적
    ],
    
    /// 아프리카 지역 (5개 도시)
    /// 아프리카 대륙의 주요 도시들
    'africa': [
      'cairo',         // 카이로 - 피라미드
      'johannesburg',  // 요하네스버그 - 스카이라인
      'nairobi',       // 나이로비 - 사바나 전망
      'casablanca',    // 카사블랑카 - 하산 2세 모스크
      'lagos',         // 라고스 - 현대적 스카이라인
    ],
    
    /// 오세아니아 지역 (5개 도시)
    /// 오세아니아의 주요 도시와 관광지들
    'oceania': [
      'sydney',        // 시드니 - 오페라하우스
      'melbourne',     // 멜버른 - 플린더스 스트리트
      'hawaii',        // 하와이 - 와이키키 해변
      'tahiti',        // 타히티 - 남태평양 파라다이스
      'queenstown',    // 퀸스타운 - 남알프스 전망
    ],
  };
  
  /// 지역별 대체(fallback) 이미지 목록
  /// 
  /// 특정 도시의 이미지가 없거나 지역 전체를 대표해야 할 때
  /// 사용되는 일반적인 지역 이미지들입니다.
  /// 
  /// ## 사용 용도
  /// - **도시 이미지 부재**: 특정 도시 이미지가 없을 때 대체
  /// - **지역 대표**: 지역 전체의 특성을 나타낼 때
  /// - **다양성 확보**: 더 많은 배경 이미지 옵션 제공
  /// - **문화적 특성**: 특정 지역의 독특한 지형/문화 표현
  /// 
  /// ## 지역 분류
  /// 주요 도시가 커버하지 못하는 지역이나 특별한 지형적 특성을
  /// 가진 지역들을 별도로 관리합니다.
  static const List<String> regionalFallbacks = [
    'central_asia',           // 중앙아시아 - 초원과 유목 문화
    'china_inland',           // 중국 내륙 - 산악지대와 전통 건축
    'east_africa',           // 동아프리카 - 사바나와 야생동물
    'eastern_europe',        // 동유럽 - 전통 건축과 평원
    'northern_andes',        // 북안데스 - 고산지대와 인카 문화
    'northern_india',        // 북인도 - 히말라야와 전통 궁전
    'oceania_extended',      // 확장 오세아니아 - 태평양 섬들
    'southeast_asia_extended', // 확장 동남아시아 - 열대 정글
    'southern_china',        // 중국 남부 - 카르스트 지형
    'west_africa',          // 서아프리카 - 사막과 전통 건축
  ];
  
  /// 모든 가능한 이미지 경로 목록을 생성
  static List<String> getAllImagePaths() {
    List<String> allPaths = [];
    
    // 지역별 도시 이미지들 추가
    regionCities.forEach((region, cities) {
      for (String city in cities) {
        for (String weather in weatherTypes) {
          allPaths.add('$_baseLocationPath/regions/$region/${city}_$weather.webp');
        }
      }
    });
    
    // 지역별 fallback 이미지들 추가
    for (String region in regionalFallbacks) {
      for (String weather in weatherTypes) {
        allPaths.add('$_baseLocationPath/regional_fallback/$region/${region}_$weather.webp');
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
        weatherPaths.add('$_baseLocationPath/regions/$region/${city}_$weather.webp');
      }
    });
    
    // 지역별 fallback 이미지들에서 해당 날씨 찾기
    for (String region in regionalFallbacks) {
      weatherPaths.add('$_baseLocationPath/regional_fallback/$region/${region}_$weather.webp');
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
        return '$_baseLocationPath/regions/${entry.key}/${city}_$weather.webp';
      }
    }
    
    return null;
  }
  
  /// 특정 지역의 fallback 이미지 경로 반환
  static String? getRegionalFallbackPath(String region, String weather) {
    if (!weatherTypes.contains(weather) || !regionalFallbacks.contains(region)) {
      return null;
    }
    
    return '$_baseLocationPath/regional_fallback/$region/${region}_$weather.webp';
  }
}