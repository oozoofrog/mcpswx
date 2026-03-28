# Registry 레이어 규칙

레지스트리 JSON 스키마 정의와 원격 fetch + 로컬 캐싱.

## 구조

- `RegistrySchema.swift` — `RegistryEntry`, `ServerEntry`, `PlatformEntry`, `SourceEntry` Codable 스키마
- `RegistryClient.swift` — GitHub raw URL fetch, `~/.swiftmcp/registry/` 캐시, TTL 1시간

## 패턴

- 모든 스키마 타입은 `nonisolated struct` + `Sendable` + `Codable`
- 네트워크 실패 시 로컬 캐시 폴백
- HTTP 에러 시 상태 코드를 에러 메시지에 포함
- 레지스트리 URL: `https://raw.githubusercontent.com/oozoofrog/swiftmcp/main/registry.json`
