# Commands 레이어 규칙

ArgumentParser 기반 서브커맨드. 각 커맨드는 `AsyncParsableCommand` 준수.

## 패턴

- 모든 커맨드는 `async throws`의 `run()` 메서드 구현
- `--json` 플래그로 기계 판독 가능 JSON 출력 지원
- stdout은 결과 데이터 전용, 진행 메시지는 stderr (StderrWriter)
- tty 감지: `ANSIStyle.isStdoutTTY`로 컬러 출력 여부 결정

## 새 커맨드 추가 시

1. `Commands/` 디렉토리에 파일 생성
2. `MCPSWX.swift`의 `subcommands` 배열에 등록
3. `--json` 플래그 포함
4. `MCPTools.swift`에 대응하는 MCP tool 추가
