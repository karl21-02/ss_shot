import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/logger.dart';
import '../../../data/models/mock_screenshot.dart';
import '../../../services/smart_action_service.dart';
import '../../view_models/home_view_model.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String screenshotId;

  const DetailScreen({
    super.key,
    required this.screenshotId,
  });

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final SmartActionService _smartActionService = SmartActionService();
  List<DetectedAction> _detectedActions = [];
  MockScreenshot? _screenshot;

  @override
  void initState() {
    super.initState();
    Log.d('🖼️ [Detail] 화면 진입 | id: ${widget.screenshotId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScreenshot();
    });
  }

  void _loadScreenshot() {
    final state = ref.read(homeViewModelProvider);

    // Mock 모드에서 스크린샷 찾기
    if (state.isMockMode) {
      try {
        _screenshot = state.mockScreenshots.firstWhere(
          (s) => s.id == widget.screenshotId,
        );

        // Mock 데이터에서 스마트 액션 감지 (실제로는 OCR 텍스트 사용)
        final mockText = '''
          https://example.com/order/12345
          계좌: 110-123-456789
          배송 예정일: 2026-01-15
          문의: 010-1234-5678
          이메일: support@example.com
        ''';

        setState(() {
          _detectedActions = _smartActionService.detectActions(mockText);
        });

        Log.i('🖼️ [Detail] 스크린샷 로드 완료 | actions: ${_detectedActions.length}');
      } catch (e) {
        Log.w('⚠️ [Detail] 스크린샷 찾기 실패 | id: ${widget.screenshotId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screenshot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.detailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.detailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareScreenshot,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('삭제', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 이미지 뷰어
          Expanded(
            flex: 3,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: 'screenshot_${widget.screenshotId}',
                  child: Image.network(
                    _screenshot!.imageUrl,
                    fit: BoxFit.contain,
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
                  ),
                ),
              ),
            ),
          ),

          // 스마트 액션 바
          if (_detectedActions.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '스마트 액션',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: _detectedActions.length,
                      itemBuilder: (context, index) {
                        final action = _detectedActions[index];
                        return _buildActionCard(action);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCard(DetectedAction action) {
    IconData icon;
    Color color;
    String label;

    switch (action.type) {
      case SmartActionType.url:
        icon = Icons.language;
        color = Colors.blue;
        label = AppStrings.detailOpenUrl;
        break;
      case SmartActionType.accountNumber:
        icon = Icons.account_balance;
        color = Colors.green;
        label = AppStrings.detailCopyAccount;
        break;
      case SmartActionType.date:
        icon = Icons.calendar_today;
        color = Colors.orange;
        label = AppStrings.detailAddCalendar;
        break;
      case SmartActionType.phoneNumber:
        icon = Icons.phone;
        color = Colors.teal;
        label = '전화 걸기';
        break;
      case SmartActionType.email:
        icon = Icons.email;
        color = Colors.purple;
        label = '이메일 보내기';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () => _executeAction(action),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 18, color: color),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  action.displayText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _executeAction(DetectedAction action) async {
    Log.i('🎯 [Detail] 스마트 액션 실행 | type: ${action.type.name}');

    switch (action.type) {
      case SmartActionType.url:
        final success = await _smartActionService.openUrl(action.value);
        if (!success && mounted) {
          _showSnackBar('URL을 열 수 없습니다');
        }
        break;

      case SmartActionType.accountNumber:
        await _smartActionService.copyToClipboard(action.value);
        if (mounted) {
          _showSnackBar('${action.displayText} ${AppStrings.copied}');
        }
        break;

      case SmartActionType.date:
        // TODO: 캘린더 앱 연동
        if (mounted) {
          _showSnackBar('캘린더 등록 기능 준비 중');
        }
        break;

      case SmartActionType.phoneNumber:
        final success = await _smartActionService.makeCall(action.value);
        if (!success && mounted) {
          _showSnackBar('전화를 걸 수 없습니다');
        }
        break;

      case SmartActionType.email:
        final success = await _smartActionService.sendEmail(action.value);
        if (!success && mounted) {
          _showSnackBar('이메일을 보낼 수 없습니다');
        }
        break;
    }
  }

  void _shareScreenshot() {
    Log.i('📤 [Detail] 공유');
    Share.share('SS-Shot 스크린샷: ${_screenshot?.imageUrl}');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _showDeleteDialog();
        break;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('스크린샷 삭제'),
        content: const Text('이 스크린샷을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _showSnackBar('스크린샷이 삭제되었습니다');
            },
            child: const Text(AppStrings.detailDelete),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
