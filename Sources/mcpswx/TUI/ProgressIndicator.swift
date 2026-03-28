// ProgressIndicator.swift
// 다운로드 진행률 표시
// tty 감지하여 비터미널 환경에서는 단순 텍스트 출력

import Foundation

/// 다운로드/작업 진행률 표시
nonisolated struct ProgressIndicator: Sendable {
    let title: String
    private let isTTY: Bool

    init(title: String) {
        self.title = title
        self.isTTY = isatty(STDERR_FILENO) != 0
    }

    /// 진행률 업데이트 (0.0 ~ 1.0)
    func update(progress: Double) {
        guard isTTY else { return }

        let percentage = Int(progress * 100)
        let barWidth = 30
        let filled = Int(Double(barWidth) * progress)
        let empty = barWidth - filled

        let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: empty)
        let line = "\r\(ANSIStyle.cyan)\(title)\(ANSIStyle.reset): [\(ANSIStyle.green)\(bar)\(ANSIStyle.reset)] \(percentage)%"

        fputs(line, stderr)
    }

    /// 완료 표시
    func complete() {
        if isTTY {
            fputs("\n", stderr)
        }
    }

    /// 단순 스피너 애니메이션 (프레임 단위)
    static func spinnerFrame(index: Int) -> String {
        let frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        return frames[index % frames.count]
    }
}
