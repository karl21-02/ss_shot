import 'dart:convert';
import 'dart:ui';

class OcrResult {
  final String fullText;
  final List<OcrTextBlock> blocks;
  final DateTime processedAt;

  const OcrResult({
    required this.fullText,
    required this.blocks,
    required this.processedAt,
  });

  Map<String, dynamic> toJson() => {
        'fullText': fullText,
        'blocks': blocks.map((b) => b.toJson()).toList(),
        'processedAt': processedAt.toIso8601String(),
      };

  factory OcrResult.fromJson(Map<String, dynamic> json) => OcrResult(
        fullText: json['fullText'] as String,
        blocks: (json['blocks'] as List)
            .map((b) => OcrTextBlock.fromJson(b as Map<String, dynamic>))
            .toList(),
        processedAt: DateTime.parse(json['processedAt'] as String),
      );

  String toJsonString() => jsonEncode(toJson());

  factory OcrResult.fromJsonString(String jsonString) =>
      OcrResult.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}

class OcrTextBlock {
  final String text;
  final OcrRect rect;

  const OcrTextBlock({
    required this.text,
    required this.rect,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'rect': rect.toJson(),
      };

  factory OcrTextBlock.fromJson(Map<String, dynamic> json) => OcrTextBlock(
        text: json['text'] as String,
        rect: OcrRect.fromJson(json['rect'] as Map<String, dynamic>),
      );
}

class OcrRect {
  final double x;
  final double y;
  final double width;
  final double height;

  const OcrRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  factory OcrRect.fromJson(Map<String, dynamic> json) => OcrRect(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
      );

  Rect toRect() => Rect.fromLTWH(x, y, width, height);
}
