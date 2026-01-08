import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../core/utils/logger.dart';
import '../data/models/ocr_result.dart';

class OcrService {
  final TextRecognizer _textRecognizer;

  OcrService({TextRecognizer? textRecognizer})
      : _textRecognizer = textRecognizer ??
            TextRecognizer(script: TextRecognitionScript.korean);

  Future<OcrResult?> processImage(String imagePath) async {
    Log.i('📷 [OCR] 텍스트 인식 시작 | path: $imagePath');

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final blocks = recognizedText.blocks.map((block) {
        final boundingBox = block.boundingBox;
        return OcrTextBlock(
          text: block.text,
          rect: OcrRect(
            x: boundingBox.left,
            y: boundingBox.top,
            width: boundingBox.width,
            height: boundingBox.height,
          ),
        );
      }).toList();

      final result = OcrResult(
        fullText: recognizedText.text,
        blocks: blocks,
        processedAt: DateTime.now(),
      );

      Log.i('✅ [OCR] 텍스트 인식 완료 | blocks: ${blocks.length}, '
          'text: ${result.fullText.length > 50 ? '${result.fullText.substring(0, 50)}...' : result.fullText}');

      return result;
    } catch (e, s) {
      Log.e('❌ [OCR] 텍스트 인식 실패', e, s);
      return null;
    }
  }

  Future<OcrResult?> processImageFromFile(File file) async {
    return processImage(file.path);
  }

  void dispose() {
    _textRecognizer.close();
    Log.d('📷 [OCR] TextRecognizer 해제');
  }
}
