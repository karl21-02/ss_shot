# SS-Shot 개발 진행 상황

> 마누스(Manus) 패턴 기반 진행 상황 추적 체크리스트

---

## 현재 상태

- **시작일:** 2026-01-08
- **마지막 업데이트:** 2026-01-08
- **현재 단계:** Phase 2 완료

---

## 문서화 Phase (완료)

- [x] `notes.md` 생성 - PRD 원본 컨텍스트 저장
- [x] `task_plan.md` 생성 - 진행 상황 체크리스트
- [x] `docs/` 폴더 및 8개 문서 생성
- [x] `RULE.md` 생성 - Claude Code용 시스템 지침
- [x] `LOGGING.md` 생성 - 로깅 표준 가이드
- [x] `09-SERVER_REQUIREMENTS.md` 생성 - 서버 구현 명세

---

## Phase 1: 기반 구축 (완료)

### Flutter 프로젝트 세팅
- [x] MVVM 아키텍처 폴더 구조 생성
- [x] Android/iOS 권한 설정 (photo_manager)
- [x] 의존성 추가 (Riverpod, Drift, go_router 등)

### 갤러리 연동
- [x] `GalleryService` 구현 - photo_manager 기반
- [x] 스크린샷 앨범 자동 감지 (album-based)
- [x] Mock 데이터 모드 구현 (개발/테스트용)

### UI 기본 구성
- [x] `HomeScreen` 구현 - 그리드 뷰 레이아웃
- [x] `HomeViewModel` 구현 - Riverpod StateNotifier
- [x] 권한 없음/에러/로딩 상태 UI

---

## Phase 2: 코어 기능 연동 (완료)

### OCR 서비스
- [x] Google ML Kit 의존성 추가
- [x] `OcrService` 구현 - 한국어 텍스트 인식
- [x] `OcrResult` 모델 - JSON 직렬화 지원

### 로컬 DB
- [x] Drift 스키마 설계 (`Screenshots`, `PendingSync`)
- [x] CRUD 메서드 구현
- [x] Full-Text Search 쿼리 지원

### 카테고리 분류
- [x] `CategoryInfo` 모델 정의
- [x] 키워드 기반 자동 분류 로직 (`classifyText`)
- [x] 카테고리: 금융, 쇼핑, 일정, 유머, 기타

### 검색 기능
- [x] 검색바 UI (AppBar 토글)
- [x] 실시간 검색 필터링
- [x] 카테고리 탭 필터링

---

## Phase 3: 서버 연동 (진행 예정)

### 인증
- [ ] Google 소셜 로그인 연동
- [ ] Apple 소셜 로그인 연동
- [ ] JWT 토큰 관리 (저장, 갱신)

### 동기화
- [ ] `SyncService` 구현
- [ ] POST `/api/sync` 호출
- [ ] 오프라인 큐 처리 (`PendingSync`)

### API 연동
- [ ] Dio HTTP 클라이언트 설정
- [ ] 인터셉터 (토큰 주입, 에러 핸들링)
- [ ] 서버 검색 API 연동

---

## Phase 4: 고도화 (진행 예정)

### 스마트 액션
- [ ] URL 추출 및 열기
- [ ] 계좌번호 복사
- [ ] 캘린더 일정 등록

### UI/UX 개선
- [ ] 상세 화면 (검색 하이라이팅)
- [ ] Swipe-to-Clean 정리 모드
- [ ] 애니메이션 및 폴리싱

---

## 서버 (Spring Boot) 구현 상태

> 상세: [09-SERVER_REQUIREMENTS.md](./docs/09-SERVER_REQUIREMENTS.md)

### MVP (P0)
- [ ] POST `/api/auth/google` - Google 로그인
- [ ] POST `/api/auth/apple` - Apple 로그인
- [ ] POST `/api/auth/refresh` - 토큰 갱신
- [ ] POST `/api/sync` - 메타데이터 동기화
- [ ] GET `/api/screenshots` - 목록 조회
- [ ] GET `/api/screenshots/search` - 텍스트 검색

### 추가 기능 (P1/P2)
- [ ] PATCH `/api/screenshots/{id}` - 수정/삭제
- [ ] GET `/api/stats` - 통계

---

## 작업 로그

| 날짜 | 작업 내용 | 상태 |
| --- | --- | --- |
| 2026-01-08 | 문서화 (docs/ 8개 문서) | 완료 |
| 2026-01-08 | Phase 1: 갤러리 연동, Mock 모드 | 완료 |
| 2026-01-08 | Phase 2: OCR 서비스, Drift DB | 완료 |
| 2026-01-08 | Phase 2: 검색바, 카테고리 탭 | 완료 |
| 2026-01-08 | 서버 요구사항 문서 생성 | 완료 |

---

## 프로젝트 구조

```
ss_shot/
├── RULE.md                        # Claude Code 시스템 지침
├── notes.md                       # PRD 원본 컨텍스트
├── task_plan.md                   # 진행 상황 체크리스트 (현재 파일)
├── docs/
│   ├── README.md                  # 문서 목록
│   ├── 01~08-*.md                 # 설계 문서
│   ├── 09-SERVER_REQUIREMENTS.md  # 서버 구현 명세
│   └── LOGGING.md                 # 로깅 표준
└── lib/
    ├── core/
    │   ├── constants/
    │   │   ├── app_strings.dart
    │   │   └── categories.dart    # 카테고리 분류
    │   └── utils/
    │       └── logger.dart        # 로깅 유틸리티
    ├── data/
    │   ├── datasources/local/
    │   │   └── app_database.dart  # Drift DB
    │   └── models/
    │       ├── mock_screenshot.dart
    │       └── ocr_result.dart    # OCR 결과 모델
    ├── presentation/
    │   ├── view_models/
    │   │   └── home_view_model.dart
    │   ├── views/home/
    │   │   └── home_screen.dart
    │   └── widgets/
    │       └── screenshot_grid_item.dart
    └── services/
        ├── gallery_service.dart   # 갤러리 접근
        └── ocr_service.dart       # ML Kit OCR
```

---

## 다음 단계

Phase 3 서버 연동을 시작하려면:
1. Spring Boot 서버 구현 (09-SERVER_REQUIREMENTS.md 참고)
2. Flutter 클라이언트에 SyncService 추가
3. 인증 플로우 구현
