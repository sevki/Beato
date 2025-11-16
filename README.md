![🚫 I, V, VI, IV](https://repository-images.githubusercontent.com/502357475/dfa94b4a-591b-422c-a3bd-df1f554326c5)
# [Beato](https://www.youtube.com/watch?v=7yRXAxQGw_k)

🚫 I, V, VI, IV

A Swift DSL for live coding music with support for macOS, Linux, and WebAssembly.

## Platform Support

Beato is built and tested on multiple platforms:

- **macOS** - Full support with native Swift toolchain
- **Linux** - Ubuntu 22.04+ with Swift 5.9+
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
- Cross-platform support
