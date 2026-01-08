# SS-Shot

**Intelligent Screenshot Manager** - 스크린샷을 검색 가능한 데이터로 변환하는 지능형 유틸리티 앱

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Overview

갤러리에 방치된 수천 장의 스크린샷, 찾고 싶은 정보가 있는데 일일이 뒤져야 했던 경험이 있으신가요?

**SS-Shot**은 OCR 기술로 스크린샷 속 텍스트를 추출하고, 검색 가능한 데이터로 변환합니다.

### Core Value

| | |
|---|---|
| **Find Instantly** | 텍스트 검색으로 0.1초 만에 이미지 찾기 |
| **Organize Automatically** | AI가 금융/쇼핑/일정 등으로 자동 분류 |
| **Clean Fun** | 스와이프 게이미피케이션으로 즐거운 정리 |

---

## Features

### MVP (Phase 1-2) - 완료
- [x] 프로젝트 세팅 및 문서화
- [x] 갤러리 연동 (Screenshots 앨범)
- [x] On-Device OCR (Google ML Kit)
- [x] 텍스트 검색 기능
- [x] 카테고리 자동 분류

### Phase 3 - 서버 연동 (진행 예정)
- [ ] 소셜 로그인 (Google, Apple)
- [ ] JWT 토큰 관리
- [ ] 서버 동기화 API 연동

### Phase 4 - 고도화 (진행 예정)
- [ ] 스마트 액션 (URL 열기, 계좌 복사, 캘린더 등록)
- [ ] 검색 하이라이팅
- [ ] Swipe-to-Clean 정리 모드

---

## Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.x |
| **State Management** | Riverpod 2.0 |
| **Local DB** | Drift (SQLite) |
| **OCR** | Google ML Kit |
| **Network** | Dio |
| **Architecture** | Clean Architecture Lite |

---

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/                 # Constants, Utils, Errors
├── data/                 # DataSources, Models, Repositories
├── domain/               # Entities, UseCases
├── presentation/         # Screens, Widgets, ViewModels
└── services/             # OCR, Gallery, Sync
```

---

## Documentation

상세 문서는 [docs/](./docs/README.md) 폴더를 참고하세요.

| Document | Description |
|----------|-------------|
| [01-PROJECT_OVERVIEW](./docs/01-PROJECT_OVERVIEW.md) | 프로젝트 개요 |
| [02-ARCHITECTURE](./docs/02-ARCHITECTURE.md) | 시스템 아키텍처 |
| [03-TECH_STACK](./docs/03-TECH_STACK.md) | 기술 스택 |
| [04-FEATURE_SPEC](./docs/04-FEATURE_SPEC.md) | 기능 명세서 |
| [05-UI_UX_SPEC](./docs/05-UI_UX_SPEC.md) | UI/UX 명세 |
| [06-DB_SCHEMA](./docs/06-DB_SCHEMA.md) | DB 스키마 |
| [07-AUTH_SECURITY](./docs/07-AUTH_SECURITY.md) | 인증/보안 |
| [08-DEVELOPMENT_GUIDE](./docs/08-DEVELOPMENT_GUIDE.md) | 개발 가이드 |
| [09-SERVER_REQUIREMENTS](./docs/09-SERVER_REQUIREMENTS.md) | 서버 API 명세 |
| [LOGGING](./docs/LOGGING.md) | 로깅 표준 |

---

## Getting Started

### Prerequisites

- Flutter 3.x
- Dart 3.x
- Android Studio / Xcode

### Installation

```bash
# Clone the repository
git clone https://github.com/karl21-02/ss_shot.git
cd ss_shot

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Privacy

**Privacy-First 설계**를 채택합니다.

- 이미지 원본은 **절대 서버로 전송하지 않습니다**
- OCR 결과(텍스트 + 좌표)만 서버에 동기화됩니다
- 모든 데이터는 사용자 계정 기준으로 완벽하게 격리됩니다

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact

- **Developer:** karl21-02
- **Email:** manuna530@gmail.com
