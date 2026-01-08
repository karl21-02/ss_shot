# SS-Shot Logging Standards

이 문서는 SS-Shot 프로젝트의 모든 로그 출력 표준을 정의합니다.
**본 가이드를 준수하지 않은 PR은 병합되지 않습니다.**

---

## 1. General Principles (공통 원칙)

### 1.1 No Print Statements

| 금지 | 허용 |
|------|------|
| `print()` | `Log.i()` |
| `debugPrint()` | `Log.d()` |
| `developer.log()` | `Log.e()` |

**반드시 프로젝트에서 지정한 `Log` 클래스를 통해서만 출력한다.**

### 1.2 Sensitive Data Masking (보안)

다음 정보는 로그 출력 시 **반드시 마스킹(`****`)** 처리해야 한다:

| 카테고리 | 예시 |
|----------|------|
| **개인정보** | 주민등록번호, 전화번호, 이메일, 계좌번호 |
| **인증정보** | JWT Access/Refresh Token, Password |
| **OCR 결과** | 민감한 텍스트 (금액, 계좌번호 등) |
| **이미지** | Base64 인코딩된 문자열 (용량 폭발 방지) |

**마스킹 예시:**
```dart
// Bad
Log.d("Token: $accessToken");
Log.d("계좌: $accountNumber");

// Good
Log.d("Token: ${accessToken.substring(0, 10)}****");
Log.d("계좌: ${accountNumber.replaceRange(4, accountNumber.length - 2, '****')}");
```

### 1.3 Log Levels

| Level | 메서드 | 설명 | 사용 예시 |
|-------|--------|------|----------|
| **ERROR** | `Log.e()` | 시스템 동작 불가, 예외 발생 | API 500 에러, DB 연결 실패, 크래시 |
| **WARNING** | `Log.w()` | 잠재적 문제, 프로세스 중단은 아님 | 재시도 로직 실행, 파싱 실패(일부) |
| **INFO** | `Log.i()` | 주요 비즈니스 로직의 흐름 | 화면 진입, 동기화 시작/완료 |
| **DEBUG** | `Log.d()` | 개발 단계 상세 정보 | API 요청/응답, 변수 값 확인 |

---

## 2. Emoji Convention (이모지 컨벤션)

모바일 터미널 가독성을 위해 **이모지(Emoji)**를 적극 활용한다.
로그 메시지 맨 앞에 상황에 맞는 이모지를 붙여야 한다.

### 2.1 Category Emojis

| Category | Emoji | 상황 | 예시 |
|----------|-------|------|------|
| **Lifecycle** | 🚀 | 앱 시작, 초기화 | `🚀 [App] SS-Shot 초기화 완료` |
| **Success** | ✅ | 주요 작업 성공 | `✅ [Sync] 동기화 완료` |
| **Error** | ❌ | 예외 발생, 실패 | `❌ [Auth] 로그인 실패 (401)` |
| **Warning** | ⚠️ | 잠재적 문제 | `⚠️ [API] 재시도 중 (2/3)` |
| **Network** | ☁️ | API 요청/응답 | `☁️ [API] GET /screenshots (200)` |
| **Sync** | 🔄 | 데이터 동기화 | `🔄 [Sync] 갤러리 스캔 시작` |
| **OCR** | 📷 | 이미지 처리, 텍스트 추출 | `📷 [OCR] 텍스트 추출 완료 (3건)` |
| **Gallery** | 🖼️ | 갤러리 접근 | `🖼️ [Gallery] 스크린샷 15장 로드` |
| **Database** | 💾 | 로컬 DB 읽기/쓰기 | `💾 [DB] PendingSync 5건 저장` |
| **Auth** | 🔐 | 인증/보안 | `🔐 [Auth] 토큰 갱신 성공` |
| **Screen** | 📱 | 화면 전환, UI 상태 | `📱 [Home] 화면 진입` |
| **Action** | 👆 | 사용자 액션 | `👆 [Action] 스와이프 삭제` |

### 2.2 Quick Reference

```
🚀 시작/초기화    ✅ 성공/완료    ❌ 에러/실패    ⚠️ 경고
☁️ 네트워크      🔄 동기화       📷 OCR         🖼️ 갤러리
💾 DB           🔐 인증         📱 화면         👆 액션
```

---

## 3. Logging Format

### 3.1 Standard Format

```
[Emoji] [Tag] Message | Context (Optional)
```

**구성 요소:**
- **Emoji:** 카테고리 이모지 (필수)
- **Tag:** 모듈/클래스명 대괄호로 감싸기 (필수)
- **Message:** 간결한 설명 (필수)
- **Context:** 추가 정보, 파이프(`|`)로 구분 (선택)

### 3.2 Examples

```dart
// Lifecycle
Log.i("🚀 [App] SS-Shot 앱 시작");
Log.i("🚀 [Init] Riverpod 초기화 완료");

// Success
Log.i("✅ [Sync] 동기화 완료 | 이미지: 15장, 소요: 2.3초");
Log.i("✅ [OCR] 텍스트 추출 성공 | blocks: 8개");

// Error (error, stackTrace 필수)
Log.e("❌ [API] 네트워크 오류 | status: 500", error, stackTrace);
Log.e("❌ [OCR] 텍스트 인식 실패", error, stackTrace);

// Warning
Log.w("⚠️ [Sync] 네트워크 불안정, 재시도 중 | attempt: 2/3");
Log.w("⚠️ [Gallery] 권한 거부됨");

// Network
Log.i("☁️ [API] POST /api/sync | body: ${items.length}건");
Log.d("☁️ [API] Response | status: 200, time: 150ms");

// OCR
Log.i("📷 [OCR] 분석 시작 | localId: $localId");
Log.d("📷 [OCR] 결과 | text: ${text.substring(0, 50)}...");

// Database
Log.d("💾 [DB] INSERT PendingSync | id: $id");
Log.i("💾 [DB] 동기화 대기열 조회 | count: ${queue.length}");

// Auth
Log.i("🔐 [Auth] 소셜 로그인 시작 | provider: Google");
Log.i("🔐 [Auth] 토큰 저장 완료");

// Screen
Log.d("📱 [Home] 화면 진입");
Log.d("📱 [Detail] 이미지 뷰어 열기 | localId: $localId");
```

---

## 4. Implementation

### 4.1 Log Utility Class

**파일 위치:** `lib/core/utils/logger.dart`

```dart
import 'package:logger/logger.dart';

/// SS-Shot 로깅 유틸리티
///
/// LOGGING.md 표준을 준수합니다.
/// print() 대신 이 클래스를 사용하세요.
class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,  // 직접 이모지 관리
      printTime: true,
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
    _logger.d(message, error: error);
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
```

### 4.2 Usage Examples

```dart
import 'package:ss_shot/core/utils/logger.dart';

class GalleryService {
  Future<List<Asset>> loadScreenshots() async {
    Log.i("🖼️ [Gallery] 스크린샷 로드 시작");

    try {
      final assets = await PhotoManager.getAssetPathList();
      Log.i("✅ [Gallery] 로드 완료 | count: ${assets.length}");
      return assets;
    } catch (e, s) {
      Log.e("❌ [Gallery] 로드 실패", e, s);
      rethrow;
    }
  }
}
```

---

## 5. Prohibited Patterns (금지 패턴)

### 5.1 절대 금지

```dart
// ❌ print 계열 사용
print("Hello");
debugPrint("Debug");

// ❌ 민감정보 노출
Log.d("Token: $accessToken");
Log.d("계좌번호: 110-123-456789");

// ❌ 무의미한 로그
Log.d("Here");
Log.d("Test 1");
Log.d("asdf");

// ❌ 이모지/태그 누락
Log.i("로드 완료");  // 이모지, 태그 없음

// ❌ Base64 이미지 출력
Log.d("Image: $base64String");  // 로그 용량 폭발
```

### 5.2 올바른 사용

```dart
// ✅ Log 클래스 사용
Log.i("🚀 [App] 초기화 완료");

// ✅ 민감정보 마스킹
Log.d("🔐 [Auth] Token: ${token.substring(0, 10)}****");

// ✅ 의미 있는 메시지
Log.i("📷 [OCR] 텍스트 추출 시작 | localId: $localId");

// ✅ 이모지 + 태그 포함
Log.i("✅ [Sync] 동기화 완료 | count: 15");

// ✅ 에러는 stackTrace 포함
Log.e("❌ [API] 요청 실패", error, stackTrace);
```

---

## 6. Production Considerations

### 6.1 로그 레벨 관리

```dart
// 환경별 로그 레벨 설정
class Log {
  static final bool _isProduction = const bool.fromEnvironment('dart.vm.product');

  static void d(String message, [dynamic error]) {
    if (!_isProduction) {
      _logger.d(message, error: error);
    }
  }
}
```

### 6.2 Release 빌드

- **DEBUG 로그:** Production에서 제외
- **INFO 로그:** 주요 흐름만 유지
- **ERROR 로그:** 항상 출력 (Crashlytics 연동 권장)

---

## 7. Checklist (PR 체크리스트)

PR 제출 전 확인사항:

- [ ] `print()` 사용하지 않음
- [ ] 모든 로그에 이모지 포함
- [ ] 모든 로그에 태그(`[Tag]`) 포함
- [ ] 민감정보 마스킹 처리
- [ ] ERROR 로그에 stackTrace 포함
- [ ] 무의미한 디버그 로그 제거

---

## 8. Related Documents

- [RULE.md](../RULE.md) - 시스템 지침 (Part 4. Logging Standards)
- [08-DEVELOPMENT_GUIDE.md](./08-DEVELOPMENT_GUIDE.md) - 개발 가이드
