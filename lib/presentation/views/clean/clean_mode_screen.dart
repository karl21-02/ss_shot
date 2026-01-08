import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/logger.dart';
import '../../../data/models/mock_screenshot.dart';
import '../../view_models/home_view_model.dart';

/// 스크린샷 유용성 점수 (높을수록 중요)
enum UsefulnessLevel {
  high(3, '중요'),      // 금융, 일정 등
  medium(2, '보통'),    // 쇼핑, 기타
  low(1, '낮음'),       // 유머, 밈
  trash(0, '쓸모없음'); // 오래된 것, 중복, 텍스트 없음

  final int score;
  final String label;
  const UsefulnessLevel(this.score, this.label);
}

/// Mock 스크린샷 + 유용성 점수
class ScoredScreenshot {
  final MockScreenshot screenshot;
  final UsefulnessLevel usefulness;
  final String reason;

  const ScoredScreenshot({
    required this.screenshot,
    required this.usefulness,
    required this.reason,
  });
}

class CleanModeScreen extends ConsumerStatefulWidget {
  const CleanModeScreen({super.key});

  @override
  ConsumerState<CleanModeScreen> createState() => _CleanModeScreenState();
}

class _CleanModeScreenState extends ConsumerState<CleanModeScreen>
    with TickerProviderStateMixin {
  List<ScoredScreenshot> _allCards = [];
  List<ScoredScreenshot> _sortedCards = [];
  List<ScoredScreenshot> _trashCards = [];

  int _currentIndex = 0;
  int _deletedCount = 0;
  int _keptCount = 0;
  bool _isLoading = true;

  // Tab selection: 0 = 스와이프 정리, 1 = 쓸모없는 스샷
  int _selectedTab = 0;

  // Animation controllers
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _rotationAnimation;

  // Drag state
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    Log.d('🧹 [Clean] 정리 모드 진입');

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndScoreCards();
    });
  }

  /// 카드 로드 및 유용성 점수 계산
  void _loadAndScoreCards() {
    final state = ref.read(homeViewModelProvider);

    // Mock 데이터에 유용성 점수 부여
    _allCards = state.mockScreenshots.map((screenshot) {
      return _scoreScreenshot(screenshot);
    }).toList();

    // 쓸모없는 것 분리
    _trashCards = _allCards
        .where((s) => s.usefulness == UsefulnessLevel.trash)
        .toList();

    // 나머지는 유용성 높은 순으로 정렬 (중요한 것 먼저)
    _sortedCards = _allCards
        .where((s) => s.usefulness != UsefulnessLevel.trash)
        .toList()
      ..sort((a, b) => b.usefulness.score.compareTo(a.usefulness.score));

    setState(() {
      _isLoading = false;
      _currentIndex = 0;
    });

    Log.i('🧹 [Clean] 카드 로드 완료 | total: ${_allCards.length}, '
        'sorted: ${_sortedCards.length}, trash: ${_trashCards.length}');
  }

  /// 스크린샷 유용성 점수 계산
  ScoredScreenshot _scoreScreenshot(MockScreenshot screenshot) {
    // Mock 데이터에서는 ID 기반으로 임의 분류
    // 실제로는 OCR 텍스트, 카테고리, 날짜 등으로 판단

    final id = screenshot.id.toLowerCase();
    final index = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // 간단한 규칙 기반 분류 (실제로는 ML 또는 규칙 엔진 사용)
    if (index % 7 == 0) {
      return ScoredScreenshot(
        screenshot: screenshot,
        usefulness: UsefulnessLevel.trash,
        reason: '30일 이상 오래된 스크린샷',
      );
    } else if (index % 5 == 0) {
      return ScoredScreenshot(
        screenshot: screenshot,
        usefulness: UsefulnessLevel.trash,
        reason: '텍스트가 거의 없음',
      );
    } else if (index % 3 == 0) {
      return ScoredScreenshot(
        screenshot: screenshot,
        usefulness: UsefulnessLevel.high,
        reason: '금융 정보 포함',
      );
    } else if (index % 2 == 0) {
      return ScoredScreenshot(
        screenshot: screenshot,
        usefulness: UsefulnessLevel.medium,
        reason: '쇼핑/배송 정보',
      );
    } else {
      return ScoredScreenshot(
        screenshot: screenshot,
        usefulness: UsefulnessLevel.low,
        reason: '일반 스크린샷',
      );
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    // Drag started
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final swipeThreshold = screenWidth * 0.4;
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (_dragOffset.dx.abs() > swipeThreshold || velocity.abs() > 800) {
      final isSwipeRight = _dragOffset.dx > 0 || velocity > 0;
      _animateSwipe(isSwipeRight);
    } else {
      _resetCard();
    }
  }

  void _animateSwipe(bool isSwipeRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isSwipeRight ? screenWidth * 1.5 : -screenWidth * 1.5;
    final targetRotation = isSwipeRight ? 0.3 : -0.3;

    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(targetX, _dragOffset.dy),
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: _dragOffset.dx / 1000,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    _swipeController.forward().then((_) {
      _handleSwipeComplete(isSwipeRight);
    });

    HapticFeedback.mediumImpact();
  }

  void _handleSwipeComplete(bool isSwipeRight) {
    if (_currentIndex < _sortedCards.length) {
      final card = _sortedCards[_currentIndex];

      if (isSwipeRight) {
        Log.i('✅ [Clean] 보관 | id: ${card.screenshot.id}');
        _keptCount++;
      } else {
        Log.i('🗑️ [Clean] 삭제 | id: ${card.screenshot.id}');
        _deletedCount++;
      }
    }

    setState(() {
      _currentIndex++;
      _dragOffset = Offset.zero;
    });

    _swipeController.reset();
  }

  void _resetCard() {
    setState(() {
      _dragOffset = Offset.zero;
    });
  }

  double get _swipeProgress {
    final screenWidth = MediaQuery.of(context).size.width;
    return (_dragOffset.dx / screenWidth).clamp(-1.0, 1.0);
  }

  void _deleteAllTrash() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('쓸모없는 스크린샷 삭제'),
        content: Text('${_trashCards.length}개의 스크린샷을 모두 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _deletedCount += _trashCards.length;
                _trashCards.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('쓸모없는 스크린샷이 삭제되었습니다')),
              );
            },
            child: const Text('모두 삭제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.cleanTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cleanTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: _selectedTab == 0 ? _buildSwipeMode() : _buildTrashList(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              index: 0,
              icon: Icons.swipe,
              label: '스와이프 정리',
              count: _sortedCards.length - _currentIndex,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              index: 1,
              icon: Icons.delete_sweep,
              label: '쓸모없는 스샷',
              count: _trashCards.length,
              isWarning: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String label,
    required int count,
    bool isWarning = false,
  }) {
    final isSelected = _selectedTab == index;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isWarning && count > 0
                    ? Colors.red.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isWarning && count > 0 ? Colors.red : color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeMode() {
    final remaining = _sortedCards.length - _currentIndex;
    final isComplete = remaining <= 0;

    if (isComplete) {
      return _buildCompleteView();
    }

    return _buildCardStack();
  }

  Widget _buildTrashList() {
    if (_trashCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '쓸모없는 스크린샷이 없습니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header with delete all button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '자동으로 감지된 불필요한 스크린샷입니다',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: _deleteAllTrash,
                icon: const Icon(Icons.delete_sweep, size: 18),
                label: const Text('모두 삭제'),
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trashCards.length,
            itemBuilder: (context, index) {
              final card = _trashCards[index];
              return _buildTrashItem(card, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrashItem(ScoredScreenshot card, int index) {
    return Dismissible(
      key: Key(card.screenshot.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        setState(() {
          _trashCards.removeAt(index);
          _deletedCount++;
        });
        HapticFeedback.mediumImpact();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              card.screenshot.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),
          ),
          title: Text(
            card.screenshot.id,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  card.reason,
                  style: const TextStyle(fontSize: 11, color: Colors.red),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.restore),
            tooltip: '복원',
            onPressed: () {
              setState(() {
                _trashCards.removeAt(index);
                _sortedCards.add(card);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('복원되었습니다')),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.cleanComplete,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            '보관: $_keptCount개  /  삭제: $_deletedCount개',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 32),
          if (_trashCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _selectedTab = 1),
                icon: const Icon(Icons.delete_sweep),
                label: Text('쓸모없는 스샷 ${_trashCards.length}개 확인'),
              ),
            ),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _deletedCount = 0;
                _keptCount = 0;
              });
              _loadAndScoreCards();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('다시 정리하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    final currentCard = _sortedCards[_currentIndex];

    return Stack(
      children: [
        // Background cards (preview)
        if (_currentIndex + 1 < _sortedCards.length)
          Positioned.fill(
            child: Center(
              child: Transform.scale(
                scale: 0.95,
                child: _buildCard(_sortedCards[_currentIndex + 1], isBackground: true),
              ),
            ),
          ),

        // Usefulness badge
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getUsefulnessColor(currentCard.usefulness).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getUsefulnessColor(currentCard.usefulness),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getUsefulnessIcon(currentCard.usefulness),
                    size: 16,
                    color: _getUsefulnessColor(currentCard.usefulness),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${currentCard.usefulness.label}: ${currentCard.reason}',
                    style: TextStyle(
                      color: _getUsefulnessColor(currentCard.usefulness),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Swipe hint icons
        Positioned(
          left: 32,
          top: 60,
          bottom: 100,
          child: Center(
            child: AnimatedOpacity(
              opacity: _swipeProgress < -0.2 ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _swipeProgress < -0.2
                          ? Colors.red.withValues(alpha: 0.9)
                          : Colors.grey.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 32,
                      color: _swipeProgress < -0.2 ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.cleanSwipeLeft,
                    style: TextStyle(
                      color: _swipeProgress < -0.2 ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 32,
          top: 60,
          bottom: 100,
          child: Center(
            child: AnimatedOpacity(
              opacity: _swipeProgress > 0.2 ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _swipeProgress > 0.2
                          ? Colors.green.withValues(alpha: 0.9)
                          : Colors.grey.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      size: 32,
                      color: _swipeProgress > 0.2 ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.cleanSwipeRight,
                    style: TextStyle(
                      color: _swipeProgress > 0.2 ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main draggable card
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: AnimatedBuilder(
                  animation: _swipeController,
                  builder: (context, child) {
                    final offset = _swipeController.isAnimating
                        ? _swipeAnimation.value
                        : _dragOffset;
                    final rotation = _swipeController.isAnimating
                        ? _rotationAnimation.value
                        : _dragOffset.dx / 1000;

                    return Transform(
                      transform: Matrix4.identity()
                        ..setTranslationRaw(offset.dx, offset.dy, 0)
                        ..rotateZ(rotation),
                      alignment: Alignment.center,
                      child: _buildCard(currentCard, isBackground: false),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Action buttons at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.close,
                color: Colors.red,
                onTap: () => _animateSwipe(false),
                label: AppStrings.cleanSwipeLeft,
              ),
              _buildActionButton(
                icon: Icons.favorite,
                color: Colors.green,
                onTap: () => _animateSwipe(true),
                label: AppStrings.cleanSwipeRight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getUsefulnessColor(UsefulnessLevel level) {
    switch (level) {
      case UsefulnessLevel.high:
        return Colors.green;
      case UsefulnessLevel.medium:
        return Colors.blue;
      case UsefulnessLevel.low:
        return Colors.orange;
      case UsefulnessLevel.trash:
        return Colors.red;
    }
  }

  IconData _getUsefulnessIcon(UsefulnessLevel level) {
    switch (level) {
      case UsefulnessLevel.high:
        return Icons.star;
      case UsefulnessLevel.medium:
        return Icons.star_half;
      case UsefulnessLevel.low:
        return Icons.star_border;
      case UsefulnessLevel.trash:
        return Icons.delete_outline;
    }
  }

  Widget _buildCard(ScoredScreenshot scoredScreenshot, {required bool isBackground}) {
    final screenshot = scoredScreenshot.screenshot;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.85;
    final cardHeight = cardWidth * 1.2;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isBackground ? 0.1 : 0.2),
            blurRadius: isBackground ? 10 : 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              screenshot.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 64),
                );
              },
            ),

            // Gradient overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  screenshot.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Swipe overlay
            if (!isBackground && _swipeProgress.abs() > 0.1)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _swipeProgress > 0
                      ? Colors.green.withValues(alpha: _swipeProgress.abs() * 0.5)
                      : Colors.red.withValues(alpha: _swipeProgress.abs() * 0.5),
                ),
                child: Center(
                  child: Icon(
                    _swipeProgress > 0 ? Icons.favorite : Icons.delete,
                    size: 80,
                    color: Colors.white.withValues(alpha: _swipeProgress.abs()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color.withValues(alpha: 0.1),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              onTap();
            },
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Icon(icon, color: color, size: 32),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
