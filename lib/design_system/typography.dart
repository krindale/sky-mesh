/// SkyMesh 로우폴리 타이포그래피 시스템
/// 
/// 이 파일은 SkyMesh 앱의 모든 텍스트 스타일을 정의하는 종합적인 타이포그래피 시스템입니다.
/// 로우폴리 아트의 기하학적 미학을 보완하면서도 모든 크기에서 뛰어난 가독성을 유지합니다.
/// 
/// ## 디자인 철학
/// 
/// ### 1. 기하학적 명확성 (Geometric Clarity)
/// - 로우폴리의 각진 형태와 조화를 이루는 깔끔한 폰트 선택
/// - 명확한 문자 형태로 UI의 기하학적 요소와 시각적 일관성 유지
/// - 불필요한 장식 요소 제거로 핵심 메시지에 집중
/// 
/// ### 2. 계층적 구조 (Hierarchical Structure)
/// - Display → Headline → Title → Body → Label 순의 명확한 시각적 계층
/// - 각 레벨별 적절한 크기, 굵기, 간격 설정으로 정보 우선순위 표현
/// - 사용자의 시선 흐름을 고려한 타이포그래피 가이드
/// 
/// ### 3. 가독성 최적화 (Readability Optimization)
/// - 모든 기기와 화면 크기에서 최적의 가독성 보장
/// - WCAG 2.1 접근성 기준을 충족하는 명도 대비와 크기
/// - 다양한 언어와 문자 체계를 고려한 유니버설 디자인
/// 
/// ## 폰트 선택 기준
/// 
/// ### Primary Font: Inter
/// - **특징**: 현대적이고 기하학적인 산세리프 폰트
/// - **장점**: 높은 가독성, 다국어 지원, 웹/모바일 최적화
/// - **사용처**: 본문, 제목, 인터페이스 요소의 주요 텍스트
/// 
/// ### Display Font: Poppins
/// - **특징**: 둥글고 친근한 기하학적 폰트
/// - **장점**: 강한 시각적 임팩트, 브랜딩에 적합
/// - **사용처**: 대형 헤드라인, 로고, 주요 디스플레이 텍스트
/// 
/// ### Monospace Font: Roboto Mono
/// - **특징**: 고정폭 글꼴로 일정한 문자 간격
/// - **장점**: 숫자 정렬, 코드 표시, 정확한 레이아웃
/// - **사용처**: 시간 표시, 온도 수치, 좌표 정보
/// 
/// ## 타이포그래피 스케일
/// 
/// **베이스 크기**: 16px (모바일 최적화된 기준 크기)
/// **스케일 비율**: 1.2 (Minor Third) - 자연스럽고 조화로운 크기 비율
/// **행간**: 텍스트 종류별 최적화된 행간으로 가독성 극대화
/// 
/// ## 접근성 고려사항
/// 
/// - **명도 대비**: 모든 텍스트 스타일이 WCAG 2.1 AA 기준 준수
/// - **크기 조절**: 시스템 폰트 크기 설정에 반응하는 상대적 크기
/// - **색각 장애**: 색상뿐만 아니라 굵기와 크기로도 정보 전달
/// 
/// ## 사용 예시
/// 
/// ```dart
/// // 기본 텍스트 스타일 사용
/// Text(
///   '날씨 정보',
///   style: LowPolyTypography.headlineMedium,
/// )
/// 
/// // 색상 변경
/// Text(
///   '온도: 25°C',
///   style: LowPolyTypography.withColor(
///     LowPolyTypography.bodyLarge,
///     LowPolyColors.primaryBlue,
///   ),
/// )
/// 
/// // 테마 적용
/// MaterialApp(
///   theme: ThemeData(
///     textTheme: LowPolyTypography.lightTextTheme,
///   ),
/// )
/// ```
/// 
/// @author krindale
/// @since 1.0.0

import 'package:flutter/material.dart';
import 'colors.dart';

/// 로우폴리 디자인 시스템 타이포그래피 클래스
/// 
/// SkyMesh 앱의 모든 텍스트 스타일을 중앙 관리하는 정적 클래스입니다.
/// Material Design 3의 타이포그래피 스케일을 기반으로 하되,
/// 로우폴리 아트의 기하학적 미학에 맞게 최적화되었습니다.
/// 
/// ## 스타일 카테고리
/// - **Display**: 대형 헤드라인과 히어로 콘텐츠
/// - **Headline**: 페이지/섹션 제목
/// - **Title**: 카드/컴포넌트 제목
/// - **Body**: 본문 텍스트
/// - **Label**: 버튼, 탭, 라벨
/// - **Special**: 날씨 앱 특화 스타일
class LowPolyTypography {
  // ====================================================================
  // 폰트 패밀리 (Font Families) - 앱에서 사용하는 폰트 정의
  // ====================================================================
  
  /// 주요 폰트 - Inter
  /// 현대적이고 가독성이 뛰어난 산세리프 폰트
  /// 사용처: 본문, 제목, 인터페이스 요소의 대부분 텍스트
  static const String primaryFont = 'Inter';
  
  /// 디스플레이 폰트 - Poppins
  /// 둥글고 친근한 느낌의 기하학적 폰트
  /// 사용처: 대형 헤드라인, 브랜딩, 특별한 강조 텍스트
  static const String displayFont = 'Poppins';
  
  /// 고정폭 폰트 - Roboto Mono
  /// 모든 문자가 동일한 폭을 가지는 폰트
  /// 사용처: 시간, 온도, 좌표 등 정확한 정렬이 필요한 수치
  static const String monospaceFont = 'Roboto Mono';
  
  // ====================================================================
  // 폰트 굵기 (Font Weights) - 시각적 계층 구조를 위한 굵기 단계
  // ====================================================================
  
  /// 얇은 굵기 - 300
  /// 사용처: 부가 정보, 캡션, 연한 강조
  static const FontWeight light = FontWeight.w300;
  
  /// 일반 굵기 - 400 (기본값)
  /// 사용처: 본문 텍스트, 일반적인 정보 전달
  static const FontWeight regular = FontWeight.w400;
  
  /// 중간 굵기 - 500
  /// 사용처: 버튼 텍스트, 라벨, 중요한 정보
  static const FontWeight medium = FontWeight.w500;
  
  /// 준굵은 굵기 - 600
  /// 사용처: 소제목, 카드 제목, 강조가 필요한 텍스트
  static const FontWeight semiBold = FontWeight.w600;
  
  /// 굵은 굵기 - 700
  /// 사용처: 주요 제목, 강한 강조, 브랜딩 요소
  static const FontWeight bold = FontWeight.w700;
  
  /// 매우 굵은 굵기 - 800
  /// 사용처: 대형 디스플레이 텍스트, 최고 수준의 강조
  static const FontWeight extraBold = FontWeight.w800;
  
  // ====================================================================
  // 기본 폰트 크기 설정 (Base Font Configuration)
  // ====================================================================
  
  /// 기준 폰트 크기 - 16px
  /// 모바일 환경에서 최적의 가독성을 제공하는 기준 크기
  static const double _baseSize = 16.0;
  
  /// 크기 비율 - 1.2 (Minor Third)
  /// 자연스럽고 조화로운 크기 비율로 시각적 계층 구조 생성
  static const double _scaleRatio = 1.2;
  
  // ====================================================================
  // 디스플레이 텍스트 스타일 (Display Text Styles) - 대형 헤드라인과 히어로 콘텐츠
  // 가장 큰 텍스트로 강력한 시각적 임팩트와 브랜딩 효과 제공
  // ====================================================================
  
  /// 디스플레이 라지 - 가장 큰 디스플레이 텍스트 (57px)
  /// 사용처: 스플래시 화면, 메인 브랜딩, 랜딩 페이지 히어로 텍스트
  /// 특징: 매우 굵은 굵기(800)와 음수 자간으로 강력한 임팩트 연출
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,        // Poppins - 브랜딩에 적합한 친근한 폰트
    fontSize: 57.0,                 // 57px - Material 3 디스플레이 라지 기준
    fontWeight: extraBold,          // 800 - 최고 수준의 시각적 강조
    height: 1.1,                    // 110% 행간 - 압축적이고 임팩트 있는 레이아웃
    letterSpacing: -0.5,            // -0.5px - 큰 글자의 시각적 밀도 향상
    color: LowPolyColors.textPrimary, // 기본 텍스트 색상
  );
  
  /// 디스플레이 미디움 - 중간 크기 디스플레이 텍스트 (45px)
  /// 사용처: 페이지 메인 제목, 중요한 섹션 헤더, 카드 타이틀
  /// 특징: 굵은 굵기(700)로 강조하되 디스플레이 라지보다 덜 압도적
  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,        // Poppins - 일관된 브랜딩 폰트
    fontSize: 45.0,                 // 45px - Material 3 디스플레이 미디움 기준
    fontWeight: bold,               // 700 - 강한 시각적 강조
    height: 1.15,                   // 115% 행간 - 적당한 숨구멍 제공
    letterSpacing: -0.25,           // -0.25px - 자연스러운 문자 간격
    color: LowPolyColors.textPrimary, // 기본 텍스트 색상
  );
  
  /// 디스플레이 스몰 - 작은 디스플레이 텍스트 (36px)
  /// 사용처: 서브 헤드라인, 카테고리 제목, 강조 인용구
  /// 특징: 굵은 굵기(700)와 중성적 자간으로 안정감 있는 강조
  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,        // Poppins - 브랜딩 일관성 유지
    fontSize: 36.0,                 // 36px - Material 3 디스플레이 스몰 기준
    fontWeight: bold,               // 700 - 적당한 강조 효과
    height: 1.2,                    // 120% 행간 - 편안한 가독성
    letterSpacing: 0,               // 0px - 자연스러운 기본 간격
    color: LowPolyColors.textPrimary, // 기본 텍스트 색상
  );
  
  // Headline Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28.0,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  // Title Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.15,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
    color: LowPolyColors.textPrimary,
  );
  
  // Label Text Styles - For buttons, tabs, etc.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.5,
    color: LowPolyColors.textSecondary,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.25,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.4,
    color: LowPolyColors.textSecondary,
  );
  
  // Special Text Styles
  static const TextStyle monospace = TextStyle(
    fontFamily: monospaceFont,
    fontSize: 14.0,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  // Location/Time specific styles
  static const TextStyle locationName = TextStyle(
    fontFamily: displayFont,
    fontSize: 24.0,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle timeDisplay = TextStyle(
    fontFamily: monospaceFont,
    fontSize: 32.0,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.5,
    color: LowPolyColors.textPrimary,
  );
  
  static const TextStyle weatherLabel = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12.0,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 1.0,
    color: LowPolyColors.textSecondary,
  );
  
  // Text Theme for Material Design
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );
  
  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: displayFont,
      fontSize: 57.0,
      fontWeight: extraBold,
      height: 1.1,
      letterSpacing: -0.5,
      color: LowPolyColors.textOnDark,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFont,
      fontSize: 45.0,
      fontWeight: bold,
      height: 1.15,
      letterSpacing: -0.25,
      color: LowPolyColors.textOnDark,
    ),
    displaySmall: TextStyle(
      fontFamily: displayFont,
      fontSize: 36.0,
      fontWeight: bold,
      height: 1.2,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 32.0,
      fontWeight: semiBold,
      height: 1.25,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 28.0,
      fontWeight: semiBold,
      height: 1.3,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 24.0,
      fontWeight: medium,
      height: 1.3,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    titleLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 22.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    titleMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 20.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.15,
      color: LowPolyColors.textOnDark,
    ),
    titleSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 18.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.1,
      color: LowPolyColors.textOnDark,
    ),
    labelLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 16.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.1,
      color: LowPolyColors.textOnDark,
    ),
    labelMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 14.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.5,
      color: LowPolyColors.textOnDark,
    ),
    labelSmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 12.0,
      fontWeight: medium,
      height: 1.4,
      letterSpacing: 0.5,
      color: LowPolyColors.textOnDark,
    ),
    bodyLarge: TextStyle(
      fontFamily: primaryFont,
      fontSize: 18.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0,
      color: LowPolyColors.textOnDark,
    ),
    bodyMedium: TextStyle(
      fontFamily: primaryFont,
      fontSize: 16.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0.25,
      color: LowPolyColors.textOnDark,
    ),
    bodySmall: TextStyle(
      fontFamily: primaryFont,
      fontSize: 14.0,
      fontWeight: regular,
      height: 1.5,
      letterSpacing: 0.4,
      color: LowPolyColors.textOnDark,
    ),
  );
  
  // Utility methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}