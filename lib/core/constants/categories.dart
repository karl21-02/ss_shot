import 'package:flutter/material.dart';

import '../../../data/datasources/local/app_database.dart';

/// 상태 필터 정보
class StatusFilterInfo {
  final ScreenshotStatus? status; // null이면 '전체'
  final String label;
  final IconData icon;

  const StatusFilterInfo({
    required this.status,
    required this.label,
    required this.icon,
  });
}

/// 홈 화면 상태 필터 목록
const List<StatusFilterInfo> statusFilters = [
  StatusFilterInfo(
    status: null,
    label: '전체',
    icon: Icons.all_inclusive,
  ),
  StatusFilterInfo(
    status: ScreenshotStatus.kept,
    label: '보관',
    icon: Icons.bookmark,
  ),
  StatusFilterInfo(
    status: ScreenshotStatus.trash,
    label: '쓸모없음',
    icon: Icons.delete_outline,
  ),
  StatusFilterInfo(
    status: ScreenshotStatus.unclassified,
    label: '미분류',
    icon: Icons.help_outline,
  ),
];

/// 콘텐츠 카테고리 정보 (OCR 분류용 - 향후 사용)
class CategoryInfo {
  final ScreenshotCategory category;
  final String label;
  final List<String> keywords;

  const CategoryInfo({
    required this.category,
    required this.label,
    required this.keywords,
  });
}

const List<CategoryInfo> categories = [
  CategoryInfo(
    category: ScreenshotCategory.all,
    label: '전체',
    keywords: [],
  ),
  CategoryInfo(
    category: ScreenshotCategory.finance,
    label: '금융',
    keywords: ['입금', '출금', '잔액', '이체', '계좌', '원', '결제', '카드', '은행'],
  ),
  CategoryInfo(
    category: ScreenshotCategory.shopping,
    label: '쇼핑',
    keywords: ['배송', '장바구니', '주문', '결제완료', '쿠팡', '배민', '구매', '배달'],
  ),
  CategoryInfo(
    category: ScreenshotCategory.schedule,
    label: '일정',
    keywords: ['초대', '약속', '예약', '월', '일', 'PM', 'AM', '시', '분'],
  ),
  CategoryInfo(
    category: ScreenshotCategory.humor,
    label: '유머',
    keywords: ['ㅋㅋ', 'ㅎㅎ', 'ㅠㅠ', 'ㅜㅜ', '짤', '밈', 'ㅋㅋㅋ'],
  ),
  CategoryInfo(
    category: ScreenshotCategory.other,
    label: '기타',
    keywords: [],
  ),
];

ScreenshotCategory classifyText(String text) {
  final lowerText = text.toLowerCase();

  for (final info in categories) {
    if (info.category == ScreenshotCategory.all ||
        info.category == ScreenshotCategory.other) {
      continue;
    }

    for (final keyword in info.keywords) {
      if (lowerText.contains(keyword.toLowerCase())) {
        return info.category;
      }
    }
  }

  return ScreenshotCategory.other;
}
