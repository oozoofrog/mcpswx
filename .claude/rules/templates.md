# Templates 레이어 규칙

`swiftmcp init` 명령이 생성하는 MCP 서버 프로젝트 템플릿.

## 구조

- `PackageTemplate.swift` — Package.swift, main.swift, MCPProtocol.swift, SampleTool.swift, release.yml, registry-entry.json, README.md, .gitignore 생성

## 주의사항

- 생성되는 코드는 Swift 6.2 strict concurrency를 준수해야 함
- `@unchecked Sendable`, `DispatchSemaphore.wait()` 사용 금지 (#3)
- `actor` 또는 `nonisolated struct` 패턴 사용
- 생성 후 `swift build` 자동 검증
- `--non-interactive` 플래그로 비대화형 모드 지원
