# 08. 개발 가이드 (Development Guide)

> 프로젝트 구조, 코딩 컨벤션, Git 전략

---

## 1. Flutter 프로젝트 구조

### 1.1 디렉토리 구조

```
lib/
├── main.dart                    # 앱 진입점
├── app.dart                     # MaterialApp 설정
│
├── core/                        # 공통 모듈
│   ├── constants/               # 상수 정의
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── api_endpoints.dart
│   ├── utils/                   # 유틸리티
│   │   ├── date_utils.dart
│   │   └── regex_patterns.dart
│   ├── errors/                  # 에러 처리
│   │   └── failures.dart
│   └── extensions/              # 확장 함수
│       └── string_extensions.dart
│
├── data/                        # 데이터 레이어
│   ├── datasources/             # 데이터 소스
│   │   ├── remote/              # API 호출
│   │   │   └── screenshot_remote_datasource.dart
│   │   └── local/               # 로컬 DB
│   │       └── screenshot_local_datasource.dart
│   ├── models/                  # DTO/모델
│   │   ├── screenshot_model.dart
│   │   └── user_model.dart
│   └── repositories/            # Repository 구현체
│       └── screenshot_repository_impl.dart
│
├── domain/                      # 도메인 레이어
│   ├── entities/                # 엔티티 (순수 데이터)
│   │   ├── screenshot.dart
│   │   └── user.dart
│   ├── repositories/            # Repository 인터페이스
│   │   └── screenshot_repository.dart
│   └── usecases/                # 비즈니스 로직
│       ├── sync_screenshots.dart
│       ├── search_screenshots.dart
│       └── delete_screenshot.dart
│
├── presentation/                # 프레젠테이션 레이어
│   ├── screens/                 # 화면
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── category_tabs.dart
│   │   │       └── gallery_grid.dart
│   │   ├── search/
│   │   │   └── search_screen.dart
│   │   ├── detail/
│   │   │   └── detail_screen.dart
│   │   └── clean/
│   │       └── clean_mode_screen.dart
│   ├── viewmodels/              # ViewModel (Riverpod)
│   │   ├── home_viewmodel.dart
│   │   └── search_viewmodel.dart
│   └── widgets/                 # 공통 위젯
│       ├── loading_indicator.dart
│       └── error_view.dart
│
├── services/                    # 서비스
│   ├── ocr_service.dart         # ML Kit OCR
│   ├── gallery_service.dart     # 갤러리 접근
│   └── sync_service.dart        # 동기화 엔진
│
└── di/                          # 의존성 주입
    └── injection.dart
```

### 1.2 레이어별 역할

| 레이어 | 역할 | 의존성 방향 |
| --- | --- | --- |
| **Presentation** | UI, 상태 관리 | → Domain |
| **Domain** | 비즈니스 로직, 엔티티 | 의존성 없음 (Core) |
| **Data** | API 호출, DB 접근, Repository 구현 | → Domain |

---

## 2. Spring Boot 프로젝트 구조

### 2.1 디렉토리 구조

```
src/main/java/com/ssshot/
├── SsShotApplication.java       # 앱 진입점
│
├── config/                      # 설정
│   ├── SecurityConfig.java
│   ├── JwtConfig.java
│   └── WebConfig.java
│
├── domain/                      # 도메인
│   ├── user/
│   │   ├── User.java            # Entity
│   │   ├── UserRepository.java  # Repository
│   │   └── UserService.java     # Service
│   └── screenshot/
│       ├── ScreenshotMetadata.java
│       ├── ScreenshotRepository.java
│       ├── ScreenshotService.java
│       └── Category.java        # Enum
│
├── api/                         # API 컨트롤러
│   ├── auth/
│   │   ├── AuthController.java
│   │   ├── AuthRequest.java
│   │   └── AuthResponse.java
│   ├── screenshot/
│   │   ├── ScreenshotController.java
│   │   ├── SyncRequest.java
│   │   └── SearchResponse.java
│   └── common/
│       └── ApiResponse.java
│
├── security/                    # 보안
│   ├── JwtTokenProvider.java
│   ├── JwtAuthenticationFilter.java
│   └── CustomUserDetails.java
│
└── util/                        # 유틸리티
    └── CategoryClassifier.java
```

---

## 3. 코딩 컨벤션

### 3.1 Dart (Flutter)

**네이밍:**
| 대상 | 스타일 | 예시 |
| --- | --- | --- |
| 파일 | snake_case | `home_screen.dart` |
| 클래스 | PascalCase | `HomeScreen` |
| 변수/함수 | camelCase | `syncScreenshots()` |
| 상수 | lowerCamelCase | `const maxRetryCount = 3;` |
| Private | _ 접두사 | `_internalMethod()` |

**코드 스타일:**
```dart
// Good: 명확한 타입 선언
final List<Screenshot> screenshots = [];

// Good: Named parameters 활용
void syncScreenshots({
  required String userId,
  bool forceRefresh = false,
}) {
  // ...
}

// Good: Extension 활용
extension DateTimeX on DateTime {
  String toRelativeString() {
    // ...
  }
}
```

### 3.2 Java (Spring Boot)

**네이밍:**
| 대상 | 스타일 | 예시 |
| --- | --- | --- |
| 패키지 | lowercase | `com.ssshot.domain` |
| 클래스 | PascalCase | `ScreenshotService` |
| 변수/메서드 | camelCase | `findByUserId()` |
| 상수 | UPPER_SNAKE | `MAX_RETRY_COUNT` |

**코드 스타일:**
```java
// Good: Lombok 활용
@Getter
@RequiredArgsConstructor
public class ScreenshotService {
    private final ScreenshotRepository repository;

    public List<ScreenshotDto> search(Long userId, String query) {
        // ...
    }
}

// Good: Optional 활용
public Optional<User> findByEmail(String email) {
    return userRepository.findByEmail(email);
}

// Good: Stream API 활용
List<ScreenshotDto> dtos = screenshots.stream()
    .map(this::toDto)
    .collect(Collectors.toList());
```

---

## 4. Git 브랜치 전략

### 4.1 브랜치 구조

```
main                    # 프로덕션 배포
  │
  └── develop           # 개발 통합
        │
        ├── feature/ocr-integration      # 기능 개발
        ├── feature/search-api
        ├── fix/sync-retry-bug           # 버그 수정
        └── refactor/clean-architecture  # 리팩토링
```

### 4.2 브랜치 명명 규칙

| 접두사 | 용도 | 예시 |
| --- | --- | --- |
| `feature/` | 새 기능 개발 | `feature/swipe-to-clean` |
| `fix/` | 버그 수정 | `fix/ocr-crash` |
| `refactor/` | 코드 개선 | `refactor/repository-pattern` |
| `docs/` | 문서 수정 | `docs/api-spec` |
| `chore/` | 빌드/설정 | `chore/update-dependencies` |

### 4.3 커밋 메시지 규칙

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type:**
| Type | 설명 |
| --- | --- |
| `feat` | 새로운 기능 |
| `fix` | 버그 수정 |
| `refactor` | 코드 리팩토링 |
| `docs` | 문서 수정 |
| `test` | 테스트 추가/수정 |
| `chore` | 빌드/설정 변경 |

**예시:**
```
feat(ocr): ML Kit OCR 연동 구현

- TextRecognizer 초기화 로직 추가
- 이미지 → 텍스트 추출 기능 구현
- BoundingBox 좌표 저장 구조 정의

Closes #12
```

---

## 5. 환경 설정

### 5.1 Flutter 환경 분리

```dart
// lib/core/config/environment.dart
enum Environment { dev, staging, prod }

class EnvConfig {
  static late Environment current;

  static String get apiBaseUrl {
    switch (current) {
      case Environment.dev:
        return 'http://localhost:8080';
      case Environment.staging:
        return 'https://staging-api.ss-shot.com';
      case Environment.prod:
        return 'https://api.ss-shot.com';
    }
  }
}
```

**실행 방법:**
```bash
# 개발 환경
flutter run --dart-define=ENV=dev

# 스테이징 환경
flutter run --dart-define=ENV=staging

# 프로덕션 환경
flutter run --dart-define=ENV=prod
```

### 5.2 Spring Boot 환경 분리

```yaml
# application.yml (공통)
spring:
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:dev}

---
# application-dev.yml
spring:
  config:
    activate:
      on-profile: dev
  datasource:
    url: jdbc:mysql://localhost:3306/ssshot_dev

---
# application-prod.yml
spring:
  config:
    activate:
      on-profile: prod
  datasource:
    url: jdbc:mysql://${RDS_HOST}:3306/ssshot_prod
```

---

## 6. 테스트 전략

### 6.1 Flutter 테스트

```dart
// 단위 테스트
test('OCR 결과 파싱 테스트', () {
  final result = parseOcrResult(mockResponse);
  expect(result.fullText, contains('스타벅스'));
  expect(result.blocks.length, 3);
});

// Widget 테스트
testWidgets('홈 화면 렌더링 테스트', (tester) async {
  await tester.pumpWidget(const HomeScreen());
  expect(find.text('어떤 정보를 찾으세요?'), findsOneWidget);
});
```

### 6.2 Spring Boot 테스트

```java
// 단위 테스트
@Test
void 카테고리_분류_테스트() {
    String text = "스타벅스 아메리카노 4,500원 결제 완료";
    Category result = classifier.classify(text);
    assertEquals(Category.SHOPPING, result);
}

// 통합 테스트
@SpringBootTest
@AutoConfigureMockMvc
class ScreenshotControllerTest {

    @Test
    void 검색_API_테스트() throws Exception {
        mockMvc.perform(get("/api/search")
                .param("q", "스타벅스")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.results").isArray());
    }
}
```

---

## 7. CI/CD 파이프라인

### 7.1 GitHub Actions (Flutter)

```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

### 7.2 GitHub Actions (Spring Boot)

```yaml
# .github/workflows/spring.yml
name: Spring Boot CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'

      - run: ./gradlew build
      - run: ./gradlew test
```

---

## 8. 개발 시작하기

### 8.1 Flutter 프로젝트 설정

```bash
# 1. 의존성 설치
flutter pub get

# 2. 코드 생성 (Drift, Riverpod 등)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 개발 서버 실행
flutter run
```

### 8.2 Spring Boot 프로젝트 설정

```bash
# 1. 로컬 MySQL 실행 (Docker)
docker run -d \
  --name ssshot-mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=ssshot_dev \
  -p 3306:3306 \
  mysql:8.0

# 2. 애플리케이션 실행
./gradlew bootRun
```

---

## 9. 참고 문서

- [01-PROJECT_OVERVIEW.md](./01-PROJECT_OVERVIEW.md) - 프로젝트 개요
- [03-TECH_STACK.md](./03-TECH_STACK.md) - 기술 스택
- [04-FEATURE_SPEC.md](./04-FEATURE_SPEC.md) - 기능 명세
