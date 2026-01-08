import '../../../data/datasources/local/app_database.dart';

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
