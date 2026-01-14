import '../datasources/local/app_database.dart';

class MockScreenshot {
  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final ScreenshotStatus status;

  const MockScreenshot({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    this.status = ScreenshotStatus.unclassified,
  });

  MockScreenshot copyWith({
    String? id,
    String? imageUrl,
    DateTime? createdAt,
    ScreenshotStatus? status,
  }) {
    return MockScreenshot(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  static List<MockScreenshot> generateMockData({int count = 20}) {
    return List.generate(count, (index) {
      // 다양한 상태로 Mock 데이터 생성
      ScreenshotStatus status;
      if (index < 5) {
        status = ScreenshotStatus.kept;
      } else if (index < 8) {
        status = ScreenshotStatus.trash;
      } else {
        status = ScreenshotStatus.unclassified;
      }

      return MockScreenshot(
        id: 'mock_$index',
        imageUrl: 'https://picsum.photos/200/400?random=$index',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
        status: status,
      );
    });
  }
}
