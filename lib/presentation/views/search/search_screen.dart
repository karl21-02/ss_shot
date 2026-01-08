import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/logger.dart';
import '../../view_models/home_view_model.dart';
import '../../widgets/screenshot_grid_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    Log.d('🔍 [Search] 화면 진입');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      Log.d('🔍 [Search] 검색 실행 | query: $query');
      ref.read(homeViewModelProvider.notifier).search(query);
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.sublist(0, 10);
        }
      });
    }
    ref.read(homeViewModelProvider.notifier).search(query);
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _onSearchSubmitted(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(homeViewModelProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final hasQuery = _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            border: InputBorder.none,
            suffixIcon: hasQuery
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
          textInputAction: TextInputAction.search,
        ),
      ),
      body: hasQuery ? _buildSearchResults(state) : _buildRecentSearches(),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '스크린샷 내 텍스트를 검색해보세요',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.searchRecent,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: const Text('전체 삭제'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final query = _recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() {
                      _recentSearches.removeAt(index);
                    });
                  },
                ),
                onTap: () => _onRecentSearchTap(query),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(HomeState state) {
    final displayCount = state.filteredItemCount;

    if (state.status == HomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (displayCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.searchEmpty,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '"${state.searchQuery}" 검색 결과: $displayCount개',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
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
                  onTap: () => context.push('/detail/${item.id}'),
                );
              }
              final item = state.filteredScreenshots[index];
              return ScreenshotGridItem(
                asset: item,
                onTap: () => context.push('/detail/${item.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
