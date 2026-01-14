import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors - Pastel Green
  static const Color primary = Color(0xFF81C784);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFC8E6C9);

  // Secondary Colors
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceVariant = Color(0xFFE7E0EC);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textHint = Color(0xFF79747E);

  // Semantic Colors - 의미 기반 색상
  static const Color success = Color(0xFF4CAF50);       // 성공/보관
  static const Color error = Color(0xFFE53935);         // 에러/삭제
  static const Color warning = Color(0xFFFFA726);       // 경고
  static const Color info = Color(0xFF42A5F5);          // 정보

  // Smart Action Colors - 스마트 액션 타입별
  static const Color actionUrl = Color(0xFF42A5F5);     // URL - 파랑
  static const Color actionAccount = Color(0xFF66BB6A); // 계좌 - 초록
  static const Color actionDate = Color(0xFFFFA726);    // 날짜 - 주황
  static const Color actionPhone = Color(0xFF26A69A);   // 전화 - 틸
  static const Color actionEmail = Color(0xFFAB47BC);   // 이메일 - 보라

  // Usefulness Level Colors - 유용성 레벨
  static const Color usefulnessHigh = Color(0xFF4CAF50);   // 중요 - 초록
  static const Color usefulnessMedium = Color(0xFF42A5F5); // 보통 - 파랑
  static const Color usefulnessLow = Color(0xFFFFA726);    // 낮음 - 주황
  static const Color usefulnessTrash = Color(0xFFE53935);  // 쓸모없음 - 빨강

  // Neutral Colors - 중립 색상
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);

  // Other
  static const Color divider = Color(0xFFCAC4D0);
  static const Color disabled = Color(0x381C1B1F);
  static const Color cardShadow = Color(0x1A000000);     // 10% black
  static const Color overlay = Color(0xB3000000);        // 70% black
}
