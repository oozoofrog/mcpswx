# TUI 레이어 규칙

ANSI escape + Foundation 기반 터미널 UI. 외부 라이브러리 없음.

## 구조

- `ANSIStyle.swift` — ANSI 컬러/스타일, `isTTY`/`isStdoutTTY` 감지, 박스 드로잉
- `InteractiveMenu.swift` — `tcgetattr`/`tcsetattr` raw mode, 방향키 메뉴 선택
- `ProgressIndicator.swift` — 다운로드 진행률 stderr 출력

## 주의사항

- 비터미널(pipe) 환경에서 ANSI escape/TUI 자동 비활성화
- raw mode 진입 시 반드시 defer로 `tcsetattr` 복원
- SIGINT 핸들링 시 터미널 복원 필요 (#4)
- stderr에만 TUI 출력, stdout은 데이터 전용
