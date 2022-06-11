import XCTest
@testable import Beato

final class BeatoTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Beato.MIDI.Notes.A⋔, Pitch(hertz: 440.0))
    }
}
