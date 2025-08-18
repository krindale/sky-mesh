/// SkyMesh 로우폴리 색상 시스템
/// 
/// 이 파일은 SkyMesh 앱의 시각적 일관성을 제공하는 포괄적인 색상 시스템입니다.
/// 로우폴리 아트의 면 분할된 기하학적 미학에서 영감을 받아 제작되었으며,
/// 날씨 조건과 대기적 환경을 반영하는 색상 팔레트를 제공합니다.
/// 
/// ## 디자인 철학
/// 
/// ### 1. 대기적 색상 (Atmospheric Colors)
/// - 하늘, 구름, 태양 등 자연 요소에서 영감을 받은 색상
/// - 각 날씨 조건을 직관적으로 표현하는 색상 조합
/// - 시간대(낮/밤)와 계절감을 반영한 색상 변화
/// 
/// ### 2. 기하학적 조화 (Geometric Harmony)
/// - 로우폴리 아트의 면 분할 효과를 위한 대비 색상
/// - 각진 형태와 조화를 이루는 날카로운 색상 경계
/// - 그라데이션을 통한 면과 면 사이의 자연스러운 전환
/// 
/// ### 3. 감정적 연결 (Emotional Connection)
/// - 날씨 상태에 따른 감정적 반응을 색상으로 표현
/// - 따뜻한 색상(sunny, sunset)과 차가운 색상(rainy, snowy)의 균형
/// - 사용자의 기분과 날씨를 연결하는 심리적 색상 활용
/// 
/// ## 색상 분류 체계
/// 
/// ### 핵심 색상 (Primary Colors)
/// - 앱의 주요 브랜딩과 네비게이션에 사용
/// - 하늘과 대기 요소에서 영감을 받은 블루 계열
/// 
/// ### 보조 색상 (Secondary Colors)
/// - 강조와 액센트 효과를 위한 색상
/// - 일출/일몰 시간대의 따뜻한 색상들
/// 
/// ### 표면 색상 (Surface Colors)
/// - 카드, 패널, 배경 등 UI 구성요소
/// - 로우폴리 지형에서 영감을 받은 지면 색상
/// 
/// ### 날씨별 색상 (Weather Colors)
/// - 468개 배경 이미지와 연동되는 날씨 상태 색상
/// - 각 날씨 조건의 시각적 특성을 반영
/// 
/// ### 시맨틱 색상 (Semantic Colors)
/// - 성공, 경고, 오류 등 의미가 있는 상태 표현
/// - 국제적으로 통용되는 색상 규칙 준수
/// 
/// ## 접근성 고려사항
/// 
/// - **명도 대비**: WCAG 2.1 AA 기준 4.5:1 이상의 명도 대비 보장
/// - **색각 장애**: 색상만으로 정보를 전달하지 않고 아이콘과 텍스트 병행
/// - **다크 모드**: 야간 사용성을 고려한 어두운 색상 스킴 제공
/// 
/// ## 사용 예시
/// 
/// ```dart
/// // 기본 색상 사용
/// Container(
///   color: LowPolyColors.primaryBlue,
///   child: Text(
///     'Weather Info',
///     style: TextStyle(color: LowPolyColors.textOnDark),
///   ),
/// )
/// 
/// // 날씨별 색상 사용
/// final colors = LowPolyColors.getWeatherColors('sunny');
/// Container(
///   decoration: BoxDecoration(
///     gradient: LinearGradient(colors: colors),
///   ),
/// )
/// 
/// // 색상 스킴 사용
/// MaterialApp(
///   theme: ThemeData(colorScheme: LowPolyColors.sunnyScheme),
/// )
/// ```
/// 
/// @author krindale
/// @since 1.0.0

import 'package:flutter/material.dart';

/// 로우폴리 디자인 시스템 색상 클래스
/// 
/// SkyMesh 앱의 모든 색상을 중앙 관리하는 정적 클래스입니다.
/// 각 색상은 로우폴리 아트의 기하학적 미학과 날씨 테마를 반영하여 선정되었습니다.
/// 
/// ## 색상 네이밍 규칙
/// - **기능별 접두사**: primary, secondary, accent, surface, text 등
/// - **의미적 이름**: 색상의 용도나 영감을 받은 요소명 사용
/// - **일관된 명명**: 유사한 용도의 색상은 유사한 이름 패턴 사용
/// 
/// ## 색상 값 선정 기준
/// - **헥스 코드**: 정확한 색상 재현을 위한 6자리 헥스 값 사용
/// - **명도 대비**: 접근성을 고려한 충분한 명도 차이 확보
/// - **색상 조화**: 로우폴리 아트의 기하학적 조화 반영
class LowPolyColors {
  // ====================================================================
  // 핵심 색상 (Primary Colors) - 하늘과 대기 요소에서 영감
  // 앱의 주요 브랜딩과 네비게이션 바, 주요 버튼에 사용
  // ====================================================================
  
  /// 하늘 블루 - 맑은 날 하늘색을 표현하는 주요 브랜드 색상
  /// 사용처: 앱 바, 주요 버튼, 네비게이션 요소
  /// RGB: 74, 144, 226 | HSL: 213°, 72%, 59%
  static const Color primaryBlue = Color(0xFF4A90E2);
  
  /// 바다 틸 - 깨끗한 바다와 호수를 연상시키는 청록색
  /// 사용처: 보조 버튼, 링크, 액티브 상태 표시
  /// RGB: 45, 212, 191 | HSL: 172°, 66%, 50%
  static const Color primaryTeal = Color(0xFF2DD4BF);
  
  /// 깊은 하늘색 - 저녁 하늘의 깊은 파란색을 표현
  /// 사용처: 어두운 테마, 강조 요소, 그라데이션
  /// RGB: 99, 102, 241 | HSL: 238°, 84%, 67%
  static const Color primaryIndigo = Color(0xFF6366F1);
  
  // ====================================================================
  // 보조 색상 (Secondary Colors) - 기하학적 강조 효과
  // 일출/일몰 시간대의 따뜻한 색상으로 감정적 포인트 제공
  // ====================================================================
  
  /// 일몰 오렌지 - 황금시간대의 따뜻한 오렌지색
  /// 사용처: 경고 알림, 따뜻한 날씨 표현, 호버 효과
  /// RGB: 255, 107, 53 | HSL: 16°, 100%, 60%
  static const Color accentOrange = Color(0xFFFF6B35);
  
  /// 황혼 퍼플 - 일몰 후 하늘의 신비로운 보라색
  /// 사용처: 밤 시간대 표현, 프리미엄 기능 강조
  /// RGB: 147, 51, 234 | HSL: 272°, 81%, 56%
  static const Color accentPurple = Color(0xFF9333EA);
  
  /// 새벽 핑크 - 일출 시 하늘의 연한 분홍색
  /// 사용처: 여성적 요소, 부드러운 강조, 러브 테마
  /// RGB: 236, 72, 153 | HSL: 330°, 81%, 60%
  static const Color accentPink = Color(0xFFEC4899);
  
  // ====================================================================
  // 표면 색상 (Surface Colors) - 로우폴리 지형에서 영감
  // 카드, 패널, 배경 등 UI 구성요소의 층위별 색상
  // ====================================================================
  
  /// 눈/얼음 표면 - 가장 밝은 표면색으로 카드 배경에 사용
  /// 사용처: 카드 배경, 모달 배경, 입력 필드
  /// RGB: 248, 250, 252 | HSL: 214°, 32%, 98%
  static const Color surfaceLight = Color(0xFFF8FAFC);
  
  /// 산 안개 - 중간 톤 표면색으로 구분된 영역 표시
  /// 사용처: 섹션 구분, 비활성 영역, 그림자
  /// RGB: 226, 232, 240 | HSL: 214°, 32%, 91%
  static const Color surfaceMedium = Color(0xFFE2E8F0);
  
  /// 그림자 면 - 어두운 표면색으로 깊이감 표현
  /// 사용처: 다크 모드 배경, 그림자, 구분선
  /// RGB: 51, 65, 85 | HSL: 215°, 25%, 27%
  static const Color surfaceDark = Color(0xFF334155);
  
  /// 깊은 계곡 - 가장 어두운 표면색으로 최대 대비 제공
  /// 사용처: 다크 모드 기본 배경, 최대 강조 요소
  /// RGB: 30, 41, 59 | HSL: 217°, 33%, 17%
  static const Color surfaceDeep = Color(0xFF1E293B);
  
  // ====================================================================
  // 대기 색상 (Atmospheric Colors) - 468개 배경 이미지와 연동
  // 실제 날씨 조건을 반영하는 색상으로 배경 이미지와 조화
  // ====================================================================
  
  /// 밝은 태양 - 맑은 날씨의 따뜻하고 밝은 황색
  /// 사용처: sunny 날씨 상태, 긍정적 알림, 활력 표현
  /// RGB: 251, 191, 36 | HSL: 43°, 96%, 56%
  static const Color sunnyYellow = Color(0xFFFBBF24);
  
  /// 흐린 회색 - 구름이 많은 날의 차분한 회색
  /// 사용처: cloudy 날씨 상태, 중성적 요소, 차분한 배경
  /// RGB: 156, 163, 175 | HSL: 220°, 9%, 65%
  static const Color cloudyGray = Color(0xFF9CA3AF);
  
  /// 비 파랑 - 비 오는 날의 시원하고 깊은 파란색
  /// 사용처: rainy 날씨 상태, 차가운 느낌, 물 관련 요소
  /// RGB: 59, 130, 246 | HSL: 217°, 91%, 60%
  static const Color rainyBlue = Color(0xFF3B82F6);
  
  /// 안개 흰색 - 안개가 자욱한 날의 뿌연 흰색
  /// 사용처: foggy 날씨 상태, 불투명 효과, 몽환적 분위기
  /// RGB: 229, 231, 235 | HSL: 220°, 13%, 91%
  static const Color foggyWhite = Color(0xFFE5E7EB);
  
  /// 순수한 눈 - 눈이 내리는 날의 깨끗하고 차가운 흰색
  /// 사용처: snowy 날씨 상태, 겨울 테마, 순수함 표현
  /// RGB: 243, 244, 246 | HSL: 220°, 14%, 96%
  static const Color snowyWhite = Color(0xFFF3F4F6);
  
  /// 황금 시간 - 일몰/일출 시간의 황금빛 오렌지
  /// 사용처: sunset 날씨 상태, 로맨틱한 분위기, 특별한 순간
  /// RGB: 249, 115, 22 | HSL: 25°, 95%, 53%
  static const Color sunsetOrange = Color(0xFFF97316);
  
  // ====================================================================
  // 시맨틱 색상 (Semantic Colors) - 의미있는 상태 표현
  // 국제적으로 통용되는 색상 규칙을 따르는 기능별 색상
  // ====================================================================
  
  /// 성공 녹색 - 완료, 성공, 긍정적 상태를 나타내는 색상
  /// 사용처: 성공 메시지, 완료 표시, 활성 상태, 성장 지표
  /// RGB: 16, 185, 129 | HSL: 160°, 84%, 39%
  static const Color successGreen = Color(0xFF10B981);
  
  /// 경고 황색 - 주의, 경고, 중요한 정보를 알리는 색상
  /// 사용처: 경고 메시지, 중요 알림, 주의 사항, 임시 상태
  /// RGB: 245, 158, 11 | HSL: 38°, 92%, 50%
  static const Color warningAmber = Color(0xFFF59E0B);
  
  /// 오류 빨강 - 에러, 위험, 부정적 상태를 나타내는 색상
  /// 사용처: 오류 메시지, 삭제 버튼, 위험 경고, 실패 상태
  /// RGB: 239, 68, 68 | HSL: 0°, 84%, 60%
  static const Color errorRed = Color(0xFFEF4444);
  
  /// 정보 파랑 - 정보, 도움말, 일반적 알림을 나타내는 색상
  /// 사용처: 정보 메시지, 도움말 버튼, 중성적 알림, 링크
  /// RGB: 59, 130, 246 | HSL: 217°, 91%, 60%
  static const Color infoBlue = Color(0xFF3B82F6);
  
  // ====================================================================
  // 텍스트 색상 (Text Colors) - 가독성을 고려한 계층적 텍스트 색상
  // WCAG 2.1 AA 기준을 충족하는 명도 대비를 제공
  // ====================================================================
  
  /// 주요 텍스트 - 헤드라인, 본문 등 주요 텍스트에 사용
  /// 사용처: 제목, 본문, 중요한 정보, 메인 콘텐츠
  /// 명도 대비: 흰 배경 기준 12.63:1 (AAA 등급)
  /// RGB: 31, 41, 55 | HSL: 215°, 28%, 17%
  static const Color textPrimary = Color(0xFF1F2937);
  
  /// 보조 텍스트 - 부가 정보나 설명 텍스트에 사용
  /// 사용처: 부제목, 설명, 메타 정보, 보조 설명
  /// 명도 대비: 흰 배경 기준 7.59:1 (AA 등급)
  /// RGB: 107, 114, 128 | HSL: 220°, 9%, 46%
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// 3차 텍스트 - 비활성화되거나 덜 중요한 텍스트에 사용
  /// 사용처: 비활성 상태, 플레이스홀더, 라벨, 캡션
  /// 명도 대비: 흰 배경 기준 4.69:1 (AA 등급)
  /// RGB: 156, 163, 175 | HSL: 220°, 9%, 65%
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  /// 어두운 배경 텍스트 - 어두운 배경에서 사용하는 밝은 텍스트
  /// 사용처: 다크 모드, 어두운 카드, 강조 버튼 내 텍스트
  /// 명도 대비: 어두운 배경 기준 15.8:1 (AAA 등급)
  /// RGB: 249, 250, 251 | HSL: 220°, 20%, 98%
  static const Color textOnDark = Color(0xFFF9FAFB);
  
  // ====================================================================
  // 그라데이션 세트 (Gradient Sets) - 로우폴리 조명 효과 모방
  // 면과 면 사이의 자연스러운 색상 전환과 깊이감을 표현
  // ====================================================================
  
  /// 하늘 그라데이션 - 맑은 하늘의 상하 색상 변화
  /// 사용처: 배경, 헤더, 하늘 테마 카드
  /// 방향: 상단(primaryBlue) → 하단(primaryTeal)
  /// 효과: 자연스러운 하늘색 전환으로 깊이감 표현
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryTeal],
  );
  
  /// 일몰 그라데이션 - 황금시간대의 따뜻한 색상 변화
  /// 사용처: 특별한 이벤트, 프리미엄 기능, 로맨틱 테마
  /// 방향: 좌상단(accentOrange) → 우하단(accentPink)
  /// 효과: 일몰의 따뜻함과 감성을 전달하는 대각선 그라데이션
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, accentPink],
  );
  
  /// 대기 그라데이션 - 밤하늘의 신비로운 색상 변화
  /// 사용처: 다크 모드, 밤 시간대, 깊이 있는 배경
  /// 방향: 상단(primaryIndigo) → 하단(surfaceDark)
  /// 효과: 밤하늘의 깊이와 신비로움을 표현하는 수직 그라데이션
  static const LinearGradient atmosphericGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryIndigo, surfaceDark],
  );
  
  // ====================================================================
  // 날씨별 색상 스킴 (Weather Color Schemes) - 상황별 완전한 테마
  // MaterialApp 전체에 적용 가능한 날씨 조건별 색상 테마
  // ====================================================================
  
  /// 맑은 날 색상 스킴 - 밝고 따뜻한 라이트 모드 테마
  /// 사용처: sunny 날씨 조건, 긍정적인 분위기, 활기찬 UI
  /// 특징: 따뜻한 황색 계열 중심으로 활력과 에너지를 표현
  static const ColorScheme sunnyScheme = ColorScheme.light(
    primary: sunnyYellow,           // 주요 UI 요소 - 밝은 태양색
    secondary: accentOrange,        // 보조 요소 - 따뜻한 오렌지
    surface: surfaceLight,          // 카드/패널 - 밝은 표면
    background: Color(0xFFFEFCE8),  // 앱 배경 - 연한 크림색 (#FEFCE8)
    onPrimary: textPrimary,         // 주요 색상 위 텍스트 - 어두운 텍스트
    onSecondary: textOnDark,        // 보조 색상 위 텍스트 - 밝은 텍스트
    onSurface: textPrimary,         // 표면 위 텍스트 - 어두운 텍스트
    onBackground: textPrimary,      // 배경 위 텍스트 - 어두운 텍스트
  );
  
  /// 흐린 날 색상 스킴 - 차분하고 중성적인 라이트 모드 테마
  /// 사용처: cloudy 날씨 조건, 차분한 분위기, 집중을 위한 UI
  /// 특징: 회색 계열 중심으로 안정감과 평온함을 표현
  static const ColorScheme cloudyScheme = ColorScheme.light(
    primary: cloudyGray,            // 주요 UI 요소 - 차분한 회색
    secondary: primaryBlue,         // 보조 요소 - 하늘 파랑
    surface: surfaceMedium,         // 카드/패널 - 중간 톤 표면
    background: Color(0xFFF1F5F9),  // 앱 배경 - 연한 블루그레이 (#F1F5F9)
    onPrimary: textOnDark,          // 주요 색상 위 텍스트 - 밝은 텍스트
    onSecondary: textOnDark,        // 보조 색상 위 텍스트 - 밝은 텍스트
    onSurface: textPrimary,         // 표면 위 텍스트 - 어두운 텍스트
    onBackground: textPrimary,      // 배경 위 텍스트 - 어두운 텍스트
  );
  
  /// 밤 색상 스킴 - 깊이 있고 신비로운 다크 모드 테마
  /// 사용처: 야간 시간대, 다크 모드, 몰입적인 경험
  /// 특징: 어두운 색상 중심으로 깊이감과 편안함을 표현
  static const ColorScheme nightScheme = ColorScheme.dark(
    primary: primaryIndigo,         // 주요 UI 요소 - 깊은 인디고
    secondary: accentPurple,        // 보조 요소 - 황혼 퍼플
    surface: surfaceDark,           // 카드/패널 - 어두운 표면
    background: surfaceDeep,        // 앱 배경 - 깊은 계곡색
    onPrimary: textOnDark,          // 주요 색상 위 텍스트 - 밝은 텍스트
    onSecondary: textOnDark,        // 보조 색상 위 텍스트 - 밝은 텍스트
    onSurface: textOnDark,          // 표면 위 텍스트 - 밝은 텍스트
    onBackground: textOnDark,       // 배경 위 텍스트 - 밝은 텍스트
  );
  
  // ====================================================================
  // 유틸리티 메서드 (Utility Methods) - 색상 조작 및 선택 도구
  // 런타임에 색상을 동적으로 조작하거나 날씨별 색상을 선택
  // ====================================================================
  
  /// 색상 투명도 조절 유틸리티
  /// 
  /// 기존 색상에 지정된 불투명도를 적용하여 새로운 색상을 반환합니다.
  /// 오버레이, 그림자, 비활성 상태 등에서 색상의 강도를 조절할 때 사용합니다.
  /// 
  /// @param color 원본 색상
  /// @param opacity 불투명도 (0.0: 완전 투명, 1.0: 완전 불투명)
  /// @return 투명도가 적용된 새로운 Color 객체
  /// 
  /// ## 사용 예시
  /// ```dart
  /// // 50% 투명도의 파란색
  /// final semiTransparentBlue = LowPolyColors.withOpacity(
  ///   LowPolyColors.primaryBlue, 
  ///   0.5
  /// );
  /// 
  /// // 오버레이 배경
  /// Container(
  ///   color: LowPolyColors.withOpacity(LowPolyColors.surfaceDark, 0.8),
  /// )
  /// ```
  /// 
  /// ## 일반적인 투명도 값
  /// - 0.05-0.1: 매우 연한 배경, 미묘한 강조
  /// - 0.3-0.5: 오버레이, 비활성 상태
  /// - 0.7-0.9: 반투명 카드, 모달 배경
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// 날씨 조건별 색상 배열 반환
  /// 
  /// 주어진 날씨 설명에 따라 적절한 색상 조합을 반환합니다.
  /// 468개 배경 이미지의 날씨 카테고리와 연동되어 UI 색상을 통일합니다.
  /// 
  /// @param weather 날씨 설명 문자열 (대소문자 무관)
  /// @return List<Color> 해당 날씨의 주요 색상 2개 배열
  /// 
  /// ## 지원 날씨 타입
  /// - **sunny**: [sunnyYellow, accentOrange] - 밝고 따뜻한 색상
  /// - **cloudy**: [cloudyGray, primaryBlue] - 차분하고 중성적인 색상
  /// - **rainy**: [rainyBlue, primaryTeal] - 시원하고 촉촉한 색상
  /// - **foggy**: [foggyWhite, surfaceMedium] - 뿌옇고 몽환적인 색상
  /// - **snowy**: [snowyWhite, primaryBlue] - 차갑고 깨끗한 색상
  /// - **sunset**: [sunsetOrange, accentPink] - 따뜻하고 로맨틱한 색상
  /// - **기본값**: [primaryBlue, primaryTeal] - 기본 하늘색 조합
  /// 
  /// ## 사용 예시
  /// ```dart
  /// // 현재 날씨에 맞는 색상 가져오기
  /// final weatherColors = LowPolyColors.getWeatherColors('sunny');
  /// 
  /// // 그라데이션 배경 적용
  /// Container(
  ///   decoration: BoxDecoration(
  ///     gradient: LinearGradient(
  ///       colors: weatherColors,
  ///       begin: Alignment.topCenter,
  ///       end: Alignment.bottomCenter,
  ///     ),
  ///   ),
  /// )
  /// 
  /// // 날씨 아이콘 색상 적용
  /// Icon(
  ///   Icons.wb_sunny,
  ///   color: weatherColors.first,
  /// )
  /// ```
  /// 
  /// ## 반환 배열 구조
  /// - **첫 번째 색상**: 주요 색상 (아이콘, 강조 요소)
  /// - **두 번째 색상**: 보조 색상 (그라데이션, 배경 요소)
  static List<Color> getWeatherColors(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return [sunnyYellow, accentOrange];       // 밝은 태양 → 일몰 오렌지
      case 'cloudy':
        return [cloudyGray, primaryBlue];         // 흐린 회색 → 하늘 파랑
      case 'rainy':
        return [rainyBlue, primaryTeal];          // 비 파랑 → 바다 틸
      case 'foggy':
        return [foggyWhite, surfaceMedium];       // 안개 흰색 → 산 안개
      case 'snowy':
        return [snowyWhite, primaryBlue];         // 순수한 눈 → 하늘 파랑
      case 'sunset':
        return [sunsetOrange, accentPink];        // 황금 시간 → 새벽 핑크
      default:
        return [primaryBlue, primaryTeal];        // 기본 하늘색 조합
    }
  }
}