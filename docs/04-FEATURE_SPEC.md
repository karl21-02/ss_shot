# 04. 기능 명세서 (Feature Specification)

> 모듈별 상세 기능 명세 및 우선순위

---

## 1. 기능 우선순위 정의

| 레벨 | 의미 | 설명 |
| --- | --- | --- |
| **P0** | 필수 | MVP 출시에 반드시 필요한 핵심 기능 |
| **P1** | 중요 | 사용자 경험 향상에 중요한 기능 |
| **P2** | 나중 | 향후 버전에서 구현 가능한 기능 |

---

## 2. Module A: 코어 엔진 (Sync & Analysis)

앱의 심장부입니다. 갤러리 접근부터 서버 동기화까지 담당합니다.

### A-01: 지능형 스캔

| 항목 | 내용 |
| --- | --- |
| **ID** | A-01 |
| **기능명** | 지능형 스캔 |
| **우선순위** | **P0** |

**Trigger (작동 시점):**
- 앱 실행 (Foreground 진입) 시
- 사용자가 '당겨서 새로고침 (Pull-to-refresh)' 시

**Logic (처리 순서):**
1. `PhotoManager`를 통해 디바이스 내 `Screenshots` 앨범의 전체 Asset ID 리스트를 가져온다.
2. 로컬 `SharedPreferences`에 저장된 'Last Synced Timestamp' 이후 생성된 이미지만 필터링한다.
3. 필터링된 이미지 수를 UI에 표시한다. ("12개의 새 스크린샷 발견")

**Exception (예외 처리):**
- 갤러리 권한 거부 시: 권한 요청 다이얼로그 표시
- Screenshots 앨범 없음: 빈 상태 UI 표시

---

### A-02: On-Device OCR

| 항목 | 내용 |
| --- | --- |
| **ID** | A-02 |
| **기능명** | On-Device OCR |
| **우선순위** | **P0** |

**Logic (처리 순서):**
1. 대상 이미지를 Google ML Kit로 전달
2. `TextRecognizer.processImage()` 호출
3. 인식된 텍스트 블록 (`TextBlock`) 순회
4. 각 블록에서 텍스트(`text`)와 좌표(`boundingBox`) 추출
5. 결과를 구조화된 객체로 변환

**Output 데이터 구조:**
```dart
class OcrResult {
  final String fullText;           // 전체 텍스트 (연결)
  final List<TextBlock> blocks;    // 개별 블록 리스트
}

class TextBlock {
  final String text;               // 블록 텍스트
  final Rect rect;                 // 좌표 (x, y, width, height)
}
```

**정책:**
- 개인정보 보호: 이미지 원본은 서버로 전송하지 않음
- 비용 절감: On-Device 처리로 서버 리소스 사용 안 함

---

### A-03: 메타데이터 동기화

| 항목 | 내용 |
| --- | --- |
| **ID** | A-03 |
| **기능명** | 메타데이터 동기화 |
| **우선순위** | **P0** |

**Logic (처리 순서):**
1. OCR 결과를 JSON으로 직렬화
2. 서버 `/api/sync` 엔드포인트로 POST 요청
3. 응답 성공 시: LastSyncedTimestamp 업데이트
4. 응답 실패 시: PendingQueue에 저장

**Request Payload:**
```json
{
  "screenshots": [
    {
      "localId": "IMG_9981",
      "fullText": "스타벅스 아메리카노 4,500원 결제 완료",
      "blocks": [
        {"text": "스타벅스", "rect": {"x": 100, "y": 200, "w": 80, "h": 25}}
      ],
      "capturedAt": "2026-01-08T10:30:00Z"
    }
  ]
}
```

**Exception (예외 처리):**
- 네트워크 불가: 로컬 DB (Drift)의 `PendingQueue` 테이블에 저장
- 네트워크 복구 시: WorkManager를 통해 백그라운드 재전송

---

## 3. Module B: 스마트 분류 및 검색 (Intelligence)

사용자가 데이터를 활용하는 핵심 기능입니다.

### B-01: 자동 카테고리 분류

| 항목 | 내용 |
| --- | --- |
| **ID** | B-01 |
| **기능명** | 자동 카테고리 분류 |
| **우선순위** | **P0** |
| **처리 위치** | Server Side |

**분류 규칙 (키워드 매칭):**

| 카테고리 | 키워드 예시 |
| --- | --- |
| **금융** | 입금, 출금, 잔액, 이체, 계좌, 원, 결제 |
| **쇼핑** | 배송, 장바구니, 주문, 결제완료, 쿠팡, 배민 |
| **일정** | 초대, 약속, PM, AM, 월, 일, 예약 |
| **유머** | ㅋㅋ, ㅎㅎ, ㅠㅠ, 짤, 밈 |
| **기타** | 위 분류에 해당하지 않는 경우 |

**Logic:**
```java
public Category classify(String text) {
    String lowerText = text.toLowerCase();

    if (containsAny(lowerText, "입금", "출금", "잔액", "이체", "계좌")) {
        return Category.FINANCE;
    }
    if (containsAny(lowerText, "배송", "장바구니", "주문", "결제완료")) {
        return Category.SHOPPING;
    }
    if (containsAny(lowerText, "초대", "약속", "예약") || containsTimePattern(lowerText)) {
        return Category.SCHEDULE;
    }
    if (containsAny(lowerText, "ㅋㅋ", "ㅎㅎ", "ㅠㅠ")) {
        return Category.HUMOR;
    }
    return Category.OTHER;
}
```

---

### B-02: 초고속 검색

| 항목 | 내용 |
| --- | --- |
| **ID** | B-02 |
| **기능명** | 초고속 검색 |
| **우선순위** | **P0** |

**Logic (처리 순서):**
1. 클라이언트: 검색어 입력 (300ms 디바운스 적용)
2. 서버: Full-Text Search 쿼리 실행
3. 결과 반환: localId, matchedText, blocks, category
4. 클라이언트: localId로 로컬 이미지 로드 후 표시

**Search Query:**
```sql
SELECT id, local_id, full_text, ocr_json, category, captured_at
FROM screenshot_metadata
WHERE user_id = :userId
  AND is_deleted = FALSE
  AND MATCH(full_text) AGAINST(:searchTerm IN NATURAL LANGUAGE MODE)
ORDER BY captured_at DESC
LIMIT 50;
```

**성능 목표:**
- 응답 시간: 200ms 이내
- 최대 결과: 50개 (페이지네이션)

---

### B-03: 카테고리 탭

| 항목 | 내용 |
| --- | --- |
| **ID** | B-03 |
| **기능명** | 카테고리 탭 |
| **우선순위** | **P0** |

**탭 목록:**
- 전체
- 금융
- 쇼핑
- 일정
- 유머
- 기타

**UI 동작:**
- 탭 터치 시 해당 카테고리로 필터링
- 스크롤 시 탭바 상단 고정 (SliverPersistentHeader)

---

### B-04: 소비 리포트

| 항목 | 내용 |
| --- | --- |
| **ID** | B-04 |
| **기능명** | 소비 리포트 |
| **우선순위** | **P2** |

**예시 문구:**
- "이번 달은 쇼핑 스샷을 제일 많이 찍으셨네요!"
- "금융 스크린샷이 15장 늘었어요"

---

## 4. Module C: 뷰어 및 스마트 액션 (Viewer & Action)

사용자 편의성을 극대화하는 UI 기능입니다.

### C-01: 스마트 액션 버튼

| 항목 | 내용 |
| --- | --- |
| **ID** | C-01 |
| **기능명** | 스마트 액션 버튼 |
| **우선순위** | **P1** |
| **처리 위치** | Client Side |

**정규식 패턴:**

| 타입 | 정규식 | 액션 |
| --- | --- | --- |
| **URL** | `(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)` | 웹사이트 열기 |
| **계좌번호** | `([0-9,\-]{3,6}\-[0-9,\-]{2,6}\-[0-9,\-]*)` | 복사 |
| **날짜** | `(\d{1,2}월\s?\d{1,2}일)\|(\d{4}[.\-/]\d{1,2}[.\-/]\d{1,2})` | 캘린더 등록 |
| **인증번호** | `(인증번호\|code).*?(\d{4,6})` | 복사 |

**UI:**
- 상세 뷰어 하단에 감지된 액션 버튼 노출
- 버튼 없으면 영역 숨김

---

### C-02: 하이라이팅

| 항목 | 내용 |
| --- | --- |
| **ID** | C-02 |
| **기능명** | 하이라이팅 |
| **우선순위** | **P1** |

**Logic:**
1. 검색 결과 클릭 시 상세 뷰어 진입
2. 서버에서 받은 `blocks` 좌표 사용
3. 이미지 위에 Stack 위젯으로 노란색 반투명 박스 오버레이
4. 2초 후 Fade-out 애니메이션

**스타일:**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.yellow.withOpacity(0.3),
    borderRadius: BorderRadius.circular(4),
  ),
)
```

---

### C-03: 보안 블러

| 항목 | 내용 |
| --- | --- |
| **ID** | C-03 |
| **기능명** | 보안 블러 |
| **우선순위** | **P2** |

**대상 패턴:**
- 금액 (1,000원 이상)
- 계좌번호
- 주민번호 뒷자리

**동작:**
- 해당 위치에 `BackdropFilter` (blur) 적용
- Long Press 시에만 원본 노출

---

## 5. Module D: 정리 및 관리 (Gamification)

귀찮은 정리를 재미있게 만드는 기능입니다.

### D-01: 스샷 정리 모드

| 항목 | 내용 |
| --- | --- |
| **ID** | D-01 |
| **기능명** | 스샷 정리 모드 |
| **우선순위** | **P1** |

**진입 방법:**
- 홈 화면 FAB (빗자루 아이콘) 터치

**UI:**
- 전체 화면 모드
- 배경 Dim 처리
- 중앙에 카드 스택 UI (Stack + Draggable)

---

### D-02: Swipe-to-Clean

| 항목 | 내용 |
| --- | --- |
| **ID** | D-02 |
| **기능명** | Swipe-to-Clean |
| **우선순위** | **P1** |

**Gesture:**
| 방향 | 액션 | 피드백 |
| --- | --- | --- |
| **왼쪽 스와이프** | 휴지통 이동 | 붉은색 틴트 + Trash 아이콘 |
| **오른쪽 스와이프** | 보관 (Keep) | 초록색 틴트 + Keep 아이콘 |

**Feedback:**
- 햅틱: `HapticFeedback.lightImpact()`
- 상단 카운터: "오늘 정리한 장수: 12장"

**Empty State:**
- 폭죽 애니메이션 (Lottie)
- "오늘의 정리 끝! 갤러리가 가벼워졌어요." 문구

---

### D-03: 동기화 삭제

| 항목 | 내용 |
| --- | --- |
| **ID** | D-03 |
| **기능명** | 동기화 삭제 |
| **우선순위** | **P1** |

**Logic:**
1. 앱에서 이미지 삭제 시
2. 서버에 `is_deleted = true` PATCH 요청
3. 실제 이미지는 시스템 휴지통으로 이동 (복구 가능)

---

## 6. 기능 요약 테이블

| ID | 기능명 | 모듈 | 우선순위 | 처리 위치 |
| --- | --- | --- | --- | --- |
| A-01 | 지능형 스캔 | A | P0 | Client |
| A-02 | On-Device OCR | A | P0 | Client |
| A-03 | 메타데이터 동기화 | A | P0 | Client + Server |
| B-01 | 자동 카테고리 분류 | B | P0 | Server |
| B-02 | 초고속 검색 | B | P0 | Server |
| B-03 | 카테고리 탭 | B | P0 | Client |
| B-04 | 소비 리포트 | B | P2 | Server |
| C-01 | 스마트 액션 버튼 | C | P1 | Client |
| C-02 | 하이라이팅 | C | P1 | Client |
| C-03 | 보안 블러 | C | P2 | Client |
| D-01 | 스샷 정리 모드 | D | P1 | Client |
| D-02 | Swipe-to-Clean | D | P1 | Client |
| D-03 | 동기화 삭제 | D | P1 | Client + Server |

---

## 7. 참고 문서

- [05-UI_UX_SPEC.md](./05-UI_UX_SPEC.md) - UI/UX 상세
- [02-ARCHITECTURE.md](./02-ARCHITECTURE.md) - 시스템 아키텍처
