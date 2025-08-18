/// SkyMesh 로우폴리 디자인 시스템
/// 
/// 이 파일은 SkyMesh 앱의 전체적인 시각적 일관성을 제공하는 종합적인 디자인 시스템입니다.
/// 로우폴리 아트의 기하학적이고 면 분할된 미학에서 영감을 받아 제작되었으며,
/// 대기적인 색상 팔레트와 각진 레이아웃으로 앱 전체에 일관된 시각 언어를 제공합니다.
/// 
/// ## 디자인 원칙
/// 
/// 1. **기하학적 조화**: 로우폴리 미학을 반영하는 깔끔하고 각진 형태
/// 2. **대기적 색상**: 다양한 날씨 조건에서 영감을 받은 색상 팔레트
/// 3. **면 분할 그림자**: 깊이와 차원을 만드는 다방향 그림자
/// 4. **타이포그래피 명확성**: 기하학적 디자인을 보완하는 깔끔하고 읽기 쉬운 폰트
/// 5. **일관된 간격**: 8px 그리드를 기반으로 한 수학적 간격 시스템
/// 
/// ## 사용법
/// 
/// ```dart
/// import 'package:sky_mesh/design_system/design_system.dart';
/// 
/// // MaterialApp에서 테마 사용
/// MaterialApp(
///   theme: LowPolyTheme.lightTheme,
///   darkTheme: LowPolyTheme.darkTheme,
///   // ...
/// )
/// 
/// // 색상 사용
/// Container(
///   color: LowPolyColors.primaryBlue,
///   // ...
/// )
/// 
/// // 타이포그래피 사용
/// Text(
///   'Hello World',
///   style: LowPolyTypography.headlineLarge,
/// )
/// 
/// // 간격 사용
/// Padding(
///   padding: EdgeInsets.all(LowPolySpacing.md),
///   // ...
/// )
/// 
/// // 컴포넌트 스타일 사용
/// Container(
///   decoration: LowPolyComponents.primaryCard,
///   // ...
/// )
/// ```
/// 
/// ## 디자인 시스템 구성 요소
/// 
/// ### 핵심 디자인 토큰
/// - **colors.dart**: 로우폴리 스타일 색상 팔레트 (날씨별 테마 색상 포함)
/// - **typography.dart**: 기하학적 미학을 보완하는 타이포그래피 스타일
/// - **spacing.dart**: 8px 기반 수학적 간격 시스템
/// - **shadows.dart**: 면 분할 효과를 위한 다층 그림자 스타일
/// 
/// ### 컴포넌트 및 테마
/// - **components.dart**: 재사용 가능한 UI 컴포넌트 스타일
/// - **theme.dart**: 라이트/다크 테마 설정 및 통합 테마 구성
/// 
/// ## 로우폴리 미학적 특징
/// 
/// - **각진 형태**: 부드러운 곡선 대신 명확한 각도와 직선 사용
/// - **면 분할**: 복잡한 형태를 단순한 다각형 면으로 분해
/// - **기하학적 패턴**: 삼각형, 사각형 등 기본 도형의 조합
/// - **대조적 색상**: 날씨 조건을 반영한 명확한 색상 구분
/// - **최소주의**: 불필요한 장식 요소 제거, 핵심 기능에 집중

library design_system;

// Core design tokens
export 'colors.dart';
export 'typography.dart';
export 'spacing.dart';
export 'shadows.dart';

// Component styles and themes
export 'components.dart';
export 'theme.dart';