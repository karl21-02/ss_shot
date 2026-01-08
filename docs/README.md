# SS-Shot Documentation

> 스크린샷을 검색 가능한 데이터로 변환하는 지능형 유틸리티 앱

---

## 문서 목록

| # | 문서 | 설명 | 대상 |
|---|------|------|------|
| 01 | [PROJECT_OVERVIEW](./01-PROJECT_OVERVIEW.md) | 프로젝트 배경, 핵심 가치, 목표, KPI | 전체 |
| 02 | [ARCHITECTURE](./02-ARCHITECTURE.md) | 시스템 아키텍처, 데이터 흐름도 | 개발자 |
| 03 | [TECH_STACK](./03-TECH_STACK.md) | 기술 스택 (Flutter, ML Kit, Drift) | 개발자 |
| 04 | [FEATURE_SPEC](./04-FEATURE_SPEC.md) | 기능 명세서 (P0/P1/P2 우선순위) | 개발자 |
| 05 | [UI_UX_SPEC](./05-UI_UX_SPEC.md) | 화면별 UI/UX 상세 명세 | 개발자/디자이너 |
| 06 | [DB_SCHEMA](./06-DB_SCHEMA.md) | ERD, 테이블 정의, 인덱스 전략 | 개발자 |
| 07 | [AUTH_SECURITY](./07-AUTH_SECURITY.md) | 인증 흐름, JWT, 보안 정책 | 개발자 |
| 08 | [DEVELOPMENT_GUIDE](./08-DEVELOPMENT_GUIDE.md) | 프로젝트 구조, 코딩 컨벤션, Git 전략 | 개발자 |
| - | [LOGGING](./LOGGING.md) | 로깅 표준, 이모지 컨벤션, 금지 패턴 | 개발자 |

---

## 빠른 시작 가이드

### 1단계: 프로젝트 이해
```
01-PROJECT_OVERVIEW.md → 02-ARCHITECTURE.md → 03-TECH_STACK.md
```

### 2단계: 기능 파악
```
04-FEATURE_SPEC.md → 05-UI_UX_SPEC.md
```

### 3단계: 구현 준비
```
06-DB_SCHEMA.md → 07-AUTH_SECURITY.md → 08-DEVELOPMENT_GUIDE.md
```

### 4단계: 코딩 시작
```
RULE.md 숙지 → Phase 1 개발 착수
```

---

## 관련 파일

| 파일 | 위치 | 설명 |
|------|------|------|
| [RULE.md](../RULE.md) | 프로젝트 루트 | Claude Code 시스템 지침 (코딩 규칙) |
| [notes.md](../notes.md) | 프로젝트 루트 | PRD 원본 (기획 컨텍스트) |
| [task_plan.md](../task_plan.md) | 프로젝트 루트 | 마누스 패턴 진행 상황 체크리스트 |

---

## 핵심 가치

1. **Find Instantly** - 텍스트 검색으로 0.1초 만에 이미지 찾기
2. **Organize Automatically** - AI가 금융/쇼핑/일정 등으로 자동 분류
3. **Clean Fun** - 스와이프 게이미피케이션으로 즐거운 정리

---

## 개발 마일스톤

| Phase | 목표 | 주요 작업 |
|-------|------|----------|
| **1** | 기반 구축 | Flutter 갤러리 연동, DB 설계 |
| **2** | 코어 연동 | ML Kit OCR, Sync API |
| **3** | 기능 구현 | 검색, 카테고리 분류, 스마트 액션 |
| **4** | 고도화 | Swipe-to-Clean UI, 디자인 폴리싱 |

---

## 프로젝트 구조

```
ss_shot/
├── RULE.md               # AI 시스템 지침
├── notes.md              # PRD 원본
├── task_plan.md          # 진행 체크리스트
├── docs/                 # 📁 문서 폴더
│   ├── README.md         # ← 현재 파일
│   └── 01~08-*.md        # 상세 문서
├── lib/                  # Flutter 소스코드
├── android/              # Android 설정
├── ios/                  # iOS 설정
└── pubspec.yaml          # 의존성 정의
```
