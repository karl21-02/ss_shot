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
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          titleTextStyle: const TextStyle(
            color: AppColors.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.onPrimary,
          ),
          actionsIconTheme: const IconThemeData(
            color: AppColors.onPrimary,
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
