/// 위치별 이미지 선택 서비스
/// 
/// 이 파일은 사용자의 위치와 날씨 조건에 따라 최적의 배경 이미지를 선택하는 서비스입니다.
/// 468개의 로우폴리 스타일 이미지를 관리하며, 지능적인 매칭 알고리즘을 사용합니다.
/// 
/// ## 이미지 컴렉션 구성
/// - **68개 주요 도시**: 전 세계 7개 대륙의 대표 도시들
/// - **6가지 날씨 조건**: cloudy, foggy, rainy, snowy, sunny, sunset
/// - **10개 지역 대체**: 도시가 없는 지역의 대체 이미지
/// - **총 468개 이미지**: (68개 도시 × 6개 날씨) + (10개 지역 × 6개 날씨)
/// 
/// ## 지원 지역
/// - **아시아**: 서울, 도쿄, 베이징, 방콕, 싱가포르, 마닐라, 자카르타, 쿠알라룸푸르, 호치민, 방갈로르, 뮄바이, 상하이, 타이베이
/// - **중동**: 두바이, 테헤란, 리야드, 텔아비브
/// - **유럽**: 파리, 런던, 베를린, 로마, 암스테르담, 바르셀로나, 프라하, 스톡홀름, 비엔나, 취리히, 모스크바, 이스탄불
/// - **북미**: 뉴욕, 로스앤젬레스, 샌프란시스코, 시애틀, 시카고, 보스턴, 마이애미, 워싱턴DC, 토론토, 밴쿠버, 멕시코시티
/// - **남미**: 부에노스아이레스, 리우데자네이루, 산티아고, 상파울루
/// - **아프리카**: 카이로, 요하네스버그, 나이로비, 카사블랑카, 라고스
/// - **오세아니아**: 시드니, 멜버른
/// 
/// ## 이미지 선택 우선순위
/// 1. **정확한 도시 매칭**: 도시명이 직접 일치하는 경우
/// 2. **같은 국가 도시**: 같은 국가 내 지원 도시 중 가장 가까운/랜덤 도시
/// 3. **지역 대체 이미지**: 지원되는 도시가 없는 국가의 지역별 대체 이미지
/// 4. **랜덤 대체**: 모든 매칭이 실패한 경우 랜덤 이미지
/// 
/// ## 특별 처리 지역
/// - **중국**: 반남부(위도 26도 이남)와 내륙 지역 분리
/// - **인도**: 방갈로르/뮄바이 외 도시는 북인도 대체 이미지 사용
/// - **미국**: 다수의 도시 지원으로 지역별 세분화
/// 
/// ## 날씨 조건 매핑
/// - **sunny**: clear sky, few clouds + 주간 일반 시간
/// - **cloudy**: scattered/broken/overcast clouds
/// - **rainy**: rain, shower rain, thunderstorm
/// - **snowy**: snow
/// - **foggy**: mist, fog, haze, smoke
/// - **sunset**: 석양 시간대 (17-19시, 5-7시) 특별 처리
/// 
/// @author krindale
/// @since 1.0.0

import 'dart:math';  // 랜덤 숫자 생성을 위한 수학 라이브러리

import '../utils/image_assets.dart';  // ImageAssets 클래스 import

/// 위치와 날씨에 따른 이미지 선택 서비스
/// 
/// 이 클래스는 468개의 로우폴리 배경 이미지 매핑을 관리하며,
/// 사용자의 위치와 날씨 조건에 가장 적합한 이미지를 선택합니다.
/// 
/// ## 핵심 기능
/// - **지능적 매칭**: 4단계 우선순위 알고리즘
/// - **지리적 차이 고려**: 하베르사인 공식으로 거리 계산
/// - **문화적 적합성**: 지역별 특성을 반영한 이미지 선택
/// - **성능 최적화**: 정적 매핑 테이블로 빠른 조회
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
    'sapporo': ['sapporo'],
    'bali': ['bali'],
    'phuket': ['phuket'],
    'angkor_wat': ['angkor_wat'],
    'maldives': ['maldives'],
    
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
    'petra': ['petra'],
    
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
    'dubrovnik': ['dubrovnik'],
    'zermatt': ['zermatt'],
    'santorini': ['santorini'],
    
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
    'cancun': ['cancun'],
    'aspen': ['aspen'],
    
    // 남미  
    'buenos_aires': ['buenos_aires'],
    'rio_de_janeiro': ['rio_de_janeiro'],
    'santiago': ['santiago'],
    'sao_paulo': ['sao_paulo'],
    'machu_picchu': ['machu_picchu'],
    
    // 아프리카
    'cairo': ['cairo'],
    'johannesburg': ['johannesburg'],
    'nairobi': ['nairobi'],
    'casablanca': ['casablanca'],
    'lagos': ['lagos'],
    
    // 오세아니아
    'sydney': ['sydney'],
    'melbourne': ['melbourne'],
    'hawaii': ['hawaii'],
    'tahiti': ['tahiti'],
    'queenstown': ['queenstown'],
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
    'sapporo': [43.0642, 141.3469],
    'bali': [-8.3405, 115.0920],
    'phuket': [7.8804, 98.3923],
    'angkor_wat': [13.4125, 103.8670],
    'maldives': [3.2028, 73.2207],
    
    // 중동
    'dubai': [25.2048, 55.2708],
    'tehran': [35.6892, 51.3890],
    'riyadh': [24.7136, 46.6753],
    'tel_aviv': [32.0853, 34.7818],
    'petra': [30.3285, 35.4444],
    
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
    'dubrovnik': [42.6507, 18.0944],
    'zermatt': [46.0207, 7.7491],
    'santorini': [36.3932, 25.4615],
    
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
    'cancun': [21.1619, -86.8515],
    'aspen': [39.1911, -106.8175],
    
    // 남미
    'buenos_aires': [-34.6118, -58.3960],
    'rio_de_janeiro': [-22.9068, -43.1729],
    'santiago': [-33.4489, -70.6693],
    'sao_paulo': [-23.5505, -46.6333],
    'machu_picchu': [-13.1631, -72.5450],
    
    // 아프리카
    'cairo': [30.0444, 31.2357],
    'johannesburg': [-26.2041, 28.0473],
    'nairobi': [-1.2921, 36.8219],
    'casablanca': [33.5731, -7.5898],
    'lagos': [6.5244, 3.3792],
    
    // 오세아니아
    'sydney': [-33.8688, 151.2093],
    'melbourne': [-37.8136, 144.9631],
    'hawaii': [21.3099, -157.8581],
    'tahiti': [-17.6797, -149.4068],
    'queenstown': [-45.0312, 168.6626],
  };

  // 국가별 도시 매핑 (우선순위 2)
  static const Map<String, List<String>> _countryToCities = {
    // 아시아
    'KR': ['seoul'], 
    'KP': ['seoul'],  // 북한
    'JP': ['tokyo', 'sapporo'],
    'CN': ['beijing', 'shanghai'],
    'TH': ['bangkok', 'phuket'],
    'SG': ['singapore'],
    'PH': ['manila'],
    'ID': ['jakarta', 'bali'],
    'MY': ['kuala_lumpur'],
    'VN': ['ho_chi_minh'],
    'IN': ['bangalore', 'mumbai'],
    'TW': ['taipei'],
    'KH': ['angkor_wat'],  // 캄보디아
    'MV': ['maldives'],    // 몰디브
    
    // 중동
    'AE': ['dubai'],
    'IR': ['tehran'],
    'SA': ['riyadh'],
    'IL': ['tel_aviv'],
    'JO': ['petra'],       // 요단
    
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
    'CH': ['zurich', 'zermatt'],  // 스위스
    'RU': ['moscow'],
    'TR': ['istanbul'],
    'HR': ['dubrovnik'],   // 크로아티아
    'GR': ['santorini'],   // 그리스
    
    // 북미
    'US': ['san_francisco', 'los_angeles', 'seattle', 'new_york', 'chicago', 'boston', 'miami', 'washington_dc', 'aspen', 'hawaii'],
    'CA': ['toronto', 'vancouver'],
    'MX': ['mexico_city', 'cancun'],
    
    // 남미
    'AR': ['buenos_aires'],
    'BR': ['rio_de_janeiro', 'sao_paulo'],
    'CL': ['santiago'],
    'PE': ['machu_picchu'],  // 페루
    
    // 아프리카
    'EG': ['cairo'],
    'ZA': ['johannesburg'],
    'KE': ['nairobi'],
    'MA': ['casablanca'],
    'NG': ['lagos'],
    
    // 오세아니아
    'AU': ['sydney', 'melbourne'],
    'PF': ['tahiti'],      // 타히티 (프랑스령 폴리네시아)
    'NZ': ['queenstown'],  // 뉴질랜드
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
    'MM': 'southeast_asia_extended', // 미얀마
    'BN': 'southeast_asia_extended', // 브루나이
    'TL': 'southeast_asia_extended', // 동티모르
    
    // 중동 (지원 도시 없는 국가들)  
    'QA': 'middle_east',     // 카타르
    'KW': 'middle_east',     // 쿠웨이트
    'BH': 'middle_east',     // 바레인
    'OM': 'middle_east',     // 오만
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
    'AO': 'west_africa',     // 앙골라
    'MZ': 'east_africa',     // 모잠비크
    'ZM': 'east_africa',     // 잠비아
    'MW': 'east_africa',     // 말라위
    'MG': 'east_africa',     // 마다가스카르
    
    // 유럽 (지원 도시 없는 국가들)
    'PL': 'eastern_europe',  // 폴란드
    'SK': 'eastern_europe',  // 슬로바키아
    'HU': 'eastern_europe',  // 헝가리
    'RO': 'eastern_europe',  // 루마니아
    'BG': 'eastern_europe',  // 불가리아
    'SI': 'eastern_europe',  // 슬로베니아
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
    'BE': 'eastern_europe',  // 벨기에
    'IE': 'eastern_europe',  // 아일랜드
    'PT': 'eastern_europe',  // 포르투갈
    
    // 남미 (지원 도시 없는 국가들)
    'CO': 'northern_andes',  // 콜롬비아
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

  /// 위치와 날씨에 기반한 최적 배경 이미지 선택
  /// 
  /// 이 메서드는 SkyMesh 앱의 핵심 기능으로, 4단계 우선순위 알고리즘을 통해
  /// 사용자의 위치와 날씨 조건에 가장 적합한 468개 이미지 중 하나를 선택합니다.
  /// 
  /// @param cityName 도시명 (예: "Seoul", "New York")
  /// @param countryCode ISO 3166-1 alpha-2 국가코드 (예: "KR", "US")
  /// @param weatherDescription OpenWeatherMap API의 날씨 설명
  /// @param latitude 위도 (선택적, 거리 계산용)
  /// @param longitude 경도 (선택적, 거리 계산용)
  /// @return String 선택된 이미지의 Flutter Assets 경로
  /// 
  /// ## 선택 우선순위
  /// ### 1단계: 정확한 도시명 매칭
  /// - 도시명이 68개 지원 도시와 정확히 일치
  /// - 예: "Seoul" → seoul_sunny.webp
  /// 
  /// ### 2단계: 같은 국가 내 도시 매칭
  /// - 2a) GPS 좌표가 있는 경우: 가장 가까운 도시 선택
  /// - 2b) GPS 좌표가 없는 경우: 국가 내 랜덤 도시 선택
  /// - 예: 미국 내 지원하지 않는 도시 → 가장 가까운 지원 도시
  /// 
  /// ### 3단계: 지역 대체 이미지
  /// - 국가에 지원 도시가 없는 경우 지역별 대체 이미지 사용
  /// - 예: 파키스탄 → northern_india_cloudy.webp
  /// 
  /// ### 4단계: 랜덤 대체
  /// - 모든 매칭이 실패한 경우 68개 도시 중 랜덤 선택
  /// 
  /// ## 특별 처리 지역
  /// - **중국**: 방남부(위도 26도 이남)와 내륡 지역 구분
  /// - **인도**: 방갈로르/뮄바이 외는 북인도 대체 이미지
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final imagePath = LocationImageService.selectBackgroundImage(
  ///   cityName: "Seoul",
  ///   countryCode: "KR",
  ///   weatherDescription: "clear sky",
  ///   latitude: 37.5665,
  ///   longitude: 126.9780,
  /// );
  /// // 결과: "assets/location_images/regions/asia/seoul_sunny.webp"
  /// ```
  static String selectBackgroundImage({
    required String cityName,
    required String countryCode,
    required String weatherDescription,
    double? latitude,
    double? longitude,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    final weather = _mapWeatherCondition(weatherDescription, sunrise: sunrise, sunset: sunset);
    print('🌍 Location: $cityName, $countryCode ($latitude, $longitude)');
    print('🌤️  Weather: $weatherDescription → $weather');
    
    // 우선순위 1: 정확한 도시명 매치 (예: 'seoul' → seoul_cloudy.webp)
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
    
    // 우선순위 4: 최종 폴백 (좌표가 있으면 가장 가까운 지역, 없으면 랜덤)
    if (latitude != null && longitude != null) {
      final nearestRegion = _findNearestRegion(latitude, longitude);
      final imagePath = _buildRegionalImagePath(nearestRegion, weather);
      print('⚡ [4] Final nearest region fallback: $imagePath');
      return imagePath;
    } else {
      // 좌표가 없을 때만 랜덤 도시 선택
      final allCities = _cityImages.keys.toList();
      final randomCity = allCities[Random().nextInt(allCities.length)];
      final cityImageNames = _cityImages[randomCity]!;
      final selectedCityImage = cityImageNames[Random().nextInt(cityImageNames.length)];
      final imagePath = _buildImagePath(selectedCityImage, weather, latitude: latitude, longitude: longitude);
      print('⚡ [4] Final random fallback: $imagePath');
      return imagePath;
    }
  }

  /// 날씨 설명을 6가지 이미지 타입으로 매핑
  /// 
  /// OpenWeatherMap API의 다양한 날씨 설명을 SkyMesh의 6가지 이미지 타입으로
  /// 단순화하여 매핑합니다. 시간대를 고려한 석양 처리도 포함합니다.
  /// 
  /// @param weatherDescription OpenWeatherMap API의 날씨 설명 문자열
  /// @return String 매핑된 이미지 타입 (cloudy, foggy, rainy, snowy, sunny, sunset)
  /// 
  /// ## 매핑 규칙
  /// - **sunny**: clear sky, few clouds
  /// - **cloudy**: scattered clouds, broken clouds, overcast clouds
  /// - **rainy**: rain, shower rain, thunderstorm
  /// - **snowy**: snow
  /// - **foggy**: mist, fog, haze, smoke
  /// - **sunset**: 석양 시간대 (17-19시, 5-7시) 특별 처리
  /// 
  /// ## 시간대 고려사항
  /// 맑은 날씨일 때 일출/일몰 데이터를 기반으로 실제 해가 진 시간부터 해가 뜬 시간까지 석양 이미지를 사용합니다.
  /// 일출/일몰 데이터가 없는 경우 기본 시간대(오후 5-7시, 오전 5-7시)를 사용합니다.
  /// 
  /// ## 기본값
  /// 어떤 매칭 규칙에도 해당하지 않는 경우 'sunny'를 기본값으로 반환합니다.
  static String _mapWeatherCondition(String weatherDescription, {DateTime? sunrise, DateTime? sunset}) {
    final description = weatherDescription.toLowerCase();
    
    // 맑은 날씨나 구름 낀 날씨일 때 먼저 sunset 시간대 특별 처리 (다른 매핑보다 우선)
    if (_isClearOrCloudyWeather(description)) {
      final now = DateTime.now().toUtc(); // UTC로 변환해서 비교
      
      print('🌤️  Weather condition: "$weatherDescription" (${_isClearOrCloudyWeather(description) ? "sunset 적용 대상" : "sunset 제외"})');
      
      if (sunrise != null && sunset != null) {
        print('🌅 API Data - Sunrise: ${sunrise.toLocal()}, Sunset: ${sunset.toLocal()}');
        print('🌅 UTC Time - Sunrise: $sunrise, Sunset: $sunset, Now: $now');
        // 실제 일출/일몰 시간 기반 처리
        if (_isBetweenSunsetAndSunrise(now, sunrise, sunset)) {
          print('🌆 Sunset time detected! (API 기반)');
          return 'sunset';
        } else {
          print('☀️ Daytime detected (API 기반)');
        }
      } else {
        print('⏰ No sunrise/sunset data from API, using default time ranges');
        // 일출/일몰 데이터가 없는 경우 기본 시간대 사용 (UTC 기준)
        final hour = now.hour;
        if ((hour >= 17 && hour <= 19) || (hour >= 5 && hour <= 7)) {
          print('🌆 Default sunset time detected! (UTC ${hour}시)');
          return 'sunset';
        } else {
          print('☀️ Default daytime (UTC ${hour}시)');
        }
      }
    } else {
      print('🌧️  Weather condition: "$weatherDescription" (sunset 로직 제외 - 비/눈/안개)');
    }
    
    // sunset이 아닌 경우 일반 날씨 매핑 적용
    for (final entry in _weatherMapping.entries) {
      if (description.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return 'sunny'; // 기본값
  }
  
  /// 맑은 날씨 또는 구름 낀 날씨인지 확인 (sunset 적용 대상)
  static bool _isClearOrCloudyWeather(String description) {
    return description.contains('clear') || 
           description.contains('few clouds') ||
           description.contains('scattered clouds') ||
           description.contains('broken clouds') ||
           description.contains('overcast');
  }
  
  /// 현재 시간이 일몰과 일출 사이인지 확인 (모든 시간은 UTC)
  static bool _isBetweenSunsetAndSunrise(DateTime now, DateTime sunrise, DateTime sunset) {
    // 일반적인 경우: sunrise < sunset (같은 날 또는 연속된 날)
    // 밤 시간은 sunset 이후부터 다음 sunrise 이전까지
    
    print('🕐 Time comparison: sunrise=$sunrise, now=$now, sunset=$sunset');
    
    if (sunrise.isBefore(sunset)) {
      // 정상적인 경우: 일출이 일몰보다 이전 (같은 날)
      // 밤 시간: now < sunrise OR now > sunset
      final isNight = now.isBefore(sunrise) || now.isAfter(sunset);
      print('🕐 Normal case - isNight: $isNight');
      return isNight;
    } else {
      // 특수한 경우: 일출이 일몰보다 이후 (날짜를 넘나드는 경우)
      // 낮 시간: sunrise < now < sunset
      final isDay = now.isAfter(sunrise) && now.isBefore(sunset);
      print('🕐 Cross-date case - isNight: ${!isDay}');
      return !isDay;
    }
  }

  /// 도시별 이미지 경로 생성
  /// 
  /// 도시명과 날씨 조건을 기반으로 Flutter Assets 경로를 생성합니다.
  /// 도시는 7개 지역 폴더로 분류되어 있어 지역을 먼저 확인한 후 경로를 생성합니다.
  /// 
  /// @param cityName 도시명 (예: "seoul", "tokyo")
  /// @param weather 날씨 타입 (예: "sunny", "rainy")
  /// @param latitude 위도 (선택적, 향후 확장을 위해 보존)
  /// @param longitude 경도 (선택적, 향후 확장을 위해 보존)
  /// @return String Flutter Assets 경로
  /// 
  /// ## 경로 구조
  /// ```
  /// assets/location_images/regions/{region}/{city}_{weather}.webp
  /// ```
  /// 
  /// ## 예시
  /// - seoul + sunny → "assets/location_images/regions/asia/seoul_sunny.webp"
  /// - paris + rainy → "assets/location_images/regions/europe/paris_rainy.webp"
  /// - sydney + cloudy → "assets/location_images/regions/oceania/sydney_cloudy.webp"
  static String _buildImagePath(String cityName, String weather, {double? latitude, double? longitude}) {
    final region = _getCityRegion(cityName);
    return 'assets/location_images/regions/$region/${cityName}_${weather}.webp';
  }

  /// 도시가 속한 지역 폴더명 반환
  /// 
  /// 68개 지원 도시를 7개 지역 폴더로 분류하여 해당 도시가 속한
  /// 지역명을 반환합니다. 이는 이미지 파일 경로 생성에 사용됩니다.
  /// 
  /// @param cityName 도시명 (예: "seoul", "paris")
  /// @return String 지역 폴더명
  /// 
  /// ## 지역 분류
  /// - **asia**: 아시아 13개 도시
  /// - **middle_east**: 중동 4개 도시  
  /// - **europe**: 유럽 12개 도시
  /// - **north_america**: 북미 11개 도시
  /// - **south_america**: 남미 4개 도시
  /// - **africa**: 아프리카 5개 도시
  /// - **oceania**: 오세아니아 2개 도시
  /// 
  /// ## 기본값
  /// 매핑되지 않는 도시는 'asia'를 기본값으로 반환합니다.
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
      'sapporo': 'asia',
      'bali': 'asia',
      'phuket': 'asia',
      'angkor_wat': 'asia',
      'maldives': 'asia',
      
      // 중동
      'petra': 'middle_east',
      
      // 유럽
      'dubrovnik': 'europe',
      'zermatt': 'europe',
      'santorini': 'europe',
      
      // 북미
      'cancun': 'north_america',
      'aspen': 'north_america',
      'hawaii': 'oceania',
      
      // 남미
      'machu_picchu': 'south_america',
      
      // 오세아니아
      'tahiti': 'oceania',
      'queenstown': 'oceania',
      'sydney': 'oceania',
      'melbourne': 'oceania',
    };
    
    return cityToRegion[cityName] ?? 'asia'; // 기본값
  }

  /// 지역 대체 이미지 경로 생성
  /// 
  /// 지원되는 도시가 없는 국가나 지역의 경우 사용하는 대체 이미지 경로를 생성합니다.
  /// 10개 지역의 대체 이미지로 전 세계 대부분의 지역을 커버합니다.
  /// 
  /// @param regionName 지역 대체 이미지명
  /// @param weather 날씨 타입
  /// @return String Flutter Assets 경로
  /// 
  /// ## 경로 구조
  /// ```
  /// assets/location_images/regional_fallback/{region}/{region}_{weather}.webp
  /// ```
  /// 
  /// ## 지원 대체 지역
  /// - **central_asia**: 중앙아시아 (카자흐스탄, 우즈베키스탄 등)
  /// - **china_inland**: 중국 내륙 지역
  /// - **southern_china**: 중국 남부 지역
  /// - **northern_india**: 북인도 지역
  /// - **southeast_asia_extended**: 확장 동남아시아
  /// - **eastern_europe**: 동유럽
  /// - **northern_andes**: 북안데스 지역
  /// - **east_africa**: 동아프리카
  /// - **west_africa**: 서아프리카
  /// - **oceania_extended**: 확장 오세아니아
  static String _buildRegionalImagePath(String regionName, String weather) {
    return 'assets/location_images/regional_fallback/${regionName}/${regionName}_${weather}.webp';
  }

  /// SkyMesh에서 지원하는 모든 고유 도시 목록 반환
  /// 
  /// 83개 주요 도시의 목록을 반환합니다. 이 도시들은 각각 6가지 날씨 조건의
  /// 로우폴리 이미지를 보유하고 있습니다.
  /// 베이징, 상하이의 하위 구들은 제외하고 실제 고유 도시만 포함합니다.
  /// 
  /// @return List<String> 지원 도시 목록
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final cities = LocationImageService.getAllSupportedCities();
  /// print('지원 도시 수: ${cities.length}'); // 83
  /// print('첫 번째 도시: ${cities.first}');
  /// ```
  /// 
  /// ## 활용 방안
  /// - 랜덤 도시 선택을 위한 풀 제공
  /// - UI에서 도시 리스트 표시
  /// - 디버그 및 테스트 용도
  static List<String> getAllSupportedCities() {
    return _cityImages.keys.toList();
  }

  /// 특정 국가에서 지원하는 도시 목록 반환
  /// 
  /// ISO 3166-1 alpha-2 국가코드를 바탕으로 해당 국가에서 직접 지원하는
  /// 도시들의 목록을 반환합니다.
  /// 
  /// @param countryCode ISO 3166-1 alpha-2 국가코드 (예: "KR", "US", "JP")
  /// @return List<String> 해당 국가의 지원 도시 목록 (빈 리스트 가능)
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final koreanCities = LocationImageService.getCitiesForCountry('KR');
  /// print(koreanCities); // ['seoul']
  /// 
  /// final usCities = LocationImageService.getCitiesForCountry('US');
  /// print(usCities.length); // 8 (뉴욕, LA, 샌프란시스코 등)
  /// 
  /// final unknownCities = LocationImageService.getCitiesForCountry('XX');
  /// print(unknownCities); // [] (빈 리스트)
  /// ```
  /// 
  /// ## 주요 국가별 도시 수
  /// - 미국 (US): 8개 도시
  /// - 중국 (CN): 2개 도시 (베이징, 상하이)
  /// - 인도 (IN): 2개 도시 (방갈로르, 뮄바이)
  /// - 기타 대부분 국가: 1개 도시
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

  /// 지역별 대표 좌표 (지역 대체 이미지를 위한 중심점)
  static const Map<String, List<double>> _regionCoordinates = {
    'central_asia': [42.0, 64.0],           // 중앙아시아 중심부
    'china_inland': [35.0, 104.0],          // 중국 내륙 중심부
    'southern_china': [23.0, 113.0],        // 중국 남부 (광저우 인근)
    'northern_india': [28.0, 77.0],         // 북인도 (델리 인근)
    'southeast_asia_extended': [0.0, 110.0], // 동남아시아 확장
    'eastern_europe': [50.0, 20.0],         // 동유럽 중심부
    'northern_andes': [0.0, -75.0],         // 북안데스 (에콰도르/콜롬비아)
    'east_africa': [-5.0, 35.0],           // 동아프리카 (케냐/탄자니아)
    'west_africa': [10.0, 0.0],            // 서아프리카 (가나/나이지리아)
    'oceania_extended': [-15.0, 170.0],     // 확장 오세아니아
  };

  /// 가장 가까운 지역 찾기
  static String _findNearestRegion(double latitude, double longitude) {
    String nearestRegion = 'central_asia'; // 기본값
    double minDistance = double.infinity;
    
    for (String region in _regionCoordinates.keys) {
      List<double> coords = _regionCoordinates[region]!;
      double distance = _calculateDistance(latitude, longitude, coords[0], coords[1]);
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestRegion = region;
      }
    }
    
    print('📍 Nearest region: $nearestRegion (${minDistance.toStringAsFixed(1)}km away)');
    return nearestRegion;
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