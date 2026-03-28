# mcpswx — AI Agent Instructions

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
- `Cache/` — `~/.mcpswx/cache/` binary management
- `Runner/` — Process stdio passthrough (MCP server ↔ Claude direct communication)
- `MCP/` — mcpswx itself as MCP server (JSON-RPC 2.0, 7 tools)
- `TUI/` — ANSI escape colors, interactive menus, tty detection
- `Templates/` — `mcpswx init` project scaffolding

## Key Rules

- Swift 6.2 strict concurrency, all types `Sendable`
- `nonisolated struct` preferred, `actor` only for mutable state
- Single external dependency: `ArgumentParser`
- stdout/stdin reserved for MCP communication, all progress/errors to stderr
- `isatty()` detection — disable ANSI/TUI in non-terminal environments

## Usage

```bash
mcpswx run <name>       # Run MCP server from registry
mcpswx init             # Create new MCP server project (interactive)
mcpswx mcp              # Start mcpswx as MCP server
mcpswx search <query>   # Search registry
mcpswx install <name>   # Install without running
mcpswx list             # List installed servers
```
