import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/utils/logger.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/models/mock_screenshot.dart';
import '../../../services/gallery_service.dart';

// Mock 모드 설정 (개발 중 true로 설정)
const bool kUseMockData = true;

// GalleryService Provider
final galleryServiceProvider = Provider<GalleryService>((ref) {
  return GalleryService();
});

// Home State
enum HomeStatus { initial, loading, loaded, permissionDenied, error }

class HomeState {
  final HomeStatus status;
  final List<AssetEntity> screenshots;
  final List<MockScreenshot> mockScreenshots;
  final String? errorMessage;
  final bool hasPermission;
  final bool isMockMode;
  final ScreenshotCategory selectedCategory;
  final String searchQuery;

  const HomeState({
    this.status = HomeStatus.initial,
    this.screenshots = const [],
    this.mockScreenshots = const [],
    this.errorMessage,
    this.hasPermission = false,
    this.isMockMode = kUseMockData,
    this.selectedCategory = ScreenshotCategory.all,
    this.searchQuery = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<AssetEntity>? screenshots,
    List<MockScreenshot>? mockScreenshots,
    String? errorMessage,
    bool? hasPermission,
    bool? isMockMode,
    ScreenshotCategory? selectedCategory,
    String? searchQuery,
  }) {
    return HomeState(
      status: status ?? this.status,
      screenshots: screenshots ?? this.screenshots,
      mockScreenshots: mockScreenshots ?? this.mockScreenshots,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPermission: hasPermission ?? this.hasPermission,
      isMockMode: isMockMode ?? this.isMockMode,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get itemCount => isMockMode ? mockScreenshots.length : screenshots.length;

  // 필터링된 결과
  List<MockScreenshot> get filteredMockScreenshots {
    var result = mockScreenshots;

    // 카테고리 필터 (Mock에서는 적용 안함 - 실제 데이터에서만)
    // 검색 필터 (Mock에서는 id로 간단히)
    if (searchQuery.isNotEmpty) {
      result = result
          .where((s) => s.id.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return result;
  }

  List<AssetEntity> get filteredScreenshots {
    // 실제 구현에서는 DB에서 필터링된 결과를 가져옴
    return screenshots;
  }

  int get filteredItemCount =>
      isMockMode ? filteredMockScreenshots.length : filteredScreenshots.length;
}

// Home ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  final GalleryService _galleryService;

  HomeViewModel(this._galleryService) : super(const HomeState()) {
    Log.d('📱 [Home] HomeViewModel 생성 | mockMode: ${state.isMockMode}');
  }

  Future<void> initialize() async {
    Log.i('📱 [Home] 초기화 시작');
    state = state.copyWith(status: HomeStatus.loading);

    if (state.isMockMode) {
      await _loadMockData();
      return;
    }

    final hasPermission = await _galleryService.requestPermission();

    if (!hasPermission) {
      Log.w('⚠️ [Home] 갤러리 권한 없음');
      state = state.copyWith(
        status: HomeStatus.permissionDenied,
        hasPermission: false,
      );
      return;
    }

    state = state.copyWith(hasPermission: true);
    await loadScreenshots();
  }

  Future<void> _loadMockData() async {
    Log.i('🧪 [Home] Mock 데이터 로드 시작');

    await Future.delayed(const Duration(milliseconds: 500));

    final mockData = MockScreenshot.generateMockData(count: 20);

    state = state.copyWith(
      status: HomeStatus.loaded,
      mockScreenshots: mockData,
      hasPermission: true,
    );

    Log.i('✅ [Home] Mock 데이터 로드 완료 | count: ${mockData.length}');
  }

  Future<void> loadScreenshots() async {
    if (state.isMockMode) {
      await _loadMockData();
      return;
    }

    try {
      state = state.copyWith(status: HomeStatus.loading);

      final screenshots = await _galleryService.loadScreenshots();

      state = state.copyWith(
        status: HomeStatus.loaded,
        screenshots: screenshots,
      );

      Log.i('✅ [Home] 스크린샷 로드 완료 | count: ${screenshots.length}');
    } catch (e, s) {
      Log.e('❌ [Home] 스크린샷 로드 실패', e, s);
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    Log.i('🔄 [Home] 새로고침');
    if (state.isMockMode) {
      await _loadMockData();
    } else {
      await loadScreenshots();
    }
  }

  void filterByCategory(ScreenshotCategory category) {
    Log.i('🏷️ [Home] 카테고리 필터 | ${category.name}');
    state = state.copyWith(selectedCategory: category);
    // 실제 구현에서는 DB에서 필터링된 결과를 다시 로드
  }

  void search(String query) {
    Log.i('🔍 [Home] 검색 | query: $query');
    state = state.copyWith(searchQuery: query);
    // 실제 구현에서는 DB에서 검색 결과를 로드
  }

  void clearSearch() {
    Log.d('🔍 [Home] 검색 초기화');
    state = state.copyWith(searchQuery: '');
  }
}

// HomeViewModel Provider
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final galleryService = ref.watch(galleryServiceProvider);
  return HomeViewModel(galleryService);
});
