import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../../core/constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ConvexAppBar(
        // 현재 선택된 인덱스를 연결해줘요
        initialActiveIndex: navigationShell.currentIndex,
        // 탭을 눌렀을 때 go_router의 브랜치를 이동시켜요
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        // 기존 destinations 내용을 TabItem으로 옮겨왔어유
        items: [
          TabItem(
            icon: Icons.home,
            title: AppStrings.navHome,
          ),
          TabItem(
            icon: Icons.search,
            title: AppStrings.navSearch,
          ),
          TabItem(
            icon: Icons.auto_fix_high,
            title: AppStrings.navClean,
          ),
          TabItem(
            icon: Icons.settings,
            title: AppStrings.navSettings,
          ),
        ],
        // 스타일이나 색상을 여기서 더 만질 수 있어유
        backgroundColor: Colors.white,
        activeColor: Colors.blue,
        color: Colors.grey,
      ),
    );
  }
}
