import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/views/clean/clean_mode_screen.dart';
import '../../presentation/views/detail/detail_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/main_shell.dart';
import '../../presentation/views/search/search_screen.dart';
import '../../presentation/views/settings/settings_screen.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String clean = '/clean';
  static const String settings = '/settings';
  static const String detail = '/detail/:id';

  static String detailPath(String id) => '/detail/$id';
}

// Navigation keys for shell
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    // Shell route with bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Search Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // Clean Mode Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.clean,
              builder: (context, state) => const CleanModeScreen(),
            ),
          ],
        ),

        // Settings Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Detail route (outside shell - fullscreen)
    GoRoute(
      path: AppRoutes.detail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return DetailScreen(screenshotId: id);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Page not found: ${state.uri}'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('홈으로'),
          ),
        ],
      ),
    ),
  ),
);
