// RegistryCommand.swift
// `swiftmcp registry` 서브커맨드 그룹
// `swiftmcp registry show` — URL/캐시 정보/서버 수 출력
// `swiftmcp registry update` — 강제 갱신 (캐시 무시)

import ArgumentParser
import Foundation

/// 레지스트리 관리 커맨드 그룹
struct RegistryCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "registry",
        abstract: "레지스트리 정보 표시 및 갱신.",
        subcommands: [ShowSubcommand.self, UpdateSubcommand.self],
        defaultSubcommand: ShowSubcommand.self
    )

    /// 레지스트리 정보 표시
    struct ShowSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "show",
            abstract: "현재 레지스트리 정보를 표시합니다."
        )

        mutating func run() async throws {
            let isTTY = isatty(STDOUT_FILENO) != 0
            let registryURL = RegistryClient.registryURL
            let cacheDir = RegistryClient.cacheDirectory

            if isTTY {
                print(ANSIStyle.bold + "레지스트리 정보:" + ANSIStyle.reset)
                print("  URL:        " + ANSIStyle.blue + registryURL + ANSIStyle.reset)
                print("  캐시 경로: \(cacheDir)")
            } else {
                print("레지스트리 정보:")
                print("  URL:        \(registryURL)")
                print("  캐시 경로: \(cacheDir)")
            }

            // 캐시된 레지스트리 로드 시도
            let registryClient = RegistryClient()
            do {
                let registry = try await registryClient.fetch()
                let serverCount = registry.servers.count
                if isTTY {
                    print("  서버 수:   " + ANSIStyle.green + "\(serverCount)개" + ANSIStyle.reset)
                    print("")
                    print(ANSIStyle.bold + "등록된 서버:" + ANSIStyle.reset)
                } else {
                    print("  서버 수:   \(serverCount)개")
                    print("")
                    print("등록된 서버:")
                }
                for (name, entry) in registry.servers.sorted(by: { $0.key < $1.key }) {
                    if isTTY {
                        print("  " + ANSIStyle.green + name + ANSIStyle.reset + " — \(entry.description)")
                    } else {
                        print("  \(name) — \(entry.description)")
                    }
                }
            } catch {
                print("  (레지스트리를 로드할 수 없습니다: \(error))")
            }
        }
    }

    /// 레지스트리 강제 갱신
    struct UpdateSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "update",
            abstract: "레지스트리를 강제 갱신합니다 (캐시 무시)."
        )

        mutating func run() async throws {
            let stderr = StderrWriter()
            stderr.write("레지스트리 갱신 중...")

            let registryClient = RegistryClient()
            do {
                // forceFetch: 캐시 무시하고 강제 갱신
                let registry = try await registryClient.forceFetch()
                stderr.write("레지스트리 갱신 완료. 서버 \(registry.servers.count)개 등록됨.")
            } catch {
                stderr.writeError("레지스트리 갱신 실패: \(error)")
                throw ExitCode.failure
            }
        }
    }
}
