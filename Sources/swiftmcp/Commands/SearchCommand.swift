// SearchCommand.swift
// `swiftmcp search <query>` 구현
// 레지스트리에서 name/description 필드 대소문자 무관 검색

import ArgumentParser
import Foundation

/// 레지스트리에서 MCP 서버를 검색하는 커맨드
struct SearchCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "레지스트리에서 MCP 서버를 검색합니다.",
        usage: "swiftmcp search <query>"
    )

    @Argument(help: "검색어 (이름 또는 설명에서 대소문자 무관 검색)")
    var query: String

    mutating func run() async throws {
        let stderr = StderrWriter()
        let isTTY = isatty(STDOUT_FILENO) != 0

        // 레지스트리 로드
        let registryClient = RegistryClient()
        let registry: RegistryEntry
        do {
            registry = try await registryClient.fetch()
        } catch {
            stderr.writeError("레지스트리 로드 실패: \(error)")
            throw ExitCode.failure
        }

        // 대소문자 무관 검색
        let lowercasedQuery = query.lowercased()
        let results = registry.servers.filter { name, entry in
            name.lowercased().contains(lowercasedQuery) ||
            entry.description.lowercased().contains(lowercasedQuery)
        }

        if results.isEmpty {
            let message = "No results found for '\(query)'."
            if isTTY {
                print(ANSIStyle.yellow + message + ANSIStyle.reset)
            } else {
                print(message)
            }
            return
        }

        // 결과 출력
        if isTTY {
            print(ANSIStyle.bold + "검색 결과 (\(results.count)개):" + ANSIStyle.reset)
        } else {
            print("검색 결과 (\(results.count)개):")
        }

        for (name, entry) in results.sorted(by: { $0.key < $1.key }) {
            if isTTY {
                print("")
                print("  " + ANSIStyle.green + ANSIStyle.bold + name + ANSIStyle.reset)
                print("  설명: " + entry.description)
                print("  저장소: " + ANSIStyle.blue + entry.repo + ANSIStyle.reset)
                print("  실행: " + ANSIStyle.dim + "swiftmcp run \(name)" + ANSIStyle.reset)
            } else {
                print("")
                print("  \(name)")
                print("  설명: \(entry.description)")
                print("  저장소: \(entry.repo)")
                print("  실행: swiftmcp run \(name)")
            }
        }
    }
}
