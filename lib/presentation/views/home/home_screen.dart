import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/categories.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/logger.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../view_models/home_view_model.dart';
import '../../widgets/screenshot_grid_item.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.isMockMode
              ? '${AppStrings.homeTitle} (Mock)'
              : AppStrings.homeTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(homeViewModelProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          _buildCategoryChips(state),

          // Content
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(HomeState state) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryInfo = categories[index];
          final isSelected = state.selectedCategory == categoryInfo.category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(categoryInfo.label),
              selected: isSelected,
              onSelected: (_) => _onCategorySelected(categoryInfo.category),
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    switch (state.status) {
      case HomeStatus.initial:
      case HomeStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(AppStrings.homeLoading),
            ],
          ),
        );

      case HomeStatus.permissionDenied:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              const Text(AppStrings.permissionDenied),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  PhotoManager.openSetting();
                },
                icon: const Icon(Icons.settings),
                label: const Text(AppStrings.permissionRequestButton),
              ),
            ],
          ),
        );

      case HomeStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(state.errorMessage ?? AppStrings.errorGeneric),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.read(homeViewModelProvider.notifier).refresh();
                },
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        );

      case HomeStatus.loaded:
        final displayCount = state.filteredItemCount;

        if (displayCount == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  state.searchQuery.isNotEmpty
                      ? '검색 결과가 없습니다'
                      : AppStrings.homeEmpty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
          child: Column(
            children: [
              // Result count info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '$displayCount개의 스크린샷',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    if (state.searchQuery.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('"${state.searchQuery}"'),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          ref.read(homeViewModelProvider.notifier).clearSearch();
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
              ),

              // Screenshot Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: displayCount,
                  itemBuilder: (context, index) {
                    if (state.isMockMode) {
                      final item = state.filteredMockScreenshots[index];
                      return ScreenshotGridItem(
                        mockScreenshot: item,
                        onTap: () => context.push(AppRoutes.detailPath(item.id)),
                      );
                    }
                    final item = state.filteredScreenshots[index];
                    return ScreenshotGridItem(
                      asset: item,
                      onTap: () => context.push(AppRoutes.detailPath(item.id)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
    }
  }
}
