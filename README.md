# swiftmcp

Swift MCP(Model Context Protocol) 서버 생태계를 위한 플랫폼 도구.
Python의 `uvx`, Node.js의 `npx`에 대응하는 Swift 전용 MCP 런타임.

## 설치

### 빠른 설치 (curl one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/oozoofrog/swiftmcp/main/install.sh | bash
```

### 수동 빌드

```bash
git clone https://github.com/oozoofrog/swiftmcp.git
cd swiftmcp
swift build -c release
cp .build/release/swiftmcp /usr/local/bin/
```

### GitHub Releases

[Releases](https://github.com/oozoofrog/swiftmcp/releases)에서 플랫폼별 pre-built binary를 다운로드할 수 있습니다.

## 빠른 시작

### MCP 서버 실행

```bash
# 레지스트리에서 MCP 서버 즉시 실행
swiftmcp run swift-yf-tools

# Claude Code에 MCP 서버 등록
claude mcp add yahoo-finance -- swiftmcp run swift-yf-tools
```

### 새 MCP 서버 만들기

```bash
# 인터랙티브 프로젝트 생성
swiftmcp init

# 비대화형 모드
swiftmcp init --name my-server --non-interactive
```

### 환경 진단

```bash
swiftmcp doctor
swiftmcp doctor --json    # 기계 판독 가능 JSON
```

### MCP 서버 테스트 (샌드박스)

```bash
# 격리된 환경에서 MCP 서버 전체 라이프사이클 검증
swiftmcp test swift-yf-tools --sandbox
```

### 레지스트리 검색

```bash
swiftmcp search yahoo
swiftmcp list              # 설치된 서버 목록
```

## Claude Code 연동

### MCP 서버 실행기로 사용

```bash
claude mcp add yahoo-finance -- swiftmcp run swift-yf-tools
```

### swiftmcp 자체를 MCP 서버로 등록

```bash
claude mcp add swiftmcp -- swiftmcp mcp
```

swiftmcp를 MCP 서버로 등록하면 Agent가 다음 tool을 사용할 수 있습니다:

| Tool | 설명 |
|------|------|
| `run` | MCP 서버 실행 |
| `install` | 서버 설치 |
| `search` | 레지스트리 검색 |
| `list` | 설치 목록 |
| `init` | 프로젝트 생성 |
| `cache_clean` | 캐시 정리 |
| `registry_update` | 레지스트리 갱신 |

## Agent 설치 가이드

AI Agent가 자동으로 설치할 때 참조하세요.

```bash
# 1. 전제조건 확인
swift --version   # Swift 6.2+ 필요

# 2. 빌드
git clone https://github.com/oozoofrog/swiftmcp.git
cd swiftmcp
swift build -c release

# 3. MCP 등록
claude mcp add swiftmcp -- ./build/release/swiftmcp mcp
```

## 레지스트리

swiftmcp는 [registry.json](https://github.com/oozoofrog/swiftmcp/blob/main/registry.json)으로 MCP 서버를 관리합니다.

### 서버 등록

`registry.json`에 엔트리를 추가하고 PR을 보내주세요:

```json
{
  "my-server": {
    "repo": "username/my-server",
    "description": "서버 설명",
    "executable": "my-server",
    "args": ["mcp"],
    "platforms": {
      "macos-arm64": { "artifact": "my-server-macos-arm64.tar.gz" },
      "macos-x86_64": { "artifact": "my-server-macos-x86_64.tar.gz" }
    }
  }
}
```

## 아키텍처

```
swiftmcp
├── Commands/     — run, install, list, search, cache, registry, init, mcp, doctor, test
├── Registry/     — JSON 스키마 + GitHub raw URL fetch + TTL 캐시
├── Resolver/     — GitHub Releases binary 추출 + 소스 폴백
├── Cache/        — ~/.swiftmcp/cache/ 바이너리 관리
├── Runner/       — Process stdio passthrough
├── MCP/          — swiftmcp 자체 MCP 서버 (JSON-RPC 2.0)
├── Doctor/       — 환경 진단 5개 체커
├── Sandbox/      — 격리 테스트 + MCP 프로토콜 검증
├── TUI/          — ANSI 컬러, 인터랙티브 메뉴, 진행률
└── Templates/    — init 프로젝트 스캐폴딩
```

## 명령어 레퍼런스

| 명령어 | 설명 |
|--------|------|
| `swiftmcp run <name>` | 레지스트리에서 MCP 서버 즉시 실행 |
| `swiftmcp install <name>` | 다운로드 + 캐싱 (실행 없음) |
| `swiftmcp init` | 새 MCP 서버 프로젝트 생성 (TUI) |
| `swiftmcp test <name>` | 샌드박스 MCP 서버 테스트 |
| `swiftmcp doctor` | 환경 진단 |
| `swiftmcp search <query>` | 레지스트리 검색 |
| `swiftmcp list` | 설치된 서버 목록 |
| `swiftmcp cache clean` | 캐시 정리 |
| `swiftmcp registry show` | 레지스트리 정보 |
| `swiftmcp registry update` | 레지스트리 강제 갱신 |
| `swiftmcp mcp` | swiftmcp 자체를 MCP 서버로 실행 |

## 기술 스택

- Swift 6.2 (strict concurrency)
- 외부 의존성: [swift-argument-parser](https://github.com/apple/swift-argument-parser) 1개만
- macOS 14+

## 라이선스

MIT
