import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../data/datasources/local/app_database.dart';
import '../view_model/home_view_model.dart';
import '../widgets/category_chips.dart'; // StatusChips
import '../widgets/home_content.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Log.d('📱 [Home] 화면 진입');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).initialize();
    });
  }

  void _onStatusSelected(ScreenshotStatus? status) {
    Log.d('📱 [Home] 상태 선택 | ${status?.name ?? "전체"}');
    ref.read(homeViewModelProvider.notifier).filterByStatus(status);
  }

  void _onRefresh() {
    ref.read(homeViewModelProvider.notifier).refresh();
  }

  void _onClearSearch() {
    ref.read(homeViewModelProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          // Status Filter Chips
          StatusChips(
            selectedStatus: state.selectedStatus,
            onStatusSelected: _onStatusSelected,
          ),

          // Content
          Expanded(
            child: HomeContent(
              state: state,
              onRefresh: _onRefresh,
              onClearSearch: _onClearSearch,
            ),
          ),
        ],
      ),
    );
  }
}
