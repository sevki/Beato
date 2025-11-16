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
}
