// SPDX-License-Identifier: GPL-2.0-or-later

import XCTest
import OSLog
import Foundation
@testable import JunioRBank

let logger: Logger = Logger(subsystem: "JunioRBank", category: "Tests")

@available(macOS 13, *)
final class JunioRBankTests: XCTestCase {

    func testJunioRBank() throws {
        logger.log("running testJunioRBank")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }

    func testDecodeType() throws {
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("JunioRBank", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
