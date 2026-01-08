# 03. 기술 스택 (Tech Stack)

> SS-Shot 개발에 사용되는 기술 스택 상세

---

## 1. 기술 스택 요약

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT                                   │
│  Flutter 3.x (Dart) + ML Kit OCR                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS + JWT
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         SERVER                                   │
│  Spring Boot 3.x (Java 17) + Spring Security                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ JDBC
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATABASE                                  │
│  AWS RDS MySQL 8.x + Full-Text Index                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Client (Flutter)

### 2.1 Core Framework

| 기술 | 버전 | 용도 |
| --- | --- | --- |
| **Flutter** | 3.x | 크로스 플랫폼 UI 프레임워크 |
| **Dart** | 3.x | 프로그래밍 언어 |

### 2.2 주요 패키지

| 패키지 | 용도 | 설명 |
| --- | --- | --- |
| **photo_manager** | 갤러리 접근 | iOS/Android 갤러리 통합 API |
| **google_ml_kit** | On-Device OCR | 텍스트 인식 및 좌표 추출 |
| **drift** | 로컬 DB | SQLite 래퍼, PendingQueue 저장 |
| **flutter_secure_storage** | 보안 저장소 | JWT 토큰 암호화 저장 |
| **dio** | HTTP 클라이언트 | API 통신, 인터셉터 지원 |
| **flutter_riverpod** | 상태 관리 | 의존성 주입, 리액티브 상태 |
| **go_router** | 라우팅 | 선언적 라우팅, Deep Link |
| **cached_network_image** | 이미지 캐싱 | 썸네일 캐싱 (성능 최적화) |
| **lottie** | 애니메이션 | 정리 완료 폭죽 등 |

### 2.3 pubspec.yaml 예시

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 갤러리 접근
  photo_manager: ^3.0.0

  # OCR
  google_ml_kit: ^0.16.0

  # 로컬 DB
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0

  # 보안 저장소
  flutter_secure_storage: ^9.0.0

  # HTTP
  dio: ^5.4.0

  # 상태 관리
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # 라우팅
  go_router: ^13.0.0

  # 소셜 로그인
  google_sign_in: ^6.2.0
  sign_in_with_apple: ^5.0.0

  # UI/UX
  cached_network_image: ^3.3.0
  lottie: ^3.0.0
  flutter_swipe_action_cell: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  drift_dev: ^2.14.0
  riverpod_generator: ^2.3.0
```

---

## 3. Server (Spring Boot)

### 3.1 Core Framework

| 기술 | 버전 | 용도 |
| --- | --- | --- |
| **Spring Boot** | 3.2.x | 백엔드 프레임워크 |
| **Java** | 17 (LTS) | 프로그래밍 언어 |
| **Gradle** | 8.x | 빌드 도구 |

### 3.2 주요 의존성

| 라이브러리 | 용도 | 설명 |
| --- | --- | --- |
| **Spring Web** | REST API | MVC, JSON 처리 |
| **Spring Security** | 인증/인가 | JWT 필터, OAuth2 |
| **Spring Data JPA** | ORM | 엔티티 매핑, Repository |
| **jjwt** | JWT 처리 | 토큰 생성/검증 |
| **MySQL Connector** | DB 연결 | JDBC 드라이버 |
| **Lombok** | 보일러플레이트 감소 | Getter/Setter 자동 생성 |
| **MapStruct** | DTO 매핑 | Entity ↔ DTO 변환 |

### 3.3 build.gradle 예시

```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
}

java {
    sourceCompatibility = '17'
}

dependencies {
    // Spring Boot Starters
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-validation'

    // JWT
    implementation 'io.jsonwebtoken:jjwt-api:0.12.3'
    runtimeOnly 'io.jsonwebtoken:jjwt-impl:0.12.3'
    runtimeOnly 'io.jsonwebtoken:jjwt-jackson:0.12.3'

    // Database
    runtimeOnly 'com.mysql:mysql-connector-j'

    // Utility
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    implementation 'org.mapstruct:mapstruct:1.5.5.Final'
    annotationProcessor 'org.mapstruct:mapstruct-processor:1.5.5.Final'

    // Test
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
}
```

---

## 4. Database (AWS RDS)

### 4.1 데이터베이스 사양

| 항목 | 설정 |
| --- | --- |
| **Engine** | MySQL 8.0 |
| **Instance** | db.t3.micro (개발) / db.t3.small (운영) |
| **Storage** | 20GB gp3 SSD |
| **Multi-AZ** | No (MVP) / Yes (운영) |
| **Backup** | 7일 자동 백업 |

### 4.2 Full-Text Index 설정

```sql
-- 테이블 생성 시 Full-Text Index 포함
CREATE TABLE screenshot_metadata (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    local_id VARCHAR(255) NOT NULL,
    full_text LONGTEXT,
    ocr_json JSON,
    category VARCHAR(50),
    captured_at DATETIME,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FULLTEXT INDEX ft_full_text (full_text),
    INDEX idx_user_category (user_id, category, captured_at DESC)
);

-- Full-Text 검색 쿼리 예시
SELECT * FROM screenshot_metadata
WHERE user_id = 1
  AND MATCH(full_text) AGAINST('스타벅스' IN NATURAL LANGUAGE MODE);
```

---

## 5. Infrastructure (AWS)

### 5.1 구성도

```
┌─────────────────────────────────────────────────────────────────┐
│                         AWS Cloud                                │
│                                                                  │
│  ┌──────────────┐                                               │
│  │   Route 53   │ ─── api.ss-shot.com                           │
│  └──────────────┘                                               │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────┐                                               │
│  │     ACM      │ ─── SSL/TLS 인증서                            │
│  └──────────────┘                                               │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────┐     ┌──────────────┐                          │
│  │     EC2      │────▶│     RDS      │                          │
│  │ (Spring Boot)│     │   (MySQL)    │                          │
│  └──────────────┘     └──────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 서비스별 사양

| 서비스 | 사양 (개발) | 사양 (운영) |
| --- | --- | --- |
| **EC2** | t3.micro | t3.small |
| **RDS** | db.t3.micro | db.t3.small |
| **Route 53** | 호스팅 영역 1개 | 동일 |
| **ACM** | 무료 SSL 인증서 | 동일 |

---

## 6. 개발 도구

### 6.1 IDE

| 용도 | 도구 |
| --- | --- |
| **Flutter** | Android Studio / VS Code |
| **Spring Boot** | IntelliJ IDEA |
| **Database** | DataGrip / DBeaver |

### 6.2 협업 도구

| 용도 | 도구 |
| --- | --- |
| **버전 관리** | Git + GitHub |
| **API 문서** | Swagger (Springdoc) |
| **디자인** | Figma |

### 6.3 모니터링

| 용도 | 도구 |
| --- | --- |
| **앱 분석** | Firebase Analytics |
| **크래시 리포트** | Firebase Crashlytics |
| **서버 로그** | AWS CloudWatch |

---

## 7. 참고 문서

- [02-ARCHITECTURE.md](./02-ARCHITECTURE.md) - 시스템 아키텍처
- [08-DEVELOPMENT_GUIDE.md](./08-DEVELOPMENT_GUIDE.md) - 개발 가이드
