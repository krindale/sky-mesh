/// GPS 위치 서비스 구현체
/// 
/// 이 파일은 Geolocator 패키지를 사용하여 LocationService 인터페이스를 구현합니다.
/// 실제 GPS 하드웨어와 상호작용하여 사용자의 현재 위치를 조회하고,
/// 위치 권한 관리 및 오류 처리를 담당합니다.
/// 
/// ## 아키텍처 특징
/// - **SRP 준수**: 위치 조회 및 권한 관리만 담당
/// - **플랫폼 호환성**: 모바일(Android/iOS)과 웹 모두 지원
/// - **오류 처리**: 상세한 오류 메시지와 복구 가이드 제공
/// - **권한 관리**: 단계별 권한 확인 및 요청 처리
/// 
/// ## 지원 플랫폼
/// - **Android**: GPS, 네트워크 위치 제공자 지원
/// - **iOS**: Core Location 프레임워크 통합
/// - **Web**: Geolocation API 지원 (HTTPS 필요)
/// 
/// ## 정확도 및 성능
/// - 높은 정확도 (GPS 우선)
/// - 10초 타임아웃으로 응답성 보장
/// - 배터리 효율성 고려한 위치 업데이트
/// 
/// @author krindale
/// @since 1.0.0

// 외부 패키지 imports
import 'package:geolocator/geolocator.dart';    // GPS 위치 서비스
import 'package:flutter/foundation.dart';       // 플랫폼 감지 (kIsWeb)

// 내부 인터페이스 import
import '../../core/interfaces/location_service.dart';  // LocationService 추상화

/// Geolocator 패키지를 사용한 위치 서비스 구체적 구현
/// 
/// LocationService 인터페이스를 구현하여 실제 GPS 하드웨어와
/// 상호작용합니다. 크로스 플랫폼 호환성을 제공하며,
/// 권한 관리와 오류 처리를 포괄적으로 수행합니다.
/// 
/// ## SOLID 원칙 준수
/// - **SRP**: 위치 관련 작업만 담당
/// - **OCP**: 새로운 위치 제공자 추가 시 확장 가능
/// - **LSP**: LocationService 인터페이스와 완전 호환
/// - **DIP**: 구체적 구현이 아닌 Geolocator 추상화에 의존
/// 
/// ## 위치 정확도 전략
/// - **High Accuracy**: GPS 우선 사용으로 최고 정밀도
/// - **Battery Optimization**: 필요시에만 GPS 활성화
/// - **Timeout Management**: 10초 제한으로 응답성 보장
/// 
/// ## 플랫폼별 특성
/// ### 모바일 (Android/iOS)
/// - GPS 하드웨어 직접 액세스
/// - 백그라운드 위치 업데이트 지원
/// - 시스템 위치 설정과 연동
/// 
/// ### 웹 (Browser)
/// - HTML5 Geolocation API 사용
/// - HTTPS 연결 필수
/// - 브라우저 권한 시스템 의존
class GeolocatorService implements LocationService {
  /// 현재 GPS 위치 조회
  /// 
  /// 사용자의 현재 위치를 높은 정확도로 조회합니다.
  /// 위치 서비스와 권한을 먼저 확인한 후 실제 위치를 요청합니다.
  /// 
  /// @return Future<Position> 위도, 경도, 정확도 등을 포함한 위치 정보
  /// @throws Exception 위치 서비스 비활성화, 권한 거부, 네트워크 오류 등
  /// 
  /// ## 위치 조회 과정
  /// 1. 위치 서비스 활성화 확인
  /// 2. 앱 권한 상태 확인 및 요청
  /// 3. 고정밀 GPS 위치 조회 (10초 타임아웃)
  /// 4. 플랫폼별 오류 처리 및 사용자 가이드
  /// 
  /// ## 정확도 설정
  /// - **LocationAccuracy.high**: GPS 우선, 3-5m 정확도
  /// - **timeLimit**: 10초 제한으로 사용자 경험 보장
  /// 
  /// ## 플랫폼별 고려사항
  /// ### 모바일
  /// - GPS 하드웨어 상태 확인
  /// - 배터리 최적화 설정 영향
  /// - 실내/실외 환경에 따른 정확도 차이
  /// 
  /// ### 웹
  /// - HTTPS 연결 필수
  /// - 브라우저별 구현 차이
  /// - 사용자 명시적 허용 필요
  @override
  Future<Position> getCurrentLocation() async {
    // 1단계: 위치 서비스 및 권한 종합 확인
    // 실패 시 구체적인 오류 메시지와 해결 방법 제공
    await _checkLocationServiceAndPermissions();
    
    try {
      // 2단계: 고정밀 GPS 위치 조회
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,    // 최고 정확도 (GPS 우선)
        timeLimit: const Duration(seconds: 10),    // 10초 타임아웃 (사용자 경험)
      );
    } catch (e) {
      // 3단계: 플랫폼별 오류 처리 및 사용자 가이드
      if (kIsWeb) {
        // 웹 환경: HTTPS 및 브라우저 권한 관련 안내
        throw Exception('Cannot get location. Please ensure you\'re using HTTPS and allow location access.');
      } else {
        // 모바일 환경: GPS 하드웨어 및 시스템 설정 관련 안내
        throw Exception('Failed to get current location: $e');
      }
    }
  }

  /// 위치 서비스 활성화 상태 확인
  /// 
  /// 디바이스에서 위치 서비스가 전역적으로 활성화되어 있는지 확인합니다.
  /// GPS, 네트워크 위치, 패시브 위치 등 모든 위치 제공자를 포함합니다.
  /// 
  /// @return Future<bool> 위치 서비스 활성화 여부
  /// 
  /// ## 확인 범위
  /// - **모바일**: 시스템 설정의 위치 서비스 상태
  /// - **웹**: 브라우저의 위치 API 사용 가능성
  /// 
  /// ## 비활성화 원인
  /// ### Android
  /// - 위치 서비스 전체 비활성화
  /// - 배터리 절약 모드
  /// - 개발자 옵션에서 모의 위치 설정
  /// 
  /// ### iOS
  /// - 개인정보 보호 설정에서 위치 서비스 비활성화
  /// - 저전력 모드 활성화
  /// 
  /// ### 웹
  /// - HTTPS가 아닌 연결
  /// - 브라우저에서 위치 기능 비활성화
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// 앱의 위치 권한 상태 확인
  /// 
  /// 현재 앱이 위치 정보에 접근할 수 있는 권한이 있는지 확인합니다.
  /// 시스템 위치 서비스와는 별개로 앱별 권한을 확인합니다.
  /// 
  /// @return Future<LocationPermission> 권한 상태 열거값
  /// 
  /// ## 권한 상태 종류
  /// - **denied**: 권한이 거부됨 (재요청 가능)
  /// - **deniedForever**: 권한이 영구 거부됨 (설정에서 변경 필요)
  /// - **whileInUse**: 앱 사용 중에만 허용
  /// - **always**: 항상 허용 (백그라운드 포함)
  /// 
  /// ## 플랫폼별 권한 시스템
  /// ### Android
  /// - 런타임 권한 시스템 (API 23+)
  /// - 정확한 위치 vs 대략적 위치 구분
  /// - 백그라운드 위치 권한 별도 관리
  /// 
  /// ### iOS
  /// - 앱별 권한 관리
  /// - 사용 중 vs 항상 허용 구분
  /// - 정확한 위치 vs 대략적 위치 선택
  /// 
  /// ### 웹
  /// - 브라우저별 권한 관리
  /// - 도메인별 권한 기억
  /// - 사용자 명시적 허용 필요
  @override
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// 위치 권한 요청
  /// 
  /// 사용자에게 위치 정보 접근 권한을 요청합니다.
  /// 시스템 권한 다이얼로그를 표시하고 사용자의 선택을 기다립니다.
  /// 
  /// @return Future<LocationPermission> 사용자 선택 후 권한 상태
  /// 
  /// ## 권한 요청 과정
  /// 1. 시스템 권한 다이얼로그 표시
  /// 2. 사용자 선택 대기 (허용/거부/항상 거부)
  /// 3. 결과에 따른 권한 상태 반환
  /// 
  /// ## 권한 요청 전략
  /// - **적절한 타이밍**: 기능 사용 직전에 요청
  /// - **명확한 이유**: 왜 위치가 필요한지 설명
  /// - **대체 방안**: 권한 거부 시 대안 제공
  /// 
  /// ## 플랫폼별 동작
  /// ### Android
  /// - 시스템 권한 다이얼로그 표시
  /// - "항상 거부" 선택 시 다시 요청 불가
  /// - 앱 정보에서 수동 변경 필요
  /// 
  /// ### iOS
  /// - 앱 최초 실행 시 자동 요청
  /// - 거부 후 재요청 시 설정 앱으로 이동 안내
  /// - 위치 정확도 선택 옵션 제공
  /// 
  /// ### 웹
  /// - 브라우저 권한 팝업 표시
  /// - HTTPS 연결에서만 동작
  /// - 브라우저별 UI 차이
  @override
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// 위치 서비스 및 권한 종합 확인 (내부 메서드)
  /// 
  /// 위치 조회 전에 필요한 모든 전제조건을 확인하고 필요시 권한을 요청합니다.
  /// 각 단계에서 실패 시 구체적인 오류 메시지와 해결 방법을 제공합니다.
  /// 
  /// @throws Exception 위치 서비스 비활성화, 권한 거부 등의 경우
  /// 
  /// ## 확인 및 처리 과정
  /// ### 1단계: 위치 서비스 확인
  /// - 디바이스 전역 위치 서비스 상태 확인
  /// - 비활성화 시 플랫폼별 활성화 가이드 제공
  /// 
  /// ### 2단계: 권한 상태 확인
  /// - 현재 앱의 위치 권한 상태 확인
  /// - 거부된 경우 자동으로 권한 요청
  /// 
  /// ### 3단계: 권한 요청 결과 처리
  /// - 권한 허용: 정상 진행
  /// - 권한 거부: 재요청 또는 설정 안내
  /// - 영구 거부: 설정 앱으로 이동 안내
  /// 
  /// ## 플랫폼별 오류 메시지
  /// ### 웹 환경
  /// - HTTPS 필요성 안내
  /// - 브라우저 설정 변경 가이드
  /// - 사이트 권한 재설정 방법
  /// 
  /// ### 모바일 환경
  /// - GPS 활성화 안내
  /// - 앱 설정 변경 가이드
  /// - 시스템 위치 서비스 활성화 방법
  /// 
  /// ## 오류 상황별 복구 방법
  /// - **서비스 비활성화**: 시스템 설정에서 위치 서비스 활성화
  /// - **권한 거부**: 앱 설정에서 위치 권한 허용
  /// - **영구 거부**: 앱 삭제 후 재설치 또는 시스템 설정 변경
  Future<void> _checkLocationServiceAndPermissions() async {
    // === 1단계: 플랫폼별 위치 서비스 확인 ===
    
    if (kIsWeb) {
      // 웹 환경: 브라우저 위치 API 및 HTTPS 확인
      try {
        bool serviceEnabled = await isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled. Please enable location in your browser settings.');
        }
      } catch (e) {
        // 웹에서 위치 API 접근 실패 시 (HTTPS 필요 등)
        throw Exception('Web location not available. Please use HTTPS or allow location access.');
      }
    } else {
      // 모바일 환경: 시스템 GPS 서비스 확인
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }
    }

    // === 2단계: 앱 권한 상태 확인 및 요청 ===
    
    LocationPermission permission = await checkPermission();
    
    // 권한이 거부된 경우 자동으로 요청
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      
      // 요청 후에도 거부된 경우
      if (permission == LocationPermission.denied) {
        if (kIsWeb) {
          throw Exception('Location permission denied. Please allow location access in your browser.');
        } else {
          throw Exception('Location permissions are denied');
        }
      }
    }

    // === 3단계: 영구 거부 상태 처리 ===
    
    // 사용자가 "다시 묻지 않음"을 선택한 경우
    if (permission == LocationPermission.deniedForever) {
      if (kIsWeb) {
        // 웹: 브라우저 사이트 설정에서 권한 재설정 필요
        throw Exception('Location permanently blocked. Please reset site permissions in browser settings.');
      } else {
        // 모바일: 앱 설정에서 수동으로 권한 변경 필요
        throw Exception('Location permissions are permanently denied. Please enable in app settings.');
      }
    }
  }
}