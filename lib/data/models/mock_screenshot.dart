class MockScreenshot {
  final String id;
  final String imageUrl;
  final DateTime createdAt;

  const MockScreenshot({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
  });

  static List<MockScreenshot> generateMockData({int count = 20}) {
    return List.generate(count, (index) {
      return MockScreenshot(
        id: 'mock_$index',
        imageUrl: 'https://picsum.photos/200/400?random=$index',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });
  }
}
