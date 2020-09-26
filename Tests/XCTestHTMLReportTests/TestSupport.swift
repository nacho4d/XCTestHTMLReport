//
//  File.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2020/09/22.
//

import XCTest
import class Foundation.Bundle

func XCTAssertContains(_ target: @autoclosure () throws -> String, _ substring: @autoclosure () -> String, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertTrue(try target().contains(substring()), file: file, line: line)
}

extension Bundle {
    static let testBundle: Bundle = {
        // This is needed because `Bundle.module` will not work in tests.
        // https://roundwallsoftware.com/swift-package-testing/
        let baseBundle = Bundle(for: FunctionalTests.classForCoder())
        return Bundle(path: baseBundle.bundlePath + "/../XCTestHTMLReport_XCTestHTMLReportTests.bundle")!
    }()
}

extension XCTestCase {

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    /// Helper function to execute xchtmlreport command
    /// Int32 is status
    /// String? is string std out
    /// String? is string std err
    func xchtmlreportCmd(args: [String]) throws -> (Int32, String?, String?) {
        let binaryUrl = productsDirectory.appendingPathComponent("xchtmlreport")

        let process = Process()
        process.executableURL = binaryUrl
        process.arguments = args

        let pipeOut = Pipe()
        process.standardOutput = pipeOut

        let pipeErr = Pipe()
        process.standardError = pipeErr

        try process.run()
        process.waitUntilExit()

        let dataOut = pipeOut.fileHandleForReading.readDataToEndOfFile()
        let outputOut = String(data: dataOut, encoding: .utf8)

        let dataErr = pipeErr.fileHandleForReading.readDataToEndOfFile()
        let outputErr = String(data: dataErr, encoding: .utf8)

        return (process.terminationStatus, outputOut, outputErr)
    }
}
