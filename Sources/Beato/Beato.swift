import AudioToolbox

postfix operator ♭
postfix operator ♯

@propertyWrapper
struct Pitch {
    var hertz: Double
    var wrappedValue: Double {
        get { hertz }
        set { hertz = newValue }
    }

    // Increases the pitch by 12th parts
    static postfix func ♯ (num: Pitch) -> Pitch {
        return Pitch(hertz: num.hertz * 1.0594630943592953)
    }

    // Decreases the pitch by 12th parts
    static postfix func ♭ (num: Pitch) -> Pitch {
        return Pitch(hertz: num.hertz * 0.9438743126816935)
    }
}

@propertyWrapper
struct Note {
    var number: Int
    var wrappedValue: Int {
        get { number }
        set { number = newValue }
    }

    static postfix func ♯ (num: Note) -> Note {
        return Note(number: num.number + 1)
    }

    static postfix func ♭ (num: Note) -> Note {
        return Note(number: num.number + 1)
    }
}

postfix operator ♪

extension Pitch {
    // Convert a pitch to a MIDI note number
    static postfix func ♪ (num: Pitch) -> Note {
        return Note(number: Int(round(12 * log2(num.wrappedValue / 440.0))))
    }
}

enum MIDI {
    enum Notes {
        static let 🤫 = Note(number: -1)
        // C4
        static let C = Note(number: 60)
        // D
        static let D = Note(number: 62)
        // E
        static let E = Note(number: 64)
        // F
        static let F = Note(number: 65)
        // G
        static let G = Note(number: 67)
        // A
        static let A = Note(number: 69)
        // B
        static let B = Note(number: 71)
    }
}

@resultBuilder
enum NoteBuilder {
    static func buildBlock(_ notes: Note...) -> [MIDINoteMessage] {
        notes.map {
            if $0 == MIDI.Notes.🤫 {
                return MIDINoteMessage(channel: 0, note: 0, velocity: 0, releaseVelocity: 0, duration: 1)
            } else {
                return MIDINoteMessage(channel: 1,
                                       note: UInt8($0.number),
                                       velocity: 64,
                                       releaseVelocity: 64,

                                       duration: 1)
            }
        }
    }
}

func 𝄞(@NoteBuilder _ makeNotes: () -> [MIDINoteMessage]) -> MusicSequence {
    var sequence: MusicSequence?
    NewMusicSequence(&sequence)

    var track: MusicTrack?
    var musicTrack = MusicSequenceNewTrack(sequence!, &track)

    var time = MusicTimeStamp(1.0)

    for n in makeNotes() {
        var note = n
        musicTrack = MusicTrackNewMIDINoteEvent(track!, time, &note)
        time += 0.4
    }
    return sequence!
}

postfix operator ⋔

extension Note {
    static postfix func ⋔ (_ n: Note) -> Pitch {
        // Convert a MIDI number to a pitch
        // In electronic music, pitch is often given by MIDI number: let's call it m for our purposes.
        // m for the note A4 is 69 and increases by one for each equal tempered semitone, so this gives
        // us a simple conversion between frequencies and MIDI numbers (again using 440 Hz as the pitch of A4):
        // fm  = 2(m−69)/12(440 Hz)
        // https://newt.phys.unsw.edu.au/jw/notes.html
        return Pitch(hertz: pow(2.0, Double(n.number - 69) / 12.0) * 440.0)
    }
}

extension Pitch: Equatable {
    static func == (lhs: Pitch, rhs: Pitch) -> Bool { lhs.wrappedValue.isEqual(to: rhs.wrappedValue) }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool { lhs.wrappedValue == rhs.wrappedValue }
}
