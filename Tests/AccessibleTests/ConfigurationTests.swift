import XCTest
@testable import AccessibleCore

class ConfigurationTests: XCTestCase {

    func testCase() {

    	let testableVC = ViewControllerTemplate(name: "Name", connections: [])

        XCTAssertEqual(testableVC.name, "Name")
    }
}
