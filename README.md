# 🌉 SwiftBridge CLI

> **Generate modern, production-ready Swift networking code from OpenAPI specs — built for Swift 6, async/await, and SwiftUI.**

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138.svg?style=flat&logo=swift)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%2014+-0D96F6.svg?style=flat&logo=apple)](https://developer.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## The Problem

Every time the backend team updates an API, iOS developers scramble to update models, fix broken decoding, and wire up new endpoints. Existing tools like **OpenAPI Generator** produce bloated, legacy Swift code that relies on closures, Combine, or Alamofire — none of which align with modern Swift development.

**SwiftBridge CLI** fixes this.

## Why SwiftBridge?

| Feature | OpenAPI Generator | **SwiftBridge CLI** |
|---|---|---|
| Concurrency | Closures / Combine | **`async/await` (native)** |
| Swift Version | Swift 5.x patterns | **Swift 6 strict concurrency** |
| Decoding | Crashes on mismatches | **Zero-crash resilient decoding** |
| SwiftUI | Manual ViewModel mapping | **`@Observable` generation** |
| Dependencies | Alamofire, RxSwift, etc. | **Zero dependencies (URLSession)** |
| Output Quality | Massive, unreadable files | **Clean, formatted, committable code** |

## Quick Start

### Installation

```bash
# Via Homebrew (coming soon)
brew install swiftbridge

# Build from source
git clone https://github.com/user/SwiftBridge-CLI.git
cd SwiftBridge-CLI
swift build -c release
```

### Usage

```bash
# Generate models and services from a local spec
swiftbridge generate --spec api/openapi.yaml --output Sources/Networking

# Generate with @Observable view models
swiftbridge generate --spec api/openapi.yaml --output Sources/Networking --observable

# Fetch spec from a remote URL
swiftbridge generate --spec https://api.example.com/v1/openapi.json --output Sources/Networking
```

### As an SPM Build Tool Plugin

```swift
// In your app's Package.swift
.plugin(
    name: "SwiftBridgePlugin",
    capability: .buildTool(),
    dependencies: ["swiftbridge"]
)
```

## Architecture

```
SwiftBridge-CLI/
├── Sources/
│   ├── SwiftBridgeCLI/          # CLI entry point (ArgumentParser)
│   ├── SwiftBridgeCore/         # OpenAPI parsing, IR models
│   └── SwiftBridgeCodegen/      # Template engine, code emission
├── Tests/
├── Templates/                    # Stencil templates (overridable)
└── Examples/                     # Sample SwiftUI app with generated code
```

## Roadmap

See [ROADMAP.md](docs/ROADMAP.md) for the full development plan.

- **Milestone 1:** Core parsing engine (OpenAPI 3.x)
- **Milestone 2:** Resilient model generation with `@SafeDecodable`
- **Milestone 3:** Network service layer generation
- **Milestone 4:** `@Observable` view model generation
- **Milestone 5:** SPM Plugin integration
- **Milestone 6:** Community templates & extensibility

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) before submitting a PR.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ for the Swift community by [José Álvarez](https://github.com/user)**
