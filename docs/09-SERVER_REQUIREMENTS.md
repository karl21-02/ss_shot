# 09. 서버 요구사항 (Server Requirements)

> Spring Boot 백엔드 구현 명세서

---

## 1. 개요

### 1.1 기술 스택

| 항목 | 기술 |
|---|---|
| **Framework** | Spring Boot 3.x |
| **Language** | Java 17+ / Kotlin |
| **Database** | PostgreSQL 15+ (또는 MySQL 8+) |
| **ORM** | Spring Data JPA |
| **인증** | JWT + Spring Security |
| **빌드** | Gradle |
| **API 문서** | Swagger/OpenAPI 3.0 |

### 1.2 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    Spring Boot Server                        │
├─────────────────────────────────────────────────────────────┤
│  Controller → Service → Repository → Database (PostgreSQL)  │
│      ↓                                                       │
│  [JWT Filter] ← Spring Security                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. API 명세

### 2.1 인증 API

#### POST `/api/auth/google`
Google 소셜 로그인

**Request:**
```json
{
  "idToken": "google_id_token_from_client"
}
```

**Response (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 3600,
  "user": {
    "id": 1,
    "email": "user@gmail.com",
    "name": "홍길동",
    "profileUrl": "https://..."
  }
}
```

#### POST `/api/auth/apple`
Apple 소셜 로그인

**Request:**
```json
{
  "identityToken": "apple_identity_token",
  "authorizationCode": "apple_auth_code",
  "name": "홍길동"
}
```

**Response:** Google 로그인과 동일

#### POST `/api/auth/refresh`
토큰 갱신

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response (200):**
```json
{
  "accessToken": "new_access_token",
  "expiresIn": 3600
}
```

---

### 2.2 동기화 API

#### POST `/api/sync`
스크린샷 메타데이터 동기화 (Upsert)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "screenshots": [
    {
      "localId": "IMG_9981",
      "fullText": "스타벅스 아메리카노 4,500원 결제 완료",
      "blocks": [
        {
          "text": "스타벅스",
          "rect": {"x": 100, "y": 200, "width": 80, "height": 25}
        },
        {
          "text": "4,500원",
          "rect": {"x": 100, "y": 280, "width": 60, "height": 20}
        }
      ],
      "capturedAt": "2026-01-08T10:30:00Z"
    }
  ]
}
```

**Response (200):**
```json
{
  "synced": 1,
  "failed": 0,
  "results": [
    {
      "localId": "IMG_9981",
      "serverId": 12345,
      "category": "FINANCE",
      "status": "SUCCESS"
    }
  ]
}
```

**서버 처리 로직:**
1. 각 스크린샷에 대해 카테고리 자동 분류
2. `user_id + local_id` 기준 Upsert
3. 분류된 카테고리와 서버 ID 반환

---

### 2.3 스크린샷 조회 API

#### GET `/api/screenshots`
스크린샷 목록 조회 (페이지네이션)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|---|---|---|---|
| `category` | String | N | FINANCE, SHOPPING, SCHEDULE, HUMOR, OTHER |
| `page` | Integer | N | 페이지 번호 (기본: 0) |
| `size` | Integer | N | 페이지 크기 (기본: 30, 최대: 100) |
| `sort` | String | N | capturedAt,desc (기본) |

**Response (200):**
```json
{
  "content": [
    {
      "id": 12345,
      "localId": "IMG_9981",
      "fullText": "스타벅스 아메리카노 4,500원 결제 완료",
      "category": "FINANCE",
      "capturedAt": "2026-01-08T10:30:00Z",
      "isFavorite": false
    }
  ],
  "page": 0,
  "size": 30,
  "totalElements": 150,
  "totalPages": 5
}
```

---

### 2.4 검색 API

#### GET `/api/screenshots/search`
텍스트 검색 (Full-Text Search)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|---|---|---|---|
| `q` | String | Y | 검색어 (최소 2자) |
| `category` | String | N | 카테고리 필터 |
| `page` | Integer | N | 페이지 번호 |
| `size` | Integer | N | 페이지 크기 (기본: 50) |

**Response (200):**
```json
{
  "content": [
    {
      "id": 12345,
      "localId": "IMG_9981",
      "fullText": "스타벅스 아메리카노 4,500원 결제 완료",
      "matchedText": "스타벅스",
      "blocks": [...],
      "category": "FINANCE",
      "capturedAt": "2026-01-08T10:30:00Z"
    }
  ],
  "query": "스타벅스",
  "totalElements": 5
}
```

**성능 요구사항:**
- 응답 시간: 200ms 이내
- Full-Text Index 활용

---

### 2.5 스크린샷 수정 API

#### PATCH `/api/screenshots/{id}`
스크린샷 정보 수정 (삭제, 즐겨찾기)

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "isDeleted": true,
  "isFavorite": false
}
```

**Response (200):**
```json
{
  "id": 12345,
  "localId": "IMG_9981",
  "isDeleted": true,
  "isFavorite": false,
  "updatedAt": "2026-01-08T12:00:00Z"
}
```

---

### 2.6 통계 API

#### GET `/api/stats`
카테고리별 통계

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200):**
```json
{
  "total": 150,
  "categories": {
    "FINANCE": 45,
    "SHOPPING": 38,
    "SCHEDULE": 22,
    "HUMOR": 15,
    "OTHER": 30
  },
  "thisMonth": {
    "added": 25,
    "deleted": 5
  }
}
```

---

## 3. 데이터베이스

### 3.1 테이블 스키마

```sql
-- users 테이블
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    provider VARCHAR(50) NOT NULL,
    provider_id VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    profile_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (provider, provider_id)
);

-- screenshot_metadata 테이블
CREATE TABLE screenshot_metadata (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    local_id VARCHAR(255) NOT NULL,
    full_text TEXT,
    ocr_json JSONB,
    category VARCHAR(50) DEFAULT 'OTHER',
    captured_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_id, local_id)
);

-- Full-Text Search 인덱스 (PostgreSQL)
CREATE INDEX idx_screenshot_fulltext
ON screenshot_metadata
USING GIN (to_tsvector('simple', full_text));

-- 복합 인덱스
CREATE INDEX idx_user_category_captured
ON screenshot_metadata (user_id, category, captured_at DESC);
```

### 3.2 카테고리 Enum

```java
public enum Category {
    FINANCE,    // 금융
    SHOPPING,   // 쇼핑
    SCHEDULE,   // 일정
    HUMOR,      // 유머
    OTHER       // 기타
}
```

---

## 4. 핵심 로직

### 4.1 카테고리 자동 분류

```java
@Service
public class CategoryClassifier {

    private static final Map<Category, List<String>> KEYWORDS = Map.of(
        Category.FINANCE, List.of("입금", "출금", "잔액", "이체", "계좌", "결제", "카드", "은행"),
        Category.SHOPPING, List.of("배송", "장바구니", "주문", "결제완료", "쿠팡", "배민", "배달"),
        Category.SCHEDULE, List.of("초대", "약속", "예약", "월", "일", "시", "분"),
        Category.HUMOR, List.of("ㅋㅋ", "ㅎㅎ", "ㅠㅠ", "ㅜㅜ", "짤", "밈")
    );

    public Category classify(String text) {
        String lowerText = text.toLowerCase();

        for (Map.Entry<Category, List<String>> entry : KEYWORDS.entrySet()) {
            for (String keyword : entry.getValue()) {
                if (lowerText.contains(keyword)) {
                    return entry.getKey();
                }
            }
        }

        return Category.OTHER;
    }
}
```

### 4.2 JWT 설정

```java
@Configuration
public class JwtConfig {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.access-token-expiration}")
    private long accessTokenExpiration = 3600000; // 1시간

    @Value("${jwt.refresh-token-expiration}")
    private long refreshTokenExpiration = 604800000; // 7일
}
```

### 4.3 Full-Text Search (PostgreSQL)

```java
@Repository
public interface ScreenshotRepository extends JpaRepository<Screenshot, Long> {

    @Query(value = """
        SELECT * FROM screenshot_metadata
        WHERE user_id = :userId
          AND is_deleted = FALSE
          AND to_tsvector('simple', full_text) @@ plainto_tsquery('simple', :query)
        ORDER BY captured_at DESC
        LIMIT :limit OFFSET :offset
        """, nativeQuery = true)
    List<Screenshot> searchByText(
        @Param("userId") Long userId,
        @Param("query") String query,
        @Param("limit") int limit,
        @Param("offset") int offset
    );
}
```

---

## 5. 보안

### 5.1 인증 흐름

```
1. 클라이언트: Google/Apple 로그인 → ID Token 획득
2. 클라이언트 → 서버: POST /api/auth/google {idToken}
3. 서버: Google API로 ID Token 검증
4. 서버: users 테이블에 Upsert
5. 서버 → 클라이언트: JWT (Access + Refresh Token) 발급
6. 클라이언트: Authorization: Bearer {accessToken} 헤더 사용
```

### 5.2 보안 체크리스트

- [ ] HTTPS 필수
- [ ] JWT Secret Key 환경변수로 관리
- [ ] Rate Limiting (분당 60회)
- [ ] SQL Injection 방지 (JPA Parameterized Query)
- [ ] CORS 설정
- [ ] 민감정보 로깅 금지

---

## 6. 에러 코드

| Code | HTTP Status | Description |
|---|---|---|
| `AUTH_001` | 401 | 토큰 없음 |
| `AUTH_002` | 401 | 토큰 만료 |
| `AUTH_003` | 401 | 유효하지 않은 토큰 |
| `AUTH_004` | 401 | 소셜 로그인 실패 |
| `SYNC_001` | 400 | 동기화 데이터 형식 오류 |
| `SEARCH_001` | 400 | 검색어 최소 길이 미달 |
| `NOT_FOUND` | 404 | 리소스 없음 |
| `SERVER_ERROR` | 500 | 서버 내부 오류 |

**에러 응답 형식:**
```json
{
  "code": "AUTH_002",
  "message": "토큰이 만료되었습니다.",
  "timestamp": "2026-01-08T12:00:00Z"
}
```

---

## 7. 배포 환경

### 7.1 환경 변수

```properties
# application.yml
spring:
  datasource:
    url: ${DATABASE_URL}
    username: ${DATABASE_USERNAME}
    password: ${DATABASE_PASSWORD}

jwt:
  secret: ${JWT_SECRET}
  access-token-expiration: 3600000
  refresh-token-expiration: 604800000

google:
  client-id: ${GOOGLE_CLIENT_ID}

apple:
  team-id: ${APPLE_TEAM_ID}
  key-id: ${APPLE_KEY_ID}
  private-key: ${APPLE_PRIVATE_KEY}
```

### 7.2 추천 인프라

| 항목 | 추천 |
|---|---|
| **서버** | AWS EC2 / ECS / Lambda |
| **DB** | AWS RDS PostgreSQL |
| **캐시** | Redis (선택) |
| **로드밸런서** | AWS ALB |
| **모니터링** | CloudWatch / Datadog |

---

## 8. 개발 우선순위

### Phase 1 (MVP)
1. ✅ 소셜 로그인 (Google)
2. ✅ JWT 인증
3. ✅ 동기화 API (`POST /api/sync`)
4. ✅ 카테고리 자동 분류
5. ✅ 목록 조회 API
6. ✅ 검색 API

### Phase 2
1. Apple 로그인
2. 삭제/즐겨찾기 API
3. 통계 API

### Phase 3
1. Rate Limiting
2. 캐싱 (Redis)
3. 성능 최적화

---

## 9. 참고 문서

- [04-FEATURE_SPEC.md](./04-FEATURE_SPEC.md) - 기능 명세서
- [06-DB_SCHEMA.md](./06-DB_SCHEMA.md) - DB 스키마
- [07-AUTH_SECURITY.md](./07-AUTH_SECURITY.md) - 인증/보안
