# Resolver 레이어 규칙

GitHub Releases에서 pre-built binary를 추출하고, 폴백으로 소스 빌드를 수행.

## 구조

- `BinaryResolver.swift` — GitHub Releases API → 플랫폼별 artifact URL 추출, `arch` 명령으로 arm64/x86_64 자동 감지
- `SourceResolver.swift` — `git clone` → `swift build -c release` 소스 폴백

## 주의사항

- BinaryResolver가 우선, 실패 시 SourceResolver 폴백
- SourceResolver의 buildCommand 처리에 보안 이슈 있음 (#1)
- 플랫폼 감지: `uname -m` 또는 `arch` 명령 기반, 실패 시 컴파일타임 `#if arch(arm64)` 폴백
