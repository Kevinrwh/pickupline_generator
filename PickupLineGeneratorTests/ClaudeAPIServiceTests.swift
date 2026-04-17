import Testing
import Foundation
@testable import PickupLineGenerator

@Suite("ClaudeAPIService Parsing Tests")
struct ClaudeAPIServiceTests {
    private let service = ClaudeAPIService()

    @Test func parsesNumberedLines() async {
        let text = """
        1. Are you a magnet? Because I'm attracted to you.
        2. Do you have a map? I keep getting lost in your eyes.
        3. Are you a campfire? Because you're hot.
        4. Is your name Google? Because you have everything I've been searching for.
        5. Are you a bank loan? Because you've got my interest.
        """
        let lines = await service.parseLines(from: text)
        #expect(lines.count == 5)
        #expect(lines[0].hasPrefix("Are you a magnet"))
        #expect(!lines[0].hasPrefix("1."))
    }

    @Test func parsesLinesWithoutNumbers() async {
        let text = """
        Are you a magnet?
        Do you have a map?
        Are you a campfire?
        """
        let lines = await service.parseLines(from: text)
        #expect(lines.count == 3)
    }

    @Test func stripsEmptyLines() async {
        let text = """
        1. First line

        2. Second line

        3. Third line
        """
        let lines = await service.parseLines(from: text)
        #expect(lines.count == 3)
    }

    @Test func limitsToFiveLines() async {
        let text = (1...10).map { "\($0). Line \($0)" }.joined(separator: "\n")
        let lines = await service.parseLines(from: text)
        #expect(lines.count == 5)
    }

    @Test func handlesEmptyInput() async {
        let lines = await service.parseLines(from: "")
        #expect(lines.isEmpty)
    }

    @Test func handlesWhitespaceOnlyInput() async {
        let lines = await service.parseLines(from: "   \n  \n   ")
        #expect(lines.isEmpty)
    }
}
