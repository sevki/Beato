@testable import Beato
import XCTest

final class BeatoTests: XCTestCase {
    func testNoteToAbsolutePitch() throws {
        // A4 (step 69) should be 440 Hz
        XCTAssertEqual(Note(step: 69)⋔, Pitch(hertz: 440.0))
    }

    func testSharpOperatorOnPitch() throws {
        // A4 sharp should increase frequency by semitone ratio
        let a4 = Pitch(hertz: 440.0)
        let a4Sharp = a4♯
        XCTAssertEqual(a4Sharp.wrappedValue, 440.0 * 1.0594630943592953, accuracy: 0.001)
    }

    func testFlatOperatorOnPitch() throws {
        // A4 flat should decrease frequency by semitone ratio
        let a4 = Pitch(hertz: 440.0)
        let a4Flat = a4♭
        XCTAssertEqual(a4Flat.wrappedValue, 440.0 * 0.9438743126816935, accuracy: 0.001)
    }

    func testSharpOperatorOnNote() throws {
        // A4 sharp should be one step higher
        let a4 = Note(step: 69)
        let a4Sharp = a4♯
        XCTAssertEqual(a4Sharp.wrappedValue, 70)
    }

    func testFlatOperatorOnNote() throws {
        // A4 flat should be one step lower
        let a4 = Note(step: 69)
        let a4Flat = a4♭
        XCTAssertEqual(a4Flat.wrappedValue, 68)
    }

    func testPitchToNote() throws {
        // 440 Hz should convert to Note step 69 (A4)
        let pitch = Pitch(hertz: 440.0)
        let note = pitch♪
        XCTAssertEqual(note.wrappedValue, 0) // Relative to 440 Hz base
    }

    func testTrackBuilder() throws {
        // Test building a track with the 𝄞 function
        let track = 𝄞 {
            Note(step: 69)⋔  // A4
            Note(step: 71)⋔  // B4
            Note(step: 72)⋔  // C5
        }

        var iterator = track.makeIterator()
        XCTAssertEqual(iterator.next(), Pitch(hertz: 440.0))
        XCTAssertNotNil(iterator.next())
        XCTAssertNotNil(iterator.next())
        XCTAssertNil(iterator.next())
    }

    func testKarplusStrongSynthesizer() throws {
        // Test that Karplus-Strong can synthesize a track
        let track = 𝄞 {
            Note(step: 69)⋔  // A4
        }

        let synthesizer = KarplusStrong(sampleRate: 44100.0, noteDuration: 0.1)
        XCTAssertNoThrow(try synthesizer.synth(track))
    }

    func testKarplusStrongGeneratesSamples() throws {
        // Test that the synthesize method generates the correct number of samples
        let synthesizer = KarplusStrong(sampleRate: 44100.0, noteDuration: 1.0)
        let samples = synthesizer.synthesize(frequency: 440.0, duration: 1.0)

        // Should generate approximately 1 second of samples at 44100 Hz
        XCTAssertEqual(samples.count, 44100)
    }

    func testMultipleOperations() throws {
        // Test chaining operations
        let a4 = Note(step: 69)
        let a4SharpSharp = a4♯♯
        XCTAssertEqual(a4SharpSharp.wrappedValue, 71)

        let pitch = Pitch(hertz: 440.0)
        let pitchSharpFlat = pitch♯♭
        // Sharp then flat should return approximately to original
        XCTAssertEqual(pitchSharpFlat.wrappedValue, 440.0, accuracy: 0.1)
    }

    // MARK: - Timing Tests

    func testTempoCreation() throws {
        // Test creating tempo with BPM
        let tempo = Tempo(bpm: 120, beatNote: .quarter)
        XCTAssertEqual(tempo.bpm, 120)
        XCTAssertEqual(tempo.beatNote, .quarter)
    }

    func testTempoOperator() throws {
        // Test ♩ operator for creating tempo
        let tempo = 120♩
        XCTAssertEqual(tempo.bpm, 120)
        XCTAssertEqual(tempo.beatNote, .quarter)
    }

    func testTempoSecondsPerBeat() throws {
        // At 120 BPM with quarter notes, each beat is 0.5 seconds
        let tempo = Tempo(bpm: 120, beatNote: .quarter)
        XCTAssertEqual(tempo.secondsPerBeat, 0.5, accuracy: 0.001)

        // At 60 BPM, each beat is 1.0 second
        let slowTempo = Tempo(bpm: 60, beatNote: .quarter)
        XCTAssertEqual(slowTempo.secondsPerBeat, 1.0, accuracy: 0.001)
    }

    func testDurationValues() throws {
        // Test relative values of different durations
        XCTAssertEqual(Duration.whole.relativeValue, 1.0)
        XCTAssertEqual(Duration.half.relativeValue, 0.5)
        XCTAssertEqual(Duration.quarter.relativeValue, 0.25)
        XCTAssertEqual(Duration.eighth.relativeValue, 0.125)
        XCTAssertEqual(Duration.sixteenth.relativeValue, 0.0625)

        // Test dotted notes (1.5x original)
        XCTAssertEqual(Duration.dottedQuarter.relativeValue, 0.375)
        XCTAssertEqual(Duration.dottedHalf.relativeValue, 0.75)

        // Test triplets (2/3 of original)
        XCTAssertEqual(Duration.tripletQuarter.relativeValue, 0.25 * (2.0/3.0), accuracy: 0.001)
    }

    func testDurationToSeconds() throws {
        let tempo = Tempo(bpm: 120, beatNote: .quarter)

        // Quarter note at 120 BPM = 0.5 seconds
        XCTAssertEqual(Duration.quarter.toSeconds(tempo: tempo), 0.5, accuracy: 0.001)

        // Half note = 1.0 second
        XCTAssertEqual(Duration.half.toSeconds(tempo: tempo), 1.0, accuracy: 0.001)

        // Whole note = 2.0 seconds
        XCTAssertEqual(Duration.whole.toSeconds(tempo: tempo), 2.0, accuracy: 0.001)

        // Eighth note = 0.25 seconds
        XCTAssertEqual(Duration.eighth.toSeconds(tempo: tempo), 0.25, accuracy: 0.001)
    }

    func testTimeSignatures() throws {
        // Test common time signatures
        XCTAssertEqual(TimeSignature.commonTime.beatsPerMeasure, 4)
        XCTAssertEqual(TimeSignature.commonTime.beatNote, .quarter)

        XCTAssertEqual(TimeSignature.waltzTime.beatsPerMeasure, 3)
        XCTAssertEqual(TimeSignature.waltzTime.beatNote, .quarter)

        XCTAssertEqual(TimeSignature.cutTime.beatsPerMeasure, 2)
        XCTAssertEqual(TimeSignature.cutTime.beatNote, .half)
    }

    func testTrackWithTempo() throws {
        // Create a track with tempo
        let track = 𝄞(tempo: 120♩) {
            Note(step: 69)⋔  // A4
            Note(step: 71)⋔  // B4
        }

        XCTAssertNotNil(track.tempo)
        XCTAssertEqual(track.tempo?.bpm, 120)
        XCTAssertEqual(track.tempo?.beatNote, .quarter)
    }

    func testTrackWithTempoAndTimeSignature() throws {
        // Create a track with tempo and time signature
        let track = 𝄞(tempo: 120♩, timeSignature: .commonTime) {
            Note(step: 69)⋔  // A4
            Note(step: 71)⋔  // B4
            Note(step: 72)⋔  // C5
        }

        XCTAssertNotNil(track.tempo)
        XCTAssertNotNil(track.timeSignature)
        XCTAssertEqual(track.tempo?.bpm, 120)
        XCTAssertEqual(track.timeSignature?.beatsPerMeasure, 4)
    }

    func testTrackNoteDuration() throws {
        let tempo = Tempo(bpm: 120, beatNote: .quarter)
        let track = 𝄞(tempo: tempo) {
            Note(step: 69)⋔
        }

        // Note duration should be 0.5 seconds at 120 BPM for quarter notes
        XCTAssertEqual(track.noteDuration(at: 0), 0.5, accuracy: 0.001)
    }

    func testCustomDuration() throws {
        // Test custom duration (e.g., 3/8 note)
        let customDuration = Duration.custom(0.375)
        XCTAssertEqual(customDuration.relativeValue, 0.375)

        let tempo = Tempo(bpm: 120)
        // At 120 BPM, 3/8 note = 0.75 seconds
        XCTAssertEqual(customDuration.toSeconds(tempo: tempo), 0.75, accuracy: 0.001)
    }
}
