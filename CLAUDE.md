# swiftmcp

Swift MCP(Model Context Protocol) 서버 생태계를 위한 플랫폼 도구.
Python uvx / Node.js npx에 대응하는 Swift 전용 MCP 런타임.

## 빌드 / 테스트

```bash
swift build              # 디버그 빌드
swift build -c release   # 릴리스 빌드
swift test               # 테스트 실행 (아직 없음)
```

## 아키텍처

```
swiftmcp (단일 executable)
├── Commands/     — ArgumentParser 서브커맨드 8개 (run, install, list, search, cache, registry, init, mcp)
├── Registry/     — 레지스트리 JSON 스키마 + GitHub raw URL fetch + 로컬 TTL 캐시
├── Resolver/     — GitHub Releases API binary 추출 + 소스 폴백 빌드
├── Cache/        — ~/.swiftmcp/cache/ 바이너리 다운로드·압축해제·권한 관리
├── Runner/       — Process stdio passthrough (MCP 서버 ↔ Claude 직접 통신)
├── MCP/          — swiftmcp 자체를 MCP 서버로 제공 (JSON-RPC 2.0, 7개 tool)
├── TUI/          — ANSI escape 컬러·박스·메뉴, tty 감지, 진행률 표시
└── Templates/    — swiftmcp init 프로젝트 생성 템플릿
```

## 핵심 규칙

- **Swift 6.2** / swift-tools-version: 6.2
- 모든 타입은 `Sendable` 준수 — `nonisolated struct` 우선, `actor`는 상태 관리 필요 시만
- **defaultIsolation: MainActor 금지** — CLI 도구이므로 불필요
- **외부 의존성**: `ArgumentParser` 하나만 — 나머지 Foundation
- **stdio 전략**: stdout/stdin은 MCP 통신 전용, 모든 진행상황/에러는 stderr
- **tty 감지**: `isatty()` 기반, 비터미널 환경에서 ANSI/TUI 자동 비활성화
- **한국어 주석/문서**

## 레지스트리

- 위치: 저장소 루트 `registry.json`
- URL: `https://raw.githubusercontent.com/oozoofrog/swiftmcp/main/registry.json`
- 로컬 캐시: `~/.swiftmcp/registry/registry.json` (TTL 1시간)
- self-hosting: swiftmcp 자체도 레지스트리에 등록

## 알려진 이슈

- #1: SourceResolver buildCommand 인수 주입 취약점
- #2: CacheManager 압축 해제 보안
- #3: init 템플릿 DispatchSemaphore 안티패턴
- #4: InteractiveMenu SIGINT 터미널 복원
