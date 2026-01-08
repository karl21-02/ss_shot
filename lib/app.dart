import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';

class SShotApp extends StatelessWidget {
  const SShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
