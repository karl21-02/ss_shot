# 07. 인증 및 보안 정책 (Authentication & Security)

> 소셜 로그인, JWT 토큰 관리, 보안 정책 정의

---

## 1. 인증 정책 개요

### 1.1 핵심 원칙

| 원칙 | 설명 |
| --- | --- |
| **간편한 가입** | 소셜 로그인으로 별도 회원가입 폼 없이 가입 |
| **무상태 인증** | JWT 기반 Stateless 인증 |
| **데이터 격리** | user_id 기반 완전한 데이터 분리 |
| **프라이버시 우선** | 이미지 원본 서버 미저장 |

### 1.2 지원 로그인 방식

| 방식 | 대상 플랫폼 | 필수 여부 |
| --- | --- | --- |
| **Google Sign-In** | iOS, Android | 필수 |
| **Apple Sign-In** | iOS | iOS 필수 (App Store 정책) |

---

## 2. 소셜 로그인 흐름

### 2.1 Google Sign-In 시퀀스

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Client    │    │   Google    │    │   Server    │    │   Database  │
│  (Flutter)  │    │   OAuth     │    │(Spring Boot)│    │   (MySQL)   │
└──────┬──────┘    └──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                  │                  │
       │  1. 로그인 버튼 클릭│                  │                  │
       │─────────────────▶│                  │                  │
       │                  │                  │                  │
       │  2. Google 인증 팝업│                  │                  │
       │◀─────────────────│                  │                  │
       │                  │                  │                  │
       │  3. 사용자 동의    │                  │                  │
       │─────────────────▶│                  │                  │
       │                  │                  │                  │
       │  4. id_token 반환 │                  │                  │
       │◀─────────────────│                  │                  │
       │                  │                  │                  │
       │  5. POST /api/auth/google          │                  │
       │  { idToken: "..." }                │                  │
       │────────────────────────────────────▶│                  │
       │                  │                  │                  │
       │                  │  6. id_token 검증│                  │
       │                  │  (Google 공개키) │                  │
       │                  │◀─────────────────│                  │
       │                  │                  │                  │
       │                  │                  │  7. 사용자 조회/생성
       │                  │                  │─────────────────▶│
       │                  │                  │◀─────────────────│
       │                  │                  │                  │
       │  8. JWT 토큰 발급                   │                  │
       │  { accessToken, refreshToken }     │                  │
       │◀───────────────────────────────────│                  │
       │                  │                  │                  │
       │  9. 토큰 저장 (SecureStorage)       │                  │
       │                  │                  │                  │
```

### 2.2 Apple Sign-In 시퀀스

Apple Sign-In은 Google과 유사하지만, 다음 차이점이 있습니다:

| 항목 | Google | Apple |
| --- | --- | --- |
| **토큰 타입** | id_token | authorization_code + id_token |
| **이메일 제공** | 항상 제공 | 최초 1회만 (이후 숨김 가능) |
| **이름 제공** | 항상 제공 | 최초 1회만 |

---

## 3. JWT 토큰 정책

### 3.1 토큰 구조

```
┌─────────────────────────────────────────────────────────────────┐
│                        Access Token                              │
├─────────────────────────────────────────────────────────────────┤
│  Header: { "alg": "HS256", "typ": "JWT" }                       │
│  Payload: {                                                      │
│    "sub": "12345",           // user_id                         │
│    "email": "user@email.com",                                   │
│    "iat": 1704700800,        // 발급 시간                        │
│    "exp": 1704704400         // 만료 시간 (1시간 후)             │
│  }                                                               │
│  Signature: HMACSHA256(header + payload, secret)                │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 토큰 유효 기간

| 토큰 | 유효 기간 | 저장 위치 |
| --- | --- | --- |
| **Access Token** | 1시간 | FlutterSecureStorage |
| **Refresh Token** | 14일 | FlutterSecureStorage |

### 3.3 토큰 갱신 (Silent Refresh)

```
┌─────────────┐                              ┌─────────────┐
│   Client    │                              │   Server    │
└──────┬──────┘                              └──────┬──────┘
       │                                            │
       │  1. API 요청 (만료된 Access Token)          │
       │───────────────────────────────────────────▶│
       │                                            │
       │  2. 401 Unauthorized                       │
       │◀───────────────────────────────────────────│
       │                                            │
       │  3. POST /api/auth/refresh                 │
       │  { refreshToken: "..." }                   │
       │───────────────────────────────────────────▶│
       │                                            │
       │  4. Refresh Token 검증                     │
       │                                            │
       │  5. 새 Access Token 발급                   │
       │  { accessToken: "new...", refreshToken: "new..." }
       │◀───────────────────────────────────────────│
       │                                            │
       │  6. 토큰 저장 후 원래 요청 재시도            │
       │───────────────────────────────────────────▶│
       │                                            │
```

---

## 4. API 보안

### 4.1 인증 헤더

```http
GET /api/screenshots HTTP/1.1
Host: api.ss-shot.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### 4.2 인증 제외 엔드포인트

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // 인증 불필요
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/health").permitAll()

                // 그 외 모든 요청은 인증 필요
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

### 4.3 Rate Limiting

| 엔드포인트 | 제한 |
| --- | --- |
| `/api/auth/**` | 10회/분 (IP 기준) |
| `/api/sync` | 100회/분 (사용자 기준) |
| `/api/search` | 60회/분 (사용자 기준) |
| 기타 | 300회/분 (사용자 기준) |

---

## 5. 데이터 보안

### 5.1 데이터 격리 정책

모든 데이터는 `user_id`를 기준으로 완전히 격리됩니다.

```java
// Repository 예시
@Repository
public interface ScreenshotRepository extends JpaRepository<ScreenshotMetadata, Long> {

    // 반드시 user_id 조건 포함
    List<ScreenshotMetadata> findByUserIdAndIsDeletedFalse(Long userId);

    @Query("SELECT s FROM ScreenshotMetadata s WHERE s.userId = :userId AND ...")
    List<ScreenshotMetadata> search(@Param("userId") Long userId, ...);
}
```

```java
// Service 예시
@Service
public class ScreenshotService {

    public List<ScreenshotDto> getScreenshots(Long userId) {
        // 현재 인증된 사용자 ID와 요청 ID 비교
        Long currentUserId = SecurityContextHolder.getContext()
            .getAuthentication().getPrincipal().getId();

        if (!currentUserId.equals(userId)) {
            throw new AccessDeniedException("접근 권한이 없습니다.");
        }

        return repository.findByUserIdAndIsDeletedFalse(userId);
    }
}
```

### 5.2 프라이버시 보호

| 항목 | 정책 |
| --- | --- |
| **이미지 원본** | 서버 미저장 (클라이언트 Only) |
| **OCR 텍스트** | 서버 저장 (검색 기능 제공) |
| **좌표 정보** | 서버 저장 (하이라이팅 기능) |
| **개인정보** | 최소 수집 (email, name only) |

### 5.3 민감 정보 처리

```java
// 로그에 민감 정보 노출 금지
@Slf4j
public class LoggingFilter {

    @Override
    protected void doFilterInternal(...) {
        // 토큰, 비밀번호 등 마스킹
        String maskedToken = maskToken(request.getHeader("Authorization"));
        log.info("Request: {} {} | Token: {}", method, uri, maskedToken);
    }

    private String maskToken(String token) {
        if (token == null) return "null";
        return token.substring(0, 10) + "***";
    }
}
```

---

## 6. 클라이언트 보안

### 6.1 토큰 저장

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
```

### 6.2 HTTP 인터셉터

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 토큰 갱신 시도
      final success = await _refreshToken();
      if (success) {
        // 원래 요청 재시도
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      } else {
        // 로그아웃 처리
        await TokenStorage.clearTokens();
        // 로그인 화면으로 이동
      }
    }
    handler.next(err);
  }
}
```

---

## 7. 통신 보안

### 7.1 HTTPS 필수

```yaml
# application.yml
server:
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: ${SSL_PASSWORD}
    key-store-type: PKCS12
```

### 7.2 AWS 설정

```
Route 53 (DNS)
     │
     ▼
 ACM (SSL/TLS 인증서)
     │
     ▼
 ALB (HTTPS 443 → HTTP 8080)
     │
     ▼
 EC2 (Spring Boot)
```

---

## 8. 인증 관련 API

### 8.1 소셜 로그인

**Google Sign-In:**
```http
POST /api/auth/google
Content-Type: application/json

{
  "idToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Apple Sign-In:**
```http
POST /api/auth/apple
Content-Type: application/json

{
  "authorizationCode": "c1234567890...",
  "idToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "name": "홍길동"  // 최초 로그인 시에만
}
```

**응답:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 12345,
    "email": "user@email.com",
    "name": "홍길동"
  }
}
```

### 8.2 토큰 갱신

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**응답:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 8.3 로그아웃

```http
POST /api/auth/logout
Authorization: Bearer {accessToken}
```

---

## 9. 참고 문서

- [02-ARCHITECTURE.md](./02-ARCHITECTURE.md) - 시스템 아키텍처
- [06-DB_SCHEMA.md](./06-DB_SCHEMA.md) - 데이터베이스 스키마
