/// 날씨 정보 표시 위젯
/// 
/// 이 파일은 SkyMesh 앱의 메인 날씨 정보 UI를 담당하는 복합 위젯입니다.
/// 현재 날씨, 시간별 예보, 주간 예보를 아름다운 카드 형태로 표시하며,
/// 로딩, 오류 상태 관리와 부드러운 애니메이션을 제공합니다.
/// 
/// ## 주요 기능
/// - **현재 날씨**: 온도, 날씨 설명, 체감온도 표시
/// - **상세 정보**: 풍속, 습도, 기압, 가시거리, 대기질, UV지수
/// - **시간별 예보**: 24시간 수평 스크롤 예보
/// - **주간 예보**: 7일간 날씨 트렌드
/// - **상태 관리**: 로딩, 오류, 성공 상태별 UI
/// - **애니메이션**: 페이드 인/아웃과 트랜지션 효과
/// 
/// ## UI 구조
/// ```
/// WeatherDisplayWidget
/// ├── TopSection (고정)
/// │   ├── 위치 정보
/// │   ├── 현재 시간
/// │   └── 메인 온도
/// ├── ScrollableContent
/// │   ├── WeatherDetailsCards (6개)
/// │   ├── HourlyWeatherSection
/// │   └── WeeklyWeatherSection
/// └── RefreshButton (우상단 고정)
/// ```
/// 
/// ## 디자인 특징
/// - **로우폴리 스타일**: 반투명 카드와 부드러운 그라데이션
/// - **반응형 레이아웃**: 다양한 화면 크기 지원
/// - **직관적 네비게이션**: 수직/수평 스크롤 조합
/// - **시각적 피드백**: 햅틱 피드백과 애니메이션
/// 
/// @author krindale
/// @since 1.0.0

// Flutter 프레임워크 imports
import 'package:flutter/material.dart';        // Material Design 위젯
import 'package:flutter/services.dart';       // 햅틱 피드백 서비스

// 내부 모델 imports
import '../core/models/weather_data.dart';           // 현재 날씨 데이터 모델
import '../core/models/hourly_weather_data.dart';    // 시간별 날씨 예보 모델
import '../core/models/weekly_weather_data.dart';    // 주간 날씨 예보 모델
import 'weather_news_sheet.dart';                    // 날씨 뉴스 하단 시트

/// 날씨 정보를 표시하는 메인 위젯
/// 
/// 이 위젯은 SkyMesh 앱의 핵심 UI 컴포넌트로, 모든 날씨 관련 정보를
/// 시각적으로 매력적이고 사용하기 쉬운 형태로 표시합니다.
/// 
/// ## 상태 관리
/// - **로딩 상태**: 데이터 조회 중 로딩 인디케이터 표시
/// - **오류 상태**: 네트워크 오류 시 재시도 옵션 제공
/// - **성공 상태**: 완전한 날씨 정보 UI 표시
/// 
/// ## 데이터 의존성
/// - WeatherData: 현재 날씨 (필수)
/// - HourlyWeatherData: 시간별 예보 (선택적)
/// - WeeklyWeatherData: 주간 예보 (선택적)
/// 
/// ## 콜백 함수
/// - onRefresh: 날씨 데이터 새로고침 요청
/// - scrollController: 스크롤 위치 제어 (외부에서 관리)
/// 
/// ## 사용 예시
/// ```dart
/// WeatherDisplayWidget(
///   weatherData: currentWeather,
///   hourlyWeatherData: hourlyForecast,
///   weeklyWeatherData: weeklyForecast,
///   isLoading: false,
///   error: null,
///   onRefresh: () => loadWeatherData(),
///   scrollController: scrollController,
/// )
/// ```
class WeatherDisplayWidget extends StatefulWidget {
  /// 현재 날씨 정보 (null일 경우 데이터 없음 상태)
  final WeatherData? weatherData;
  
  /// 24시간 시간별 날씨 예보 (null일 경우 해당 섹션 숨김)
  final HourlyWeatherData? hourlyWeatherData;
  
  /// 7일간 주간 날씨 예보 (null일 경우 해당 섹션 숨김)
  final WeeklyWeatherData? weeklyWeatherData;
  
  /// 날씨 데이터 로딩 상태 (true일 경우 로딩 UI 표시)
  final bool isLoading;
  
  /// 오류 메시지 (null이 아닐 경우 오류 UI 표시)
  final String? error;
  
  /// 새로고침 버튼 클릭 시 호출되는 콜백 함수
  final VoidCallback onRefresh;
  
  /// 스크롤 위치 제어를 위한 컨트롤러 (외부에서 주입)
  final ScrollController? scrollController;

  /// WeatherDisplayWidget 생성자
  /// 
  /// @param weatherData 현재 날씨 정보 (선택적)
  /// @param hourlyWeatherData 시간별 예보 정보 (선택적)
  /// @param weeklyWeatherData 주간 예보 정보 (선택적)
  /// @param isLoading 로딩 상태 (필수)
  /// @param error 오류 메시지 (선택적)
  /// @param onRefresh 새로고침 콜백 (필수)
  /// @param scrollController 스크롤 컨트롤러 (선택적)
  const WeatherDisplayWidget({
    super.key,
    this.weatherData,
    this.hourlyWeatherData,
    this.weeklyWeatherData,
    required this.isLoading,
    this.error,
    required this.onRefresh,
    this.scrollController,
  });

  @override
  State<WeatherDisplayWidget> createState() => _WeatherDisplayWidgetState();
}

class _WeatherDisplayWidgetState extends State<WeatherDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  /// 위젯 상태 초기화 메서드
  /// 
  /// 위젯이 위젯 트리에 삽입될 때 한 번 호출되며,
  /// 애니메이션 컨트롤러와 관련 설정을 초기화합니다.
  /// 
  /// ## 초기화 작업
  /// - **AnimationController 생성**: 500ms 페이드 애니메이션 설정
  /// - **Animation 설정**: 0.0에서 1.0으로 부드러운 전환
  /// - **초기 상태 확인**: 데이터가 있으면 즉시 애니메이션 시작
  /// 
  /// ## 애니메이션 특성
  /// - **Duration**: 500ms (사용자가 인지할 수 있는 적절한 속도)
  /// - **Curve**: easeInOut (자연스러운 가속/감속)
  /// - **Range**: 0.0 (완전 투명) ~ 1.0 (완전 불투명)
  @override
  void initState() {
    super.initState();
    
    // === 애니메이션 컨트롤러 설정 ===
    
    /// 페이드 인/아웃 애니메이션 컨트롤러 생성
    /// 500ms의 적절한 애니메이션 지속시간 설정
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),  // 부드러운 전환을 위한 최적 시간
      vsync: this,  // TickerProviderStateMixin에서 제공하는 vsync
    );
    
    /// 0.0(투명)에서 1.0(불투명)까지의 부드러운 애니메이션 정의
    /// easeInOut 커브로 자연스러운 가속/감속 효과
    _fadeAnimation = Tween<double>(
      begin: 0.0,   // 시작: 완전 투명
      end: 1.0,     // 끝: 완전 불투명
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,  // 자연스러운 애니메이션 커브
    ));
    
    // === 초기 상태 처리 ===
    
    /// 초기 데이터가 있고 로딩 중이 아니면 즉시 애니메이션 시작
    /// 이미 로드된 캐시 데이터가 있는 경우를 대비
    if (widget.weatherData != null && !widget.isLoading) {
      _fadeController.forward();  // 페이드 인 애니메이션 시작
    }
  }

  /// 위젯 업데이트 감지 및 애니메이션 제어 메서드
  /// 
  /// 부모로부터 새로운 props가 전달될 때 호출되며,
  /// 로딩 상태 변화에 따른 적절한 애니메이션을 실행합니다.
  /// 
  /// @param oldWidget 이전 상태의 위젯 인스턴스
  /// 
  /// ## 감지하는 변화
  /// - **로딩 상태 변화**: isLoading 속성 변경 감지
  /// - **데이터 상태 변화**: weatherData 존재 여부 확인
  /// 
  /// ## 애니메이션 로직
  /// - **로딩 시작**: 기존 UI를 부드럽게 페이드 아웃
  /// - **로딩 완료**: 새 데이터와 함께 페이드 인
  /// - **데이터 없음**: 애니메이션 없이 빈 상태 유지
  /// 
  /// ## 사용자 경험 개선
  /// - 갑작스러운 UI 변화 방지
  /// - 로딩과 데이터 표시 간 부드러운 전환
  /// - 시각적 연속성 제공
  @override
  void didUpdateWidget(WeatherDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // === 로딩 상태 변화 감지 및 애니메이션 제어 ===
    
    /// 이전 위젯과 현재 위젯의 로딩 상태 비교
    /// 상태가 변경된 경우에만 애니메이션 실행 (성능 최적화)
    if (oldWidget.isLoading != widget.isLoading) {
      
      if (widget.isLoading) {
        /// 로딩 시작: 기존 컨텐츠를 부드럽게 숨김
        /// 사용자에게 새 데이터 로딩 중임을 시각적으로 표현
        _fadeController.reverse();  // 1.0 → 0.0 (페이드 아웃)
        
      } else if (widget.weatherData != null) {
        /// 로딩 완료 + 유효한 데이터: 새 컨텐츠를 부드럽게 표시
        /// 데이터가 있는 경우에만 페이드 인 실행
        _fadeController.forward();  // 0.0 → 1.0 (페이드 인)
      }
      
      // 로딩 완료했지만 데이터가 null인 경우:
      // 애니메이션 없이 빈 상태(SizedBox.shrink) 표시
    }
  }

  /// 위젯 리소스 정리 메서드
  /// 
  /// 위젯이 위젯 트리에서 영구적으로 제거될 때 호출되며,
  /// 메모리 누수 방지를 위해 모든 리소스를 정리합니다.
  /// 
  /// ## 정리 대상
  /// - **AnimationController**: 애니메이션 컨트롤러와 관련 리스너
  /// - **Animation**: fade 애니메이션 객체
  /// 
  /// ## 중요성
  /// - 메모리 누수 방지
  /// - 불필요한 애니메이션 중단
  /// - 앱 성능 최적화
  /// 
  /// ## 호출 시점
  /// - 화면 전환 시
  /// - 앱 종료 시
  /// - 위젯이 조건부로 제거될 때
  @override
  void dispose() {
    /// AnimationController 정리
    /// 애니메이션 컨트롤러와 관련된 모든 리소스 해제
    /// 이는 메모리 누수 방지를 위해 필수적임
    _fadeController.dispose();
    
    /// 부모 클래스의 dispose 호출
    /// State 클래스의 기본 정리 작업 수행
    super.dispose();
  }

  /// 위젯의 UI를 구성하는 메인 빌드 메서드
  /// 
  /// 현재 상태에 따라 적절한 UI를 반환합니다. 상태별로 다른 위젯을 렌더링하여
  /// 일관된 사용자 경험을 제공합니다.
  /// 
  /// @param context BuildContext for accessing theme and media queries
  /// @return Widget 현재 상태에 맞는 UI 위젯
  /// 
  /// ## 상태별 UI 분기
  /// 1. **로딩 상태**: 로딩 인디케이터와 메시지 표시
  /// 2. **오류 상태**: 오류 메시지와 재시도 버튼 표시
  /// 3. **데이터 없음**: 빈 공간 (SizedBox.shrink)
  /// 4. **정상 상태**: 완전한 날씨 UI 표시
  /// 
  /// ## UI 구조 (정상 상태)
  /// ```
  /// AnimatedBuilder (페이드 애니메이션)
  /// └── Opacity + Transform (부드러운 전환)
  ///     └── SizedBox (전체 화면)
  ///         └── Stack (레이어 구조)
  ///             ├── Column (메인 콘텐츠)
  ///             │   ├── TopSection (고정)
  ///             │   └── Expanded (스크롤 영역)
  ///             │       └── SingleChildScrollView
  ///             │           ├── WeatherDetailsCards
  ///             │           ├── HourlyWeatherSection
  ///             │           └── WeeklyWeatherSection
  ///             └── Positioned (새로고침 버튼)
  /// ```
  /// 
  /// ## 애니메이션 효과
  /// - **Opacity**: 투명도 변화로 페이드 인/아웃
  /// - **Transform**: Y축 20px 이동으로 부드러운 등장
  /// - **Duration**: 500ms easeInOut 커브
  @override
  Widget build(BuildContext context) {
    
    // === 1단계: 상태별 UI 분기 처리 ===
    
    /// 로딩 상태: 로딩 인디케이터와 메시지 표시
    if (widget.isLoading) {
      return _buildLoadingState();
    }
    
    /// 오류 상태: 오류 메시지와 재시도 버튼 표시
    if (widget.error != null) {
      return _buildErrorState();
    }
    
    /// 데이터 없음 상태: 빈 공간 (화면에 아무것도 표시하지 않음)
    if (widget.weatherData == null) {
      return const SizedBox.shrink();
    }

    // === 2단계: 정상 상태 UI 구성 (애니메이션 포함) ===
    
    /// AnimatedBuilder를 사용한 부드러운 페이드 애니메이션
    /// _fadeAnimation 값 변화에 따라 자동으로 리빌드됨
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          /// 투명도 애니메이션: 0.0(투명) ~ 1.0(불투명)
          opacity: _fadeAnimation.value,
          
          child: Transform.translate(
            /// Y축 이동 애니메이션: 20px 아래에서 원래 위치로 부드럽게 이동
            /// 애니메이션 값이 0일 때 20px 아래, 1일 때 원래 위치
            offset: Offset(0, (1 - _fadeAnimation.value) * 20),
            
            child: SizedBox(
              /// 전체 화면 크기로 설정
              width: double.infinity,
              height: double.infinity,
              
              child: Stack(
                children: [
                  
                  // === 메인 콘텐츠 영역 ===
                  
                  /// 상단 고정 + 하단 스크롤 구조의 메인 콘텐츠
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // === 상단 고정 섹션 ===
                      
                      /// 위치, 시간, 메인 온도를 표시하는 고정 영역
                      /// 스크롤해도 항상 상단에 고정되어 표시됨
                      _buildTopSection(context),
                      
                      const SizedBox(height: 20),  // 고정 섹션과 스크롤 영역 간격
                      
                      // === 스크롤 가능한 하단 영역 ===
                      
                      /// 상세 정보, 예보 등을 포함하는 스크롤 가능한 영역
                      Expanded(
                        child: SingleChildScrollView(
                          controller: widget.scrollController,  // 외부에서 스크롤 제어 가능
                          physics: const BouncingScrollPhysics(),  // iOS 스타일 바운싱 효과
                          
                          child: Column(
                            children: [
                              
                              // === 날씨 상세 정보 카드들 ===
                              
                              /// 풍속, 습도, 기압, 가시거리, 대기질, UV지수 카드들
                              /// 2×3 그리드 레이아웃으로 구성
                              _buildWeatherDetailsCards(context),
                              
                              const SizedBox(height: 20),
                              
                              // === 시간별 날씨 예보 섹션 ===
                              
                              /// 24시간 시간별 예보 (조건부 렌더링)
                              /// 데이터가 있을 때만 표시
                              if (widget.hourlyWeatherData != null)
                                _buildHourlyWeatherSection(context),
                              
                              const SizedBox(height: 20),
                              
                              // === 주간 날씨 예보 섹션 ===
                              
                              /// 7일간 주간 예보 (조건부 렌더링)
                              /// 데이터가 있을 때만 표시
                              if (widget.weeklyWeatherData != null)
                                _buildWeeklyWeatherSection(context),
                              
                              /// 하단 여백: FloatingActionButton 공간 확보
                              /// FAB와 겹치지 않도록 충분한 여백 제공
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // === 액션 버튼들 (플로팅) ===
                  
                  /// 우상단에 고정된 액션 버튼들
                  /// 새로고침 버튼과 뉴스 버튼을 포함
                  Positioned(
                    top: 16,     // 상단에서 16px
                    right: 16,   // 우측에서 16px
                    child: _buildActionButtons(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 로딩 상태 UI 구성 메서드
  /// 
  /// 날씨 데이터를 불러오는 동안 표시되는 로딩 인디케이터와 메시지를 구성합니다.
  /// 중앙 정렬된 세로 레이아웃으로 직관적인 로딩 상태를 표현합니다.
  /// 
  /// @return Widget 로딩 상태를 나타내는 UI
  /// 
  /// ## UI 구성 요소
  /// - **CircularProgressIndicator**: 원형 로딩 스피너
  /// - **Loading Text**: 사용자에게 상황을 알리는 메시지
  /// 
  /// ## 디자인 특징
  /// - **중앙 정렬**: 화면 중앙에 배치하여 시선 집중
  /// - **흰색 테마**: 배경 이미지와의 대비를 위한 흰색 사용
  /// - **적절한 간격**: 스피너와 텍스트 간 16px 간격
  /// 
  /// ## 접근성 고려사항
  /// - 로딩 상태임을 명확히 알리는 텍스트 제공
  /// - 적절한 폰트 크기와 대비로 가독성 확보
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        /// 세로 중앙 정렬: 화면 중앙에 로딩 UI 배치
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          /// 원형 로딩 인디케이터
          /// 흰색으로 설정하여 다양한 배경색에서 시인성 확보
          CircularProgressIndicator(color: Colors.white),
          
          /// 로딩 스피너와 텍스트 간 간격
          SizedBox(height: 16),
          
          /// 로딩 상태를 알리는 텍스트
          /// 명확하고 간결한 메시지로 사용자에게 현재 상황 전달
          Text(
            'Loading weather...',
            style: TextStyle(
              color: Colors.white,              // 배경과 대비되는 흰색
              fontSize: 16,                    // 적절한 가독성을 위한 크기
              fontWeight: FontWeight.w500,     // 약간 굵은 폰트로 강조
            ),
          ),
        ],
      ),
    );
  }

  /// 오류 상태 UI 구성 메서드
  /// 
  /// 날씨 데이터 로딩 실패 시 표시되는 오류 메시지와 재시도 옵션을 구성합니다.
  /// 사용자 친화적인 오류 처리로 좋은 사용자 경험을 제공합니다.
  /// 
  /// @return Widget 오류 상태를 나타내는 UI
  /// 
  /// ## UI 구성 요소
  /// - **Error Icon**: 오류 상황을 시각적으로 표현하는 아이콘
  /// - **Error Title**: 간단명료한 오류 제목
  /// - **Error Message**: 구체적인 오류 내용 (동적)
  /// - **Retry Button**: 재시도를 위한 액션 버튼
  /// 
  /// ## 디자인 특징
  /// - **Semi-transparent Card**: 배경과 조화로운 반투명 카드
  /// - **Orange Warning Color**: 주의를 끄는 오렌지 아이콘
  /// - **Rounded Corners**: 16px 둥근 모서리로 현대적 느낌
  /// - **Glassmorphism**: 유리 같은 투명 효과
  /// 
  /// ## 사용자 경험
  /// - 명확한 오류 상황 전달
  /// - 즉시 재시도 가능한 버튼 제공
  /// - 구체적인 오류 메시지로 문제 파악 도움
  Widget _buildErrorState() {
    return Center(
      child: Container(
        /// 화면 가장자리에서 충분한 마진 확보
        margin: const EdgeInsets.all(32),
        
        /// 내부 콘텐츠를 위한 패딩
        padding: const EdgeInsets.all(24),
        
        /// Glassmorphism 스타일의 카드 디자인
        decoration: BoxDecoration(
          /// 반투명 검은 배경으로 가독성 확보
          color: Colors.black.withOpacity(0.7),
          
          /// 현대적인 느낌의 둥근 모서리
          borderRadius: BorderRadius.circular(16),
          
          /// 미세한 테두리로 카드 경계 표현
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        
        child: Column(
          /// 콘텐츠 크기에 맞게 최소 크기로 설정
          mainAxisSize: MainAxisSize.min,
          children: [
            
            /// 오류를 나타내는 경고 아이콘
            /// 오렌지색으로 주의를 끌면서도 너무 자극적이지 않게
            const Icon(
              Icons.error_outline,      // 외곽선 스타일의 부드러운 오류 아이콘
              color: Colors.orange,     // 경고를 나타내는 오렌지색
              size: 48,                 // 충분히 큰 크기로 시각적 임팩트
            ),
            
            const SizedBox(height: 16),
            
            /// 간단명료한 오류 제목
            /// 사용자가 즉시 상황을 파악할 수 있도록
            const Text(
              'Unable to load weather',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,                // 제목에 적합한 크기
                fontWeight: FontWeight.w600, // 굵은 폰트로 강조
              ),
            ),
            
            const SizedBox(height: 8),
            
            /// 구체적인 오류 메시지 표시
            /// widget.error가 null이면 기본 메시지 사용
            Text(
              widget.error ?? 'Unknown error occurred',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),  // 약간 투명한 흰색
                fontSize: 14,                          // 상세 설명에 적합한 작은 크기
              ),
              textAlign: TextAlign.center,  // 중앙 정렬로 균형잡힌 레이아웃
            ),
            
            const SizedBox(height: 16),
            
            /// 재시도 버튼
            /// 사용자가 즉시 문제 해결을 시도할 수 있도록
            ElevatedButton(
              onPressed: widget.onRefresh,  // 부모에서 전달받은 새로고침 콜백
              
              /// 반투명 스타일의 버튼 디자인
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),  // 반투명 배경
                foregroundColor: Colors.white,                   // 흰색 텍스트
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),       // 둥근 모서리
                ),
              ),
              
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 고정 섹션 UI 구성 메서드
  /// 
  /// 위치 정보, 현재 시간, 메인 온도를 표시하는 고정 영역을 구성합니다.
  /// 이 영역은 스크롤해도 항상 화면 상단에 고정되어 표시됩니다.
  /// 
  /// @param context BuildContext for accessing theme and media queries
  /// @return Widget 상단 섹션 UI
  /// 
  /// ## UI 구성 요소
  /// - **위치 정보**: 도시명 + 국가코드 (예: Seoul, KR)
  /// - **현재 시간**: HH:mm 형식의 현재 시간
  /// - **메인 온도**: 대형 폰트의 현재 온도
  /// - **날씨 설명**: 현재 날씨 상태 설명
  /// - **체감 온도**: "Feels like" 정보
  /// 
  /// ## 레이아웃 구조
  /// ```
  /// Container (패딩 + 배경)
  /// └── Column (세로 정렬)
  ///     ├── 위치 정보 Text
  ///     ├── 현재 시간 Text
  ///     └── Row (가로 정렬)
  ///         ├── 메인 온도 Text (96px)
  ///         └── Expanded
  ///             └── Column
  ///                 ├── 날씨 설명
  ///                 └── 체감 온도
  /// ```
  /// 
  /// ## 타이포그래피 특징
  /// - **96px 메인 온도**: 가장 중요한 정보를 강조
  /// - **계층적 크기**: 중요도에 따른 폰트 크기 차등
  /// - **연한 폰트**: Ultra-light 온도로 우아한 느낌
  Widget _buildTopSection(BuildContext context) {
    return Container(
      /// 상단 영역의 패딩 설정
      /// 상단 50px로 스테이터스 바 영역 피하기
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      
      child: Column(
        /// 좌측 정렬로 일관된 레이아웃
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // === 위치 정보 ===
          
          /// 도시명과 국가코드 표시
          /// 예: "Seoul, KR", "New York, US"
          Text(
            '${widget.weatherData!.cityName}, ${widget.weatherData!.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,                    // 위치 정보에 적합한 중간 크기
              fontWeight: FontWeight.w500,     // 약간 굵은 폰트로 가독성 향상
            ),
          ),
          
          const SizedBox(height: 8),
          
          // === 현재 시간 ===
          
          /// HH:mm 형식의 현재 시간 표시
          /// 사용자가 언제 데이터를 확인하는지 알 수 있도록
          Text(
            _getCurrentTime(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),  // 날씨 정보보다 덜 강조
              fontSize: 16,                          // 보조 정보에 적합한 크기
              fontWeight: FontWeight.w400,           // 일반 폰트 가중치
            ),
          ),
          
          const SizedBox(height: 32),  // 시간과 온도 사이 충분한 간격
          
          // === 메인 온도 및 날씨 정보 ===
          
          /// 온도와 날씨 설명을 가로로 배치한 레이아웃
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,  // 상단 정렬로 깔끔한 레이아웃
            children: [
              
              /// 메인 온도 - 가장 중요한 정보
              /// 96px로 대형 표시하여 시각적 임팩트 극대화
              Text(
                widget.weatherData!.temperatureString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 96,                    // 대형 폰트로 주요 정보 강조
                  fontWeight: FontWeight.w200,     // Ultra-light 가중치로 우아한 느낌
                  height: 1.0,                     // 라인 높이 최소화로 컴팩트한 레이아웃
                ),
              ),
              
              const SizedBox(width: 16),  // 온도와 설명 사이 간격
              
              /// 날씨 설명 및 체감 온도 영역
              /// Expanded로 남은 공간을 유연하게 활용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    /// 온도와 정렬을 맞추기 위한 마진
                    const SizedBox(height: 16),
                    
                    /// 날씨 상태 설명
                    /// capitalizedDescription으로 첫 글자 대문자 처리
                    Text(
                      widget.weatherData!.capitalizedDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,                    // 중요한 다음 정보로 적절한 크기
                        fontWeight: FontWeight.w500,     // 약간 굵은 폰트로 가독성 향상
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    /// 체감 온도 정보
                    /// 실제 온도와 체감 온도의 차이를 사용자에게 알려줌
                    Text(
                      'Feels like ${widget.weatherData!.feelsLikeString}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),  // 보조 정보로 약간 투명
                        fontSize: 18,                          // 체감 온도를 위한 적절한 크기
                        fontWeight: FontWeight.w400,           // 일반 가중치
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // First row of cards
          Row(
            children: [
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.air,
                  title: 'WIND',
                  number: widget.weatherData!.windSpeedNumber,
                  unit: widget.weatherData!.windSpeedUnit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.water_drop_outlined,
                  title: 'HUMIDITY',
                  number: widget.weatherData!.humidityNumber,
                  unit: widget.weatherData!.humidityUnit,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Second row of cards
          Row(
            children: [
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.speed,
                  title: 'PRESSURE',
                  number: widget.weatherData!.pressureNumber,
                  unit: widget.weatherData!.pressureUnit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherCardWithUnit(
                  icon: Icons.visibility,
                  title: 'VISIBILITY',
                  number: widget.weatherData!.visibilityNumber,
                  unit: widget.weatherData!.visibilityUnit,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Third row - Air Quality and UV Index side by side
          Row(
            children: [
              Expanded(
                child: _buildAirQualityCard(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUVIndexCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCardWithUnit({
    required IconData icon,
    required String title,
    required String number,
    required String unit,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    bool isFullWidth = false,
  }) {
    return Container(
      height: isFullWidth ? 115 : 120,
      padding: EdgeInsets.all(isFullWidth ? 10 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          SizedBox(height: isFullWidth ? 8 : 12),
          
          Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          if (subtitle != null) ...[
            SizedBox(height: isFullWidth ? 2 : 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isFullWidth ? 12 : 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 액션 버튼들을 구성합니다 (새로고침 + 뉴스)
  /// 
  /// 우상단에 고정된 원형 액션 버튼들을 수직으로 배치합니다.
  /// 햡틱 피드백과 함께 사용자 친화적인 인터랙션을 제공합니다.
  /// 
  /// @param context BuildContext for accessing theme and media queries
  /// @return Widget 액션 버튼들 UI
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 뉴스 버튼
        _buildNewsButton(context),
        
        const SizedBox(height: 12),
        
        // 새로고침 버튼
        _buildRefreshButton(context),
      ],
    );
  }

  /// 뉴스 버튼 UI 구성 메서드
  /// 
  /// 날씨 뉴스 하단 시트를 열기 위한 원형 뉴스 버튼을 구성합니다.
  /// 
  /// @param context BuildContext for accessing theme and media queries
  /// @return Widget 뉴스 버튼 UI
  Widget _buildNewsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// 햅틱 피드백 제공
        HapticFeedback.lightImpact();
        
        /// 날씨 뉴스 하단 시트 열기
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black54,
          builder: (context) => WeatherNewsSheet(
            weatherData: widget.weatherData,
          ),
        );
      },
      
      child: Container(
        /// 대화형 버튼 크기 (44x44px)
        width: 44,
        height: 44,
        
        /// Glassmorphism 스타일의 원형 버튼 디자인
        decoration: BoxDecoration(
          /// 반투명 검은 배경으로 유리 같은 효과
          color: Colors.black.withOpacity(0.3),
          
          /// 원형 모양
          shape: BoxShape.circle,
          
          /// 미세한 테두리
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        
        /// 뉴스 아이콘
        child: Icon(
          Icons.article_outlined,                  // Material Design 뉴스 아이콘
          color: Colors.white.withOpacity(0.8),    // 고대비를 위한 흰색
          size: 22,                                // 버튼 크기에 적합한 아이콘 크기
        ),
      ),
    );
  }

  /// 새로고침 버튼 UI 구성 메서드
  /// 
  /// 원형 새로고침 버튼을 구성합니다.
  /// 
  /// @param context BuildContext for accessing theme and media queries
  /// @return Widget 새로고침 버튼 UI
  Widget _buildRefreshButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// 햅틱 피드백 제공
        HapticFeedback.lightImpact();
        
        /// 부모에서 전달받은 새로고침 콜백 함수 호출
        widget.onRefresh();
      },
      
      child: Container(
        /// 대화형 버튼 크기 (44x44px)
        width: 44,
        height: 44,
        
        /// Glassmorphism 스타일의 원형 버튼 디자인
        decoration: BoxDecoration(
          /// 반투명 검은 배경으로 유리 같은 효과
          color: Colors.black.withOpacity(0.3),
          
          /// 원형 모양
          shape: BoxShape.circle,
          
          /// 미세한 테두리
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        
        /// 새로고침 아이콘
        child: Icon(
          Icons.refresh,                           // Material Design 새로고침 아이콘
          color: Colors.white.withOpacity(0.8),    // 고대비를 위한 흰색
          size: 22,                                // 버튼 크기에 적합한 아이콘 크기
        ),
      ),
    );
  }

  /// 현재 시간을 HH:mm 형식으로 반환하는 유틸리티 메서드
  /// 
  /// DateTime.now()를 사용하여 현재 시간을 가져오고,
  /// 24시간 형식으로 포맷팅하여 반환합니다.
  /// 
  /// @return String HH:mm 형식의 현재 시간 (예: "14:30", "09:05")
  /// 
  /// ## 포맷팅 특징
  /// - **24시간 형식**: 00:00 ~ 23:59 사이의 시간
  /// - **제로 패딩**: 한 자리 숫자 앞에 0 추가 (예: 9 → 09)
  /// - **콜론 구분자**: 시와 분을 :로 분리
  /// 
  /// ## 사용 예시
  /// ```dart
  /// final timeString = _getCurrentTime();
  /// // 결과: "14:30" (2:30 PM)
  /// // 결과: "09:05" (9:05 AM)
  /// ```
  /// 
  /// ## 타임존 고려사항
  /// - 디바이스의 로컬 타임존 사용
  /// - 날짜 변경선과 서머타임 자동 반영
  /// - 실시간 업데이트로 정확한 시간 정보 제공
  String _getCurrentTime() {
    /// 현재 시간 가져오기
    /// DateTime.now()는 디바이스의 로컬 시간을 반환
    final now = DateTime.now();
    
    /// 시간 포맷팅: 한 자리 숫자의 경우 앞에 0 추가
    /// padLeft(2, '0'): 2자리로 맞추고, 빈 공간은 '0'으로 채우기
    final hour = now.hour.toString().padLeft(2, '0');      // 9 → "09", 14 → "14"
    final minute = now.minute.toString().padLeft(2, '0');  // 5 → "05", 30 → "30"
    
    /// HH:mm 형식으로 결합하여 반환
    /// 콜론(:)을 구분자로 사용하여 시간과 분 분리
    return '$hour:$minute';
  }

  Widget _buildHourlyWeatherSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'HOURLY FORECAST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.hourlyWeatherData!.hourlyForecasts.length,
              itemBuilder: (context, index) {
                final forecast = widget.hourlyWeatherData!.hourlyForecasts[index];
                return _buildHourlyWeatherCard(forecast, index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyWeatherCard(HourlyWeatherForecast forecast, bool isFirst) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 12, left: isFirst ? 0 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isFirst ? 'Now' : forecast.hour,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWeatherIcon(forecast.iconCode),
              color: Colors.white.withOpacity(0.9),
              size: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            forecast.temperatureString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${forecast.humidity}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01': return Icons.wb_sunny;
      case '02': return Icons.wb_sunny_outlined;
      case '03':
      case '04': return Icons.cloud;
      case '09':
      case '10': return Icons.grain;
      case '11': return Icons.flash_on;
      case '13': return Icons.ac_unit;
      case '50': return Icons.foggy;
      default: return Icons.wb_sunny;
    }
  }

  Widget _buildWeeklyWeatherSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '7-DAY FORECAST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.weeklyWeatherData!.dailyForecasts
                .map((forecast) => _buildDailyWeatherRow(forecast))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyWeatherRow(DailyWeatherForecast forecast) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // 요일
          SizedBox(
            width: 40,
            child: Text(
              forecast.isToday ? '오늘' : forecast.dayOfWeek,
              style: TextStyle(
                color: forecast.isToday ? Colors.white : Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: forecast.isToday ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날짜
          SizedBox(
            width: 40,
            child: Text(
              forecast.dateString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날씨 아이콘
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getWeatherIcon(forecast.iconCode),
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 날씨 설명 (축약된 버전)
          Expanded(
            child: Text(
              _getShortWeatherDescription(forecast.description),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 최저 온도
          SizedBox(
            width: 35,
            child: Text(
              forecast.minTemperatureString,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // 최고 온도
          SizedBox(
            width: 35,
            child: Text(
              forecast.maxTemperatureString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getShortWeatherDescription(String description) {
    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('clear')) return '맑음';
    if (lowerDesc.contains('few clouds')) return '약간 흐림';
    if (lowerDesc.contains('scattered') || lowerDesc.contains('broken')) return '흐림';
    if (lowerDesc.contains('overcast')) return '덮음';
    if (lowerDesc.contains('rain')) return '비';
    if (lowerDesc.contains('snow')) return '눈';
    if (lowerDesc.contains('mist') || lowerDesc.contains('fog')) return '안개';
    if (lowerDesc.contains('thunderstorm')) return '뇌우';
    return '흐림';
  }

  Widget _buildAirQualityCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.air,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AIR QUALITY',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Air Quality number and unit only
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.weatherData!.airQualityString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AQI',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUVIndexCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'UV INDEX',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // UV Index number and description in same row
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // UV Index number on the left
                Text(
                  widget.weatherData!.uvIndexString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Description on the right
                Text(
                  _getUVIndexDescription(widget.weatherData!.uvIndex),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// UV 지수에 따른 위험도 설명 반환 메서드
  /// 
  /// WHO(World Health Organization) 기준에 따라 UV 지수를 비교적으로
  /// 이해하기 쉬운 텍스트로 변환합니다.
  /// 
  /// @param uvIndex UV 지수 값 (0-11+ 범위)
  /// @return String UV 지수 위험도 설명
  /// 
  /// ## UV 지수 단계별 설명
  /// - **0-2 (Low)**: 낮음 - 보호 조치 불필요
  /// - **3-5 (Moderate)**: 보통 - 모자, 선글라스 권장
  /// - **6-7 (High)**: 높음 - 자외선 차단제 필수
  /// - **8-10 (Very High)**: 매우 높음 - 외출 자제 권장
  /// - **11+ (Extreme)**: 극도로 높음 - 외출 금지 권장
  /// 
  /// ## 건강 영향
  /// - 피부암 위험도와 직결
  /// - 사용자의 야외 활동 계획에 도움
  /// - 적절한 보호 조치 안내
  String _getUVIndexDescription(int uvIndex) {
    // WHO 기준 UV 지수 단계별 분류
    if (uvIndex <= 2) return 'Low';         // 0-2: 낮음
    if (uvIndex <= 5) return 'Moderate';    // 3-5: 보통
    if (uvIndex <= 7) return 'High';        // 6-7: 높음
    if (uvIndex <= 10) return 'Very High';  // 8-10: 매우 높음
    return 'Extreme';                       // 11+: 극도로 높음
  }

  /// 대기질 지수에 따른 대기 상태 설명 반환 메서드
  /// 
  /// OpenWeatherMap API의 Air Quality Index 기준에 따라
  /// 대기질 수치를 사용자가 이해하기 쉬운 텍스트로 변환합니다.
  /// 
  /// @param airQuality 대기질 지수 (1-5 범위)
  /// @return String 대기질 상태 설명
  /// 
  /// ## 대기질 단계별 설명
  /// - **1 (Good)**: 좋음 - 모든 사람에게 안전
  /// - **2 (Fair)**: 보통 - 민감한 사람에게 약간 영향
  /// - **3 (Moderate)**: 보통 - 민감한 사람에게 영향
  /// - **4 (Poor)**: 나쁨 - 일반인에게 영향, 민감한 사람에게 심각한 영향
  /// - **5 (Very Poor)**: 매우 나쁨 - 모든 사람에게 심각한 영향
  /// 
  /// ## 건강 영향
  /// - 호흡기 질환 위험
  /// - 야외 활동 제한 여부 결정
  /// - 마스크 착용 필요성 판단
  String _getAirQualityDescription(int airQuality) {
    // OpenWeatherMap API 대기질 지수 기준
    switch (airQuality) {
      case 1: return 'Good';       // 좋음
      case 2: return 'Fair';       // 보통 (낮음)
      case 3: return 'Moderate';   // 보통
      case 4: return 'Poor';       // 나쁨
      case 5: return 'Very Poor';  // 매우 나쁨
      default: return 'Unknown';   // 알 수 없음 (오류 상황)
    }
  }
}