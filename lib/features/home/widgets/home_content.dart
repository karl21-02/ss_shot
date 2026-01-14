import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/screenshot_grid_item.dart';
import '../view_model/home_view_model.dart';

class HomeContent extends StatelessWidget {
  final HomeState state;
  final VoidCallback onRefresh;
  final VoidCallback onClearSearch;

  const HomeContent({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case HomeStatus.initial:
      case HomeStatus.loading:
        return const _LoadingView();

      case HomeStatus.permissionDenied:
        return const _PermissionDeniedView();

      case HomeStatus.error:
        return _ErrorView(
          errorMessage: state.errorMessage,
          onRetry: onRefresh,
        );

      case HomeStatus.loaded:
        return _LoadedView(
          state: state,
          onRefresh: onRefresh,
          onClearSearch: onClearSearch,
        );
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
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
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView();

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => PhotoManager.openSetting(),
            icon: const Icon(Icons.settings),
            label: const Text(AppStrings.permissionRequestButton),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(errorMessage ?? AppStrings.errorGeneric),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final HomeState state;
  final VoidCallback onRefresh;
  final VoidCallback onClearSearch;

  const _LoadedView({
    required this.state,
    required this.onRefresh,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = state.filteredItemCount;

    if (displayCount == 0) {
      return _EmptyView(hasSearchQuery: state.searchQuery.isNotEmpty);
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: Column(
        children: [
          // Result count info
          _ResultHeader(
            displayCount: displayCount,
            searchQuery: state.searchQuery,
            onClearSearch: onClearSearch,
          ),

          // Screenshot Grid
          Expanded(
            child: _ScreenshotGrid(state: state),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool hasSearchQuery;

  const _EmptyView({required this.hasSearchQuery});

  @override
  Widget build(BuildContext context) {
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
            hasSearchQuery ? '검색 결과가 없습니다' : AppStrings.homeEmpty,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final int displayCount;
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _ResultHeader({
    required this.displayCount,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$displayCount개의 스크린샷',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(width: 8),
            Chip(
              label: Text('"$searchQuery"'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: onClearSearch,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}

class _ScreenshotGrid extends StatelessWidget {
  final HomeState state;

  const _ScreenshotGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final displayCount = state.filteredItemCount;

    return GridView.builder(
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
    );
  }
}
