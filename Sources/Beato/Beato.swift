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
    var number: Int
    public var wrappedValue: Int {
        get { number }
        set { number = newValue }
    }

    public static postfix func ♯ (num: Note) -> Note {
        Note(number: num.number + 1)
    }

    public static postfix func ♭ (num: Note) -> Note {
        Note(number: num.number + 1)
    }
}

postfix operator ♪

public extension Pitch {
    /// Convert an absolute pitch to it's relative pitch class.
    static postfix func ♪ (num: Pitch) -> Note {
        Note(number: Int(round(12 * log2(num.wrappedValue / 440.0))))
    }
}

public extension Note {
    static postfix func ⋔ (_ n: Note) -> Pitch {
        Pitch(hertz: pow(2.0, Double(n.number - 69) / 12.0) * 440.0)
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

/// Track is a collection of pitches.
public struct Track: Sequence, IteratorProtocol {
    public typealias Element = Pitch
    let pitches: [Pitch]
    var header: Int = 0
    init(_ pitches: [Pitch]) {
        self.pitches = pitches
    }

    public mutating func next() -> Pitch? {
        if header >= pitches.count { return nil }
        let pitch = pitches[header]
        header += 1
        return pitch
    }
}

/// 𝄞 takes in a bunch of pitches and returns a Music Sequence
/// - Parameter PitchBuilder: takes in a bunch of pitches
/// - Returns: a pointer with all the pitches.
public func 𝄞(@PitchBuilder _ makeAbsolutePitches: () -> [Pitch]) -> Track {
    Track(makeAbsolutePitches())
}

postfix operator ⋔

extension Pitch: Equatable {
    public static func == (lhs: Pitch, rhs: Pitch) -> Bool { lhs.wrappedValue.isEqual(to: rhs.wrappedValue) }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool { lhs.wrappedValue == rhs.wrappedValue }
}
