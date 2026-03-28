# Templates 레이어 규칙

`mcpswx init` 명령이 생성하는 MCP 서버 프로젝트 템플릿.

## 구조

- `PackageTemplate.swift` — Package.swift, main.swift, MCPProtocol.swift, SampleTool.swift, release.yml, registry-entry.json, README.md, .gitignore 생성

## 주의사항

- 생성되는 코드는 Swift 6.2 strict concurrency를 준수해야 함
- `@unchecked Sendable`, `DispatchSemaphore.wait()` 사용 금지 (#3 — 현재 `mcpProtocolSwift()` 템플릿에 미수정 상태로 잔존, 해결 필요)
- `actor` 또는 `nonisolated struct` 패턴 사용
- 생성 완료 후 사용자에게 `swift build` 실행 안내 메시지 출력 (자동 빌드 실행 없음)
- `--non-interactive` 플래그로 비대화형 모드 지원
