import XCTest
import class Foundation.Bundle

final class FunctionalTests: XCTestCase {

    func testExample() throws {

        let (status, maybeStdOut, maybeStdErr) = try xchtmlreportCmd(args: [])

        XCTAssertEqual(status, 1)
        XCTAssertEqual(maybeStdErr?.isEmpty, true)
        let stdOut = try XCTUnwrap(maybeStdOut)
        XCTAssertContains(stdOut, "Error: Argument -r is required")
    }

    func testBasicFunctionality() throws {
        let testResultsUrl = try XCTUnwrap(Bundle.testBundle.url(forResource: "TestResults", withExtension: "xcresult"))

        let (status, maybeStdOut, maybeStdErr) = try xchtmlreportCmd(args: ["-r", testResultsUrl.path])

        XCTAssertEqual(status, 0)
        XCTAssertEqual((maybeStdErr ?? "").isEmpty, true)
        let stdOut = try XCTUnwrap(maybeStdOut)
        XCTAssertContains(stdOut, " successfully created at ")
    }

    static var allTests = [
        ("testExample", testExample),
        ("testBasicFunctionality", testBasicFunctionality),
    ]
}
