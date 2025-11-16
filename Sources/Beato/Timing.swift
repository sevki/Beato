//
//  Timing.swift
//  Beato
//
//  Time control parameters for musical timing and tempo
//

import Foundation

// MARK: - Tempo

/// Represents musical tempo in beats per minute
/// Example: Tempo(bpm: 120) represents ♩ = 120
public struct Tempo {
    /// Beats per minute
    public let bpm: Double

    /// The note value that gets one beat (default is quarter note)
    public let beatNote: Duration

    public init(bpm: Double, beatNote: Duration = .quarter) {
        self.bpm = bpm
        self.beatNote = beatNote
    }

    /// Duration of one beat in seconds
    public var secondsPerBeat: Double {
        60.0 / bpm * beatNote.relativeValue
    }

    /// Convert a duration to seconds at this tempo
    public func seconds(for duration: Duration) -> Double {
        secondsPerBeat * (duration.relativeValue / beatNote.relativeValue)
    }
}

// MARK: - Duration

/// Represents musical note durations
public enum Duration {
    case whole
    case half
    case quarter
    case eighth
    case sixteenth
    case thirtySecond

    // Dotted notes (1.5x the original duration)
    case dottedWhole
    case dottedHalf
    case dottedQuarter
    case dottedEighth
    case dottedSixteenth

    // Triplets (2/3 of the original duration)
    case tripletHalf
    case tripletQuarter
    case tripletEighth

    /// Custom duration as a fraction of a whole note
    case custom(Double)

    /// Relative value compared to a whole note
    /// Whole note = 1.0, half = 0.5, quarter = 0.25, etc.
    public var relativeValue: Double {
        switch self {
        case .whole: return 1.0
        case .half: return 0.5
        case .quarter: return 0.25
        case .eighth: return 0.125
        case .sixteenth: return 0.0625
        case .thirtySecond: return 0.03125

        case .dottedWhole: return 1.5
        case .dottedHalf: return 0.75
        case .dottedQuarter: return 0.375
        case .dottedEighth: return 0.1875
        case .dottedSixteenth: return 0.09375

        case .tripletHalf: return 0.5 * (2.0 / 3.0)
        case .tripletQuarter: return 0.25 * (2.0 / 3.0)
        case .tripletEighth: return 0.125 * (2.0 / 3.0)

        case .custom(let value): return value
        }
    }

    /// Convert to seconds given a tempo
    public func toSeconds(tempo: Tempo) -> Double {
        tempo.seconds(for: self)
    }
}

// MARK: - Musical Operators

postfix operator ♩  // Quarter note
postfix operator 𝅗𝅥  // Half note
postfix operator 𝅝   // Whole note
postfix operator ♪  // Eighth note (reusing existing operator)

public extension Int {
    /// Convert BPM integer to Tempo
    /// Usage: 120♩ represents ♩ = 120 BPM
    static postfix func ♩ (bpm: Int) -> Tempo {
        Tempo(bpm: Double(bpm), beatNote: .quarter)
    }
}

// MARK: - Time Signature

/// Represents a musical time signature
public struct TimeSignature {
    /// Number of beats per measure
    public let beatsPerMeasure: Int

    /// Note value that gets one beat
    public let beatNote: Duration

    public init(beatsPerMeasure: Int, beatNote: Duration = .quarter) {
        self.beatsPerMeasure = beatsPerMeasure
        self.beatNote = beatNote
    }

    /// Common time signatures
    public static let commonTime = TimeSignature(beatsPerMeasure: 4, beatNote: .quarter)     // 4/4
    public static let cutTime = TimeSignature(beatsPerMeasure: 2, beatNote: .half)          // 2/2
    public static let waltzTime = TimeSignature(beatsPerMeasure: 3, beatNote: .quarter)     // 3/4
    public static let marchTime = TimeSignature(beatsPerMeasure: 2, beatNote: .quarter)     // 2/4
    public static let compoundTime = TimeSignature(beatsPerMeasure: 6, beatNote: .eighth)   // 6/8
}

// MARK: - Timed Note

/// A note with duration information
public struct TimedNote {
    public let pitch: Pitch
    public let duration: Duration

    public init(pitch: Pitch, duration: Duration) {
        self.pitch = pitch
        self.duration = duration
    }
}

extension Tempo: Equatable {
    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        lhs.bpm == rhs.bpm && lhs.beatNote.relativeValue == rhs.beatNote.relativeValue
    }
}

extension Duration: Equatable {
    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        lhs.relativeValue == rhs.relativeValue
    }
}

extension TimeSignature: Equatable {
    public static func == (lhs: TimeSignature, rhs: TimeSignature) -> Bool {
        lhs.beatsPerMeasure == rhs.beatsPerMeasure && lhs.beatNote == rhs.beatNote
    }
}
