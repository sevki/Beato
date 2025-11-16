![🚫 I, V, VI, IV](https://repository-images.githubusercontent.com/502357475/dfa94b4a-591b-422c-a3bd-df1f554326c5)
# [Beato](https://www.youtube.com/watch?v=7yRXAxQGw_k)

🚫 I, V, VI, IV

A Swift DSL for live coding music with support for macOS, Linux, and WebAssembly.

## Platform Support

Beato is built and tested on multiple platforms:

- **macOS** - Full support with native Swift toolchain
- **Linux** - Ubuntu 22.04+ with Swift 5.9+
- **Static Linux** - Fully static binaries with Swift 6.2.1+ (musl-based, no runtime dependencies)
- **WebAssembly** - Experimental support via SwiftWasm

## Installation

### Swift Package Manager

Add Beato to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/sevki/Beato.git", from: "1.0.0")
]
```

### Building from Source

**macOS & Linux:**
```bash
swift build
swift test
```

**Static Linux (portable binaries with no runtime dependencies):**
```bash
# Install the static Linux SDK (Swift 6.2.1+)
# Learn more: https://www.swift.org/documentation/articles/static-linux-getting-started.html
swift sdk install https://download.swift.org/swift-6.2.1-release/static-sdk/swift-6.2.1-RELEASE/swift-6.2.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
  --checksum 08e1939a504e499ec871b36826569173103e4562769e12b9b8c2a50f098374ad

# Build static binary
swift build -c release --swift-sdk x86_64-swift-linux-musl

# The resulting binary has no dynamic dependencies and can run on any Linux system
```

**WebAssembly:**
```bash
# Install SwiftWasm toolchain first
# https://book.swiftwasm.org/getting-started/setup.html

swift build --triple wasm32-unknown-wasi
```

## Quick Start

```swift
import Beato

// Create a simple melody
let melody = 𝄞 {
    Note(step: 69)⋔  // A4 (440 Hz)
    Note(step: 71)⋔  // B4
    Note(step: 72)⋔  // C5
}

// Synthesize with Karplus-Strong algorithm
let synth = KarplusStrong(sampleRate: 44100.0, noteDuration: 0.5)
try synth.synth(melody)
```

## Features

- Musical notation operators (♯, ♭, 𝄞)
- Pitch and Note abstractions
- Track building with result builders
- Karplus-Strong synthesizer for guitar-like sounds
- Cross-platform support (macOS, Linux, WebAssembly)
- Static Linux binaries with zero runtime dependencies
