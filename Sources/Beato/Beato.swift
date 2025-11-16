import Foundation

postfix operator ♭
postfix operator ♯

/// Pitch represents a musical [Pitch](https://en.wikipedia.org/wiki/Pitch_(music)).
@propertyWrapper public struct Pitch {
    var hertz: Double
    public var wrappedValue: Double {
        get { hertz }
        set { hertz = newValue }
    }

    /// Increases the pitch by 12th parts
    public static postfix func ♯ (num: Pitch) -> Pitch {
        Pitch(hertz: num.hertz * 1.0594630943592953)
    }

    /// Decreases the pitch by 12th parts
    public static postfix func ♭ (num: Pitch) -> Pitch {
        Pitch(hertz: num.hertz * 0.9438743126816935)
    }
}

/// Note represents a pitch class.
@propertyWrapper public struct Note {
    var step: Int
    public var wrappedValue: Int {
        get { step }
        set { step = newValue }
    }

    public static postfix func ♯ (num: Note) -> Note {
        Note(step: num.step + 1)
    }

    public static postfix func ♭ (num: Note) -> Note {
        Note(step: num.step - 1)
    }
}

postfix operator ♪

public extension Pitch {
    /// Convert an absolute pitch to it's relative pitch class.
    static postfix func ♪ (num: Pitch) -> Note {
        Note(step: Int(round(12 * log2(num.wrappedValue / 440.0))))
    }
}

public extension Note {
    static postfix func ⋔ (_ n: Note) -> Pitch {
        Pitch(hertz: pow(2.0, Double(n.step - 69) / 12.0) * 440.0)
    }
}

@resultBuilder enum PitchBuilder {
    static func buildBlock(_ notes: Note...) -> [Pitch] {
        notes.map { $0⋔ }
    }

    static func buildBlock(_ components: Pitch...) -> [Pitch] {
        components
    }
}

/// Track is a collection of pitches with optional timing information.
public struct Track: Sequence, IteratorProtocol {
    public typealias Element = Pitch
    let pitches: [Pitch]
    public let tempo: Tempo?
    public let timeSignature: TimeSignature?
    var header: Int = 0

    init(_ pitches: [Pitch], tempo: Tempo? = nil, timeSignature: TimeSignature? = nil) {
        self.pitches = pitches
        self.tempo = tempo
        self.timeSignature = timeSignature
    }

    public mutating func next() -> Pitch? {
        if header >= pitches.count { return nil }
        let pitch = pitches[header]
        header += 1
        return pitch
    }

    /// Get the duration of each note if tempo is set
    public func noteDuration(at index: Int) -> Double? {
        guard let tempo = tempo else { return nil }
        // Default to quarter note duration
        return tempo.seconds(for: .quarter)
    }
}

/// 𝄞 takes in a bunch of pitches and returns a Music Sequence
/// - Parameter PitchBuilder: takes in a bunch of pitches
/// - Returns: a track with all the pitches.
public func 𝄞(@PitchBuilder _ makeAbsolutePitches: () -> [Pitch]) -> Track {
    Track(makeAbsolutePitches())
}

/// 𝄞 with tempo - creates a track with timing information
/// - Parameters:
///   - tempo: The tempo for the track (e.g., 120♩ for ♩ = 120 BPM)
///   - makeAbsolutePitches: A builder that creates the pitches
/// - Returns: a track with pitches and tempo
public func 𝄞(tempo: Tempo, @PitchBuilder _ makeAbsolutePitches: () -> [Pitch]) -> Track {
    Track(makeAbsolutePitches(), tempo: tempo)
}

/// 𝄞 with tempo and time signature - creates a fully specified musical track
/// - Parameters:
///   - tempo: The tempo for the track
///   - timeSignature: The time signature for the track
///   - makeAbsolutePitches: A builder that creates the pitches
/// - Returns: a track with pitches, tempo, and time signature
public func 𝄞(tempo: Tempo, timeSignature: TimeSignature, @PitchBuilder _ makeAbsolutePitches: () -> [Pitch]) -> Track {
    Track(makeAbsolutePitches(), tempo: tempo, timeSignature: timeSignature)
}

postfix operator ⋔

extension Pitch: Equatable {
    public static func == (lhs: Pitch, rhs: Pitch) -> Bool { lhs.wrappedValue.isEqual(to: rhs.wrappedValue) }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool { lhs.wrappedValue == rhs.wrappedValue }
}

/// Synthesizer takes an iterable sequence of pitches and synthesizes them.
public protocol Synthesizer {
    func synth(_ track: Track) throws
}
