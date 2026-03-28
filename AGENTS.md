# swiftmcp — AI Agent Instructions

Swift MCP Platform tool — runtime, generator, and self-hosting MCP server for the Swift ecosystem.

## Build

```bash
swift build              # Debug build
swift build -c release   # Release build
```

## Architecture

Single executable with 8 subsystems:
- `Commands/` — 8 ArgumentParser subcommands (run, install, list, search, cache, registry, init, mcp)
- `Registry/` — JSON schema + GitHub raw URL fetch + local TTL cache
- `Resolver/` — GitHub Releases API binary download + source fallback build
- `Cache/` — `~/.swiftmcp/cache/` binary management
- `Runner/` — Process stdio passthrough (MCP server ↔ Claude direct communication)
- `MCP/` — swiftmcp itself as MCP server (JSON-RPC 2.0, 7 tools)
- `TUI/` — ANSI escape colors, interactive menus, tty detection
- `Templates/` — `swiftmcp init` project scaffolding

## Key Rules

- Swift 6.2 strict concurrency, all types `Sendable`
- `nonisolated struct` preferred, `actor` only for mutable state
- Single external dependency: `ArgumentParser`
- stdout/stdin reserved for MCP communication, all progress/errors to stderr
- `isatty()` detection — disable ANSI/TUI in non-terminal environments

## Usage

```bash
swiftmcp run <name>       # Run MCP server from registry
swiftmcp init             # Create new MCP server project (interactive)
swiftmcp mcp              # Start swiftmcp as MCP server
swiftmcp search <query>   # Search registry
swiftmcp install <name>   # Install without running
swiftmcp list             # List installed servers
```
