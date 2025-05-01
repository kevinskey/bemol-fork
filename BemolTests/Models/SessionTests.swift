import Foundation
import Testing

@testable import Bemol

struct SessionTests {
  @Test
  func summary() async throws {
    let session = Session(
      timestamp: 1000,
      score: [
        Note(name: .c, octave: 1): (4, 2),
        Note(name: .d, octave: 1): (3, 0),
        Note(name: .e, octave: 1): (0, 8),
        Note(name: .f, octave: 1): (4, 1),
        Note(name: .g, octave: 1): (0, 0),
        Note(name: .c, octave: 2): (2, 1),
      ]
    )

    let summary = session.summary

    #expect(summary.correct == 13)
    #expect(summary.wrong == 12)
    #expect(summary.averagePerNote.count == 5)
    #expect(Int(summary.average * 100) == 52)
    #expect(Int((summary.averagePerNote[Note(name: .c, octave: 1)] ?? 0) * 100) == 66)
    #expect(Int((summary.averagePerNote[Note(name: .d, octave: 1)] ?? 0) * 100) == 100)
    #expect(Int((summary.averagePerNote[Note(name: .e, octave: 1)] ?? 0) * 100) == 0)
    #expect(Int((summary.averagePerNote[Note(name: .f, octave: 1)] ?? 0) * 100) == 80)
    #expect(summary.averagePerNote[Note(name: .g, octave: 1)] == nil)
    #expect(Int((summary.averagePerNote[Note(name: .c, octave: 2)] ?? 0) * 100) == 66)
  }
}
