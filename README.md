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

### Prerequisites

**Linux users**: Install Swift using Swiftly (official Swift toolchain installer):
```bash
curl -O "https://download.swift.org/swiftly/linux/swiftly-1.1.0-$(uname -m).tar.gz"
tar -zxf "swiftly-1.1.0-$(uname -m).tar.gz"
./swiftly init
swiftly install latest
```
Learn more at [swift.org/install/linux/swiftly](https://www.swift.org/install/linux/swiftly/)

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
# Install Swift 6.2.1 using Swiftly
swiftly install 6.2.1
swiftly use 6.2.1

# Install the static Linux SDK
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

// Create a melody with tempo (♩ = 120 BPM)
let timedMelody = 𝄞(tempo: 120♩) {
    Note(step: 69)⋔  // A4 at 120 BPM
    Note(step: 71)⋔  // B4
    Note(step: 72)⋔  // C5
}

// Create a melody with tempo and time signature
let waltz = 𝄞(tempo: 90♩, timeSignature: .waltzTime) {
    Note(step: 69)⋔  // 3/4 time at 90 BPM
    Note(step: 71)⋔
    Note(step: 72)⋔
}

// Synthesize with Karplus-Strong algorithm
let synth = KarplusStrong(sampleRate: 44100.0, noteDuration: 0.5)
try synth.synth(melody)
```

### Working with Tempo and Duration

```swift
// Create tempo using the ♩ operator
let moderato = 100♩  // ♩ = 100 BPM
let allegro = 140♩   // ♩ = 140 BPM

// Work with different note durations
let tempo = Tempo(bpm: 120)
Duration.quarter.toSeconds(tempo: tempo)  // 0.5 seconds
Duration.half.toSeconds(tempo: tempo)     // 1.0 second
Duration.whole.toSeconds(tempo: tempo)    // 2.0 seconds
Duration.eighth.toSeconds(tempo: tempo)   // 0.25 seconds

// Use dotted and triplet notes
Duration.dottedQuarter.toSeconds(tempo: tempo)  // 0.75 seconds
Duration.tripletQuarter.toSeconds(tempo: tempo) // 0.33 seconds

// Common time signatures
TimeSignature.commonTime  // 4/4
TimeSignature.waltzTime   // 3/4
TimeSignature.cutTime     // 2/2
TimeSignature.marchTime   // 2/4
```

## Features

- Musical notation operators (♯, ♭, 𝄞, ♩)
- Pitch and Note abstractions
- **Tempo and timing control** (BPM, time signatures, note durations)
- Duration types (whole, half, quarter, eighth, dotted notes, triplets)
- Time signature support (4/4, 3/4, 6/8, etc.)
- Track building with result builders
- Karplus-Strong synthesizer for guitar-like sounds
- Cross-platform support (macOS, Linux, WebAssembly)
- Static Linux binaries with zero runtime dependencies
