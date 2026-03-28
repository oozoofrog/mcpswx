// InteractiveMenu.swift
// 방향키 메뉴 선택, 텍스트 입력 프롬프트
// tcgetattr/tcsetattr로 raw mode 키 입력 감지

import Foundation

/// 인터랙티브 메뉴 — 방향키로 선택 가능한 TUI 메뉴
nonisolated struct InteractiveMenu: Sendable {

    /// 텍스트 입력 프롬프트
    /// - Parameters:
    ///   - prompt: 표시할 프롬프트 메시지
    ///   - defaultValue: 빈 입력 시 반환할 기본값
    /// - Returns: 입력된 텍스트 또는 기본값
    func prompt(_ message: String, defaultValue: String = "") -> String {
        let defaultHint = defaultValue.isEmpty ? "" : " (\(defaultValue))"
        print("\(ANSIStyle.cyan)\(message)\(ANSIStyle.reset)\(defaultHint): ", terminator: "")
        let input = readLine() ?? ""
        return input.isEmpty ? defaultValue : input
    }

    /// 방향키로 선택 가능한 메뉴 표시
    /// - Parameters:
    ///   - title: 메뉴 제목
    ///   - options: 선택 항목 배열
    /// - Returns: 선택된 항목의 인덱스
    func selectMenu(title: String, options: [String]) -> Int {
        guard isatty(STDIN_FILENO) != 0 else {
            // 비TTY 환경: 첫 번째 항목 자동 선택
            return 0
        }

        var selectedIndex = 0

        // raw mode 진입
        var oldTermios = termios()
        tcgetattr(STDIN_FILENO, &oldTermios)
        var rawTermios = oldTermios
        rawTermios.c_lflag &= ~(UInt(ECHO) | UInt(ICANON))
        tcsetattr(STDIN_FILENO, TCSANOW, &rawTermios)

        // 커서 숨기기
        print(ANSIStyle.hideCursor, terminator: "")

        defer {
            // 원래 터미널 설정 복원
            tcsetattr(STDIN_FILENO, TCSANOW, &oldTermios)
            print(ANSIStyle.showCursor, terminator: "")
        }

        // 메뉴 렌더링 루프
        renderMenu(title: title, options: options, selectedIndex: selectedIndex)

        while true {
            // 키 입력 읽기
            var buf = [UInt8](repeating: 0, count: 3)
            let n = read(STDIN_FILENO, &buf, 3)

            if n == 1 {
                switch buf[0] {
                case 13, 10: // Enter
                    // 메뉴 지우기
                    clearMenu(lineCount: options.count + 2)
                    return selectedIndex
                case 113: // q
                    clearMenu(lineCount: options.count + 2)
                    return 0
                default:
                    break
                }
            } else if n == 3 && buf[0] == 27 && buf[1] == 91 {
                // ESC [ A = 위, ESC [ B = 아래
                switch buf[2] {
                case 65: // 위
                    if selectedIndex > 0 {
                        selectedIndex -= 1
                    } else {
                        selectedIndex = options.count - 1
                    }
                case 66: // 아래
                    if selectedIndex < options.count - 1 {
                        selectedIndex += 1
                    } else {
                        selectedIndex = 0
                    }
                default:
                    break
                }

                // 메뉴 다시 렌더링
                clearMenu(lineCount: options.count + 2)
                renderMenu(title: title, options: options, selectedIndex: selectedIndex)
            }
        }
    }

    // MARK: - Private

    private func renderMenu(title: String, options: [String], selectedIndex: Int) {
        print("\(ANSIStyle.bold)\(ANSIStyle.cyan)\(title)\(ANSIStyle.reset)")
        print("")
        for (index, option) in options.enumerated() {
            if index == selectedIndex {
                print("  \(ANSIStyle.reversed)\(ANSIStyle.green) > \(option) \(ANSIStyle.reset)")
            } else {
                print("    \(option)")
            }
        }
        print("")
        print("\(ANSIStyle.dim)↑↓ 방향키로 선택, Enter로 확인\(ANSIStyle.reset)")
    }

    private func clearMenu(lineCount: Int) {
        for _ in 0..<(lineCount + 2) {
            print(ANSIStyle.cursorUp(1) + ANSIStyle.eraseLine, terminator: "")
        }
    }
}
