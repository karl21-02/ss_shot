import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../data/datasources/local/app_database.dart';
import '../view_model/home_view_model.dart';
import '../widgets/category_chips.dart';
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

  void _onCategorySelected(ScreenshotCategory category) {
    Log.d('📱 [Home] 카테고리 선택 | ${category.name}');
    ref.read(homeViewModelProvider.notifier).filterByCategory(category);
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
          // Category Filter Chips
          CategoryChips(
            selectedCategory: state.selectedCategory,
            onCategorySelected: _onCategorySelected,
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
