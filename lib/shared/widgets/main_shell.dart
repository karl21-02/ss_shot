import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    HapticFeedback.selectionClick();

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 8,
            fontSize: 20,
          ),
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: _buildOpaqueBottomBar(context),
    );
  }

  Widget _buildOpaqueBottomBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      // SafeArea를 고려한 높이 설정
      height: 70 + bottomPadding,
      decoration: BoxDecoration(
        // 테마 기반 배경색
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        // 상단 경계선 추가로 영역 구분 명확화
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 0, Icons.grid_view_rounded, AppStrings.navHome),
            _buildNavItem(context, 1, Icons.search_rounded, AppStrings.navSearch),
            _buildNavItem(context, 2, Icons.auto_fix_high_rounded, AppStrings.navClean),
            _buildNavItem(context, 3, Icons.settings_rounded, AppStrings.navSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => _onTap(context, index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}