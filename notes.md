# SS-Shot PRD (Product Requirements Document)

> 이 문서는 Claude Code가 컨텍스트로 참조할 원본 기획서입니다.
> 마누스(Manus) 패턴의 `planning-with-files` 방식을 위해 작성되었습니다.

---

## 1. 프로젝트 정보

| **항목** | **내용** |
| --- | --- |
| **프로젝트 코드** | `SS-SHOT-2026` |
| **버전** | 3.0 (Final Release Spec) |
| **작성일** | 2026. 01. 08 |
| **상태** | 확정 (Approved) |
| **플랫폼** | Client: Flutter / Server: Spring Boot + AWS RDS |

---

## 2. 개요 (Executive Summary)

SS-Shot은 사용자의 갤러리에 방치된 수천 장의 스크린샷을 OCR(광학 문자 인식) 기술로 분석하여, **"검색 가능한 데이터"**로 변환해 주는 지능형 유틸리티 서비스입니다.

단순 보관을 넘어, 자동 카테고리 분류와 **게이미피케이션(Swipe-to-Clean)**을 통해 스크린샷 관리의 새로운 경험을 제공합니다.

### 2.1 핵심 가치 (Core Value)

1. **Find Instantly:** 텍스트 검색으로 0.1초 만에 이미지를 찾는다.
2. **Organize Automatically:** AI가 금융, 쇼핑, 일정 등으로 알아서 분류해 준다.
3. **Clean Fun:** 지루한 정리를 게임처럼 즐긴다.

---

## 3. 시스템 아키텍처 (System Architecture)

**Privacy-First Hybrid Architecture**를 채택합니다.

- **Client (Flutter):** 이미지 원본 보관, OCR 수행, UI/UX 제공.
- **Server (Spring Boot):** 텍스트 메타데이터 저장, 검색 엔진, 자동 분류 로직 수행.
- **Database (RDS):** 메타데이터 및 태그 정보 저장.

---

## 4. 데이터 처리 정책 (Data Policy)

1. **이미지 원본 (Binary):** **Only Local.** 사용자 기기에만 존재하며, 절대 서버로 전송하지 않는다. (보안 및 비용 최적화)
2. **메타 데이터 (Text/Tag):** **Cloud Sync.** OCR로 추출된 텍스트, 좌표값, 날짜 정보는 서버(RDS)에 저장한다.
3. **데이터 무결성:** 로컬 갤러리에서 이미지가 삭제되면, 차후 동기화 시 서버의 메타 데이터도 삭제(Soft Delete) 처리한다.

### 4.1 인증 정책

- **소셜 로그인 필수:** 복잡한 가입 절차 없이 **Google Sign-In** 및 **Apple Sign-In**을 지원한다. (사용자 경험 최적화)
- **JWT 기반 인증:**
    - 로그인 성공 시 서버로부터 `Access Token`(유효 1시간)과 `Refresh Token`(유효 14일)을 발급받는다.
    - 모든 API 요청 헤더(`Authorization`)에 토큰을 포함해야 한다.
- **데이터 격리:** 사용자의 모든 데이터(스크린샷, 태그 등)는 `user_id`를 기준으로 논리적으로 완벽하게 분리되어야 한다.

---

## 5. 상세 기능 명세 (Detailed Functional Specifications)

### 5.1 Module A: 코어 엔진 (Sync & Analysis)

앱의 심장부입니다. 갤러리 접근부터 서버 동기화까지의 과정을 담당합니다.

| **ID** | **기능명** | **상세 설명 및 로직** | **우선순위** |
| --- | --- | --- | --- |
| **A-01** | **지능형 스캔** | 앱 실행 시 `PhotoManager`로 'Screenshots' 앨범 로드. `LastSyncedTime` 이후 생성된 이미지만 필터링하여 스캔 대기열(Queue)에 등록. | **P0** |
| **A-02** | **On-Device OCR** | Google ML Kit를 사용하여 이미지 내 텍스트 및 좌표(Rect) 추출. **정책:** 개인정보 보호 및 서버 비용 절감을 위해 이미지는 서버로 보내지 않음. | **P0** |
| **A-03** | **메타데이터 동기화** | 추출된 텍스트, 로컬 ID, 날짜 정보를 JSON으로 직렬화하여 서버(`/api/sync`)로 전송. 네트워크 실패 시 로컬 DB에 임시 저장 후 재시도(Retry) 로직 적용. | **P0** |

### 5.2 Module B: 스마트 분류 및 검색 (Intelligence)

| **ID** | **기능명** | **상세 설명 및 로직** | **우선순위** |
| --- | --- | --- | --- |
| **B-01** | **자동 카테고리 분류** | **(Server Side)** 전송받은 텍스트 내 키워드를 분석하여 태그 부여. Rule 예시: `입금`, `원`, `잔액` → **[금융]** / `배송`, `장바구니`, `주문` → **[쇼핑]** / `초대`, `약속`, `PM/AM` → **[일정]** / 분류 불가 시 `[기타]`로 처리. | **P0** |
| **B-02** | **초고속 검색** | 검색어 입력 시 서버 API 호출 → `Full-Text Indexing`된 DB에서 결과 조회. 결과 클릭 시 해당 로컬 이미지로 이동. | **P0** |
| **B-03** | **카테고리 탭** | 홈 화면 상단에 `전체`, `금융`, `쇼핑`, `일정`, `기타` 탭 바(Tab Bar) 제공. 탭 터치 시 해당 카테고리 아이템만 필터링하여 노출. | **P0** |
| **B-04** | **소비 리포트** | (재미 요소) "이번 달은 **쇼핑** 스샷을 제일 많이 찍으셨네요!" 같은 인사이트 문구 카드 노출. | P2 |

### 5.3 Module C: 뷰어 및 스마트 액션 (Viewer & Action)

| **ID** | **기능명** | **상세 설명 및 로직** | **우선순위** |
| --- | --- | --- | --- |
| **C-01** | **스마트 액션 버튼** | **(Client Side)** OCR 텍스트를 정규식(Regex)으로 실시간 분석. `URL` 발견 → **[웹으로 열기]** / `계좌번호` 발견 → **[복사]** / `날짜` 발견 → **[캘린더 등록]** | **P1** |
| **C-02** | **하이라이팅** | 검색 결과로 진입 시, 이미지 위 해당 텍스트 위치에 **노란색 반투명 박스** 오버레이 표시. 2초 후 서서히 사라짐 (Fade-out). | P1 |
| **C-03** | **보안 블러(Blur)** | `금액`이나 `주민번호` 패턴 위치에 자동으로 흐림 효과 적용. 터치하고 있을 때만 원본 노출. | P2 |

### 5.4 Module D: 정리 및 관리 (Gamification)

| **ID** | **기능명** | **상세 설명 및 로직** | **우선순위** |
| --- | --- | --- | --- |
| **D-01** | **스샷 정리 모드** | 카드 스택 UI (Tinder 스타일) 진입. 화면 중앙에 스크린샷을 크게 띄움. | **P1** |
| **D-02** | **Swipe-to-Clean** | **왼쪽 스와이프:** 삭제 (휴지통 이동). **오른쪽 스와이프:** 보관 (Keep). 스와이프 시 햅틱 피드백(진동) 및 효과음 제공. | **P1** |
| **D-03** | **동기화 삭제** | 앱에서 삭제된 이미지는 서버에도 `is_deleted = true` 상태 전송 (Soft Delete). | **P1** |

---

## 6. 스마트 액션 정규식 정의

| **타입** | **감지 대상** | **정규식 (Regex)** | **액션** |
| --- | --- | --- | --- |
| **URL** | 웹사이트 링크 | `(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)` | **[웹사이트 열기]** |
| **BANK** | 계좌번호 | `([0-9,\-]{3,6}\-[0-9,\-]{2,6}\-[0-9,\-]*)` | **[복사]** |
| **DATE** | 날짜/일정 | `(\d{1,2}월\s\d{1,2}일)\|(\d{4}.\d{1,2}.\d{1,2})` | **[캘린더 등록]** |
| **CODE** | 인증번호 | `인증번호.*(\d{4,6})\|code.*(\d{4,6})` | **[인증번호 복사]** |

---

## 7. 갤러리 스캔 및 동기화 로직

### 7.1 Trigger (작동 시점)
- 앱 실행(Foreground 진입) 시
- 사용자가 '당겨서 새로고침(Pull-to-refresh)' 시

### 7.2 Logic (처리 순서)
1. `PhotoManager`를 통해 디바이스 내 `Screenshots` 앨범의 전체 **Asset ID 리스트**를 가져온다.
2. 로컬 `SharedPreferences`에 저장된 **'Last Synced Timestamp'** 이후 생성된 이미지만 필터링한다.
3. **[OCR 프로세스]**
   - 대상 이미지를 Google ML Kit로 분석
   - 텍스트(`text`)와 **좌표값(`boundingbox`)** 추출 (좌표값은 추후 하이라이팅 기능을 위해 필수 저장)
4. **[서버 전송]**
   - 추출된 데이터를 JSON으로 직렬화하여 Spring Boot 서버로 전송
   - 전송 데이터 예시: `{ "localId": "IMG_9981", "fullText": "계좌 110-...", "blocks": [{"text": "110-...", "rect": [10, 20, 100, 50]}] }`

### 7.3 Exception (예외 처리)
- **네트워크 불가:** 실패한 요청은 로컬 DB(Drift)의 `PendingQueue` 테이블에 저장 후, 네트워크 복구 시 재전송.

---

## 8. 검색 및 하이라이팅 로직

### 8.1 검색 로직 (Server Side)
1. 사용자 입력어(예: "스타벅스") 수신
2. RDS에서 `MATCH(ocr_content) AGAINST('스타벅스')` 쿼리 실행
3. 결과값으로 `localId`와 함께 **`blocks` (좌표 정보 JSON)** 반환

### 8.2 하이라이팅 로직 (Client Side)
1. 서버에서 받은 `localId`로 로컬 갤러리 이미지를 로딩
2. 이미지 위에 투명한 `Stack` 위젯을 올림
3. 서버에서 받은 `blocks` 좌표(`left`, `top`, `width`, `height`)에 맞춰 **노란색 반투명 박스 (`Colors.yellow.withOpacity(0.3)`)** 렌더링

### 8.3 UX Detail
- 검색 결과 클릭 시, 상세 화면으로 이동하며 자동으로 **해당 좌표로 줌인(Zoom-in)** 애니메이션 실행

---

## 9. UI/UX 화면 상세

### 9.1 홈 화면 (Home Screen)

**Structure (Layout):** `CustomScrollView` + `Slivers` 조합

1. **Search Bar (Top):** 상단 고정. "어떤 정보를 찾으세요?" 힌트 텍스트
2. **Insight Banner:** (스크롤 가능) "이번 주 쇼핑 스샷이 15장 늘었어요!" 같은 텍스트와 그래프가 있는 카드
3. **Category Tabs (Sticky):** 스크롤 시 상단에 붙는 탭바 (`SliverPersistentHeader`). `전체`, `금융`, `쇼핑`, `일정`, `유머`, `기타`
4. **Gallery Grid:** 3열 그리드 (`SliverGrid`)
5. **FAB (Floating Action Button):** 우측 하단에 **"정리하기"** (빗자루 아이콘) 버튼 고정

**States (상태값):**
- **Syncing:** 그리드 최상단에 `LinearProgressIndicator`가 얇게 지나감 (동기화 중 표시)
- **Filter Empty:** 특정 카테고리 선택 시 데이터가 없으면 "이런, 돈 쓴 기록이 없네요?" 문구 노출

**Item Components (썸네일):**
- **Cloud Icon:** 우측 하단
  - ☁️ (회색): 분석 대기 (Local Only)
  - ✅ (파란색): 분석 완료 (Server Synced)
  - ⚠️ (빨간색): 업로드 실패 (재시도 필요)
- **Price Tag:** 쇼핑 카테고리일 경우, OCR로 추출된 가격이 썸네일 좌측 상단에 반투명 칩으로 표시

### 9.2 상세 뷰어 (Detail Viewer)

**Navigation Bar (AppBar):**
- **Title:** 현재 분류된 카테고리 표시 (예: `쇼핑` ▾). 터치 시 카테고리 수동 변경 팝업 노출
- **Actions:** `공유`, `즐겨찾기`, `삭제(휴지통)` 아이콘

**Main Area:**
- **Interactive Viewer:** 핀치 줌(Pinch-to-Zoom) 및 더블 탭 확대 지원
- **Search Highlight:** 검색을 통해 진입했을 경우, 검색 키워드 위치에 **노란색 박스** 오버레이. 2초 뒤 페이드 아웃
- **Text Selection:** 이미지 위 텍스트를 길게 누르면(Long Press), 단어 단위로 선택 블록이 잡히며 시스템 복사 메뉴 호출

**Smart Action Bar (Bottom Sheet):**
- 화면 하단에 **감지된 정보에 따라 가변적으로 변하는** 버튼 영역 (없으면 숨김)
- **Case 1 (계좌번호 감지):** `[계좌 복사]` (Primary) + `[카카오뱅크 열기]` (Sub)
- **Case 2 (URL 감지):** `[사이트 방문]` (Primary) + `[링크 복사]` (Sub)
- **Case 3 (날짜 감지):** `[캘린더 등록]` (Primary) + 감지된 날짜 텍스트 표시

### 9.3 정리 모드 (Swipe-to-Clean)

**Layout:** 배경은 어둡게(Dimmed), 중앙에는 카드 스택(`Stack` + `Draggable`) UI 배치

**Interaction (Gesture):**
- **Swipe Left (삭제):** 카드를 왼쪽으로 던지면 화면에 `Trash` 아이콘이 커지며 붉은색 틴트 효과 → **휴지통으로 이동**
- **Swipe Right (보관):** 카드를 오른쪽으로 던지면 화면에 `Keep` 아이콘이 커지며 초록색 틴트 효과 → **보관함 유지**

**Feedback:**
- **Haptic:** 카드 넘길 때마다 `HapticFeedback.lightImpact` 진동 발생
- **Counter:** 상단에 `오늘 정리한 장수: 12장` 카운터가 실시간으로 올라감

**Empty State (완료):**
- 모든 카드를 넘기면 폭죽 애니메이션(Lottie)과 함께 "오늘의 정리 끝! 갤러리가 가벼워졌어요." 문구 노출

---

## 10. 인증 기능 명세

| **ID** | **구분** | **기능명** | **상세 내용** | **우선순위** |
| --- | --- | --- | --- | --- |
| **AUTH-01** | 로그인 | **소셜 로그인** | 앱 최초 실행 시 [Google로 계속하기], [Apple로 계속하기] 버튼 노출. OAuth 2.0 흐름을 통해 `id_token` 획득 후 백엔드로 전송. | **P0** |
| **AUTH-02** | 회원가입 | **자동 가입** | 백엔드는 소셜 로그인 요청 수신 시, `email` 존재 여부 확인. 신규 유저라면 `users` 테이블에 자동 INSERT 후 토큰 발급. (별도 가입 폼 없음) | **P0** |
| **AUTH-03** | 보안 | **토큰 저장** | 발급받은 JWT는 기기 내 안전한 저장소(`FlutterSecureStorage`)에 암호화하여 저장. | **P0** |
| **AUTH-04** | 세션 | **자동 갱신** | API 호출 시 `401 Unauthorized` 발생하면, `Refresh Token`으로 토큰 재발급 요청(Silent Refresh). | **P1** |

---

## 11. 백엔드 데이터 모델링

### Table: `screenshot_metadata`

| **필드명** | **타입** | **제약조건** | **설명** |
| --- | --- | --- | --- |
| `id` | `BigInt` | `PK`, `Auto_Inc` | 내부 관리 ID |
| `user_id` | `BigInt` | `Index` | 소유자 |
| `local_id` | `Varchar(255)` | `Not Null` | 클라이언트 `AssetEntity.id` |
| `full_text` | `LongText` | `FullText Index` | 검색용 전체 텍스트 |
| `ocr_json` | `JSON` | `Null` 허용 | **좌표 데이터 저장용** (하이라이팅 구현 핵심) |
| `captured_at` | `DateTime` | `Index` | 정렬용 (최신순) |

**`ocr_json` 저장 예시:**
```json
[
  {"text": "스타벅스", "rect": {"x": 100, "y": 200, "w": 50, "h": 20}},
  {"text": "아메리카노", "rect": {"x": 100, "y": 240, "w": 80, "h": 20}}
]
```

---

## 12. 비기능 요구사항 (Non-Functional Requirements)

- **성능 (Performance):**
  - 스크롤 시 프레임 드랍 없이 60fps 유지 (이미지 캐싱 필수)
  - 검색 결과 반환 속도 200ms 이내
- **보안 (Security):**
  - 모든 API 통신은 HTTPS 암호화
  - 사용자 비밀번호는 BCrypt 해싱 저장
  - 이미지 원본은 서버에 저장하지 않음 (Privacy Policy 명시)

---

## 13. 개발 마일스톤 (Milestones)

1. **Phase 1 (기반 구축):** Spring Boot 프로젝트 세팅 + DB 설계 + Flutter 갤러리 연동
2. **Phase 2 (코어 연동):** ML Kit OCR 구현 + `/sync` API 개발 + 데이터 적재 확인
3. **Phase 3 (기능 구현):** 검색 API + 카테고리 자동 분류 로직 + 스마트 액션 UI
4. **Phase 4 (고도화):** 스와이프 정리 모드(UI) + 디자인 폴리싱
