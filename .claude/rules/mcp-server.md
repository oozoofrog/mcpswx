# MCP 서버 레이어 규칙

swiftmcp 자체를 MCP 서버로 제공하는 JSON-RPC 2.0 구현.

## 구조

- `MCPServerHandler.swift` — stdin에서 JSON-RPC 요청 읽기, 디스패치, stdout 응답
- `MCPTools.swift` — 7개 tool 정의 (run, install, search, list, init, cache_clean, registry_update)

## 프로토콜

- JSON-RPC 2.0 over stdio (줄 단위)
- 메서드: `initialize`, `tools/list`, `tools/call`
- 잘못된 입력에 crash 없이 에러 응답 반환
- stdout은 JSON-RPC 전용, 진행 메시지는 stderr
