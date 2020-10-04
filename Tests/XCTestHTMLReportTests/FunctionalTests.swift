import XCTest
import NDHpple
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
        let htmlUrl = try XCTUnwrap(urlFromXCHtmlreportStdout(stdOut))

        let htmlString = try String(contentsOf: htmlUrl, encoding: .utf8)
        let parser = NDHpple(HTMLData: htmlString)
        let uls = try XCTUnwrap(parser.peekAtSearch(withQuery: "//div[@class='tests-header']/ul"))

        let text = uls.children.filter { $0.name == "li" }.compactMap { $0.text }
        XCTAssertTrue(text.contains("All (12)"))
        XCTAssertTrue(text.contains("Passed (3)"))
        XCTAssertTrue(text.contains("Skipped (1)"))
        XCTAssertTrue(text.contains("Failed (8)"))
    }

    static var allTests = [
        ("testExample", testExample),
        ("testBasicFunctionality", testBasicFunctionality),
    ]
}
