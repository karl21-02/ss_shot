import 'package:logger/logger.dart';

/// SS-Shot 로깅 유틸리티
///
/// LOGGING.md 표준을 준수합니다.
/// print() 대신 이 클래스를 사용하세요.
class Log {
  static final bool _isProduction =
      const bool.fromEnvironment('dart.vm.product');

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// INFO 레벨 로그
  /// 주요 비즈니스 로직 흐름에 사용
  static void i(String message, [dynamic error]) {
    _logger.i(message, error: error);
  }

  /// DEBUG 레벨 로그
  /// 개발 단계 상세 정보에 사용
  static void d(String message, [dynamic error]) {
    if (!_isProduction) {
      _logger.d(message, error: error);
    }
  }

  /// WARNING 레벨 로그
  /// 잠재적 문제 상황에 사용
  static void w(String message, [dynamic error]) {
    _logger.w(message, error: error);
  }

  /// ERROR 레벨 로그
  /// 예외 발생 시 사용 (stackTrace 권장)
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
