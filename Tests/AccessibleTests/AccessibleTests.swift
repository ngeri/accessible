import XCTest
@testable import AccessibleCore

final class AccessibleTests: XCTestCase {
    func testCase() {

    	let testableVC = ViewControllerTemplate(name: "Name", connections: [])

        XCTAssertEqual(testableVC.name, "Name")
        XCTAssertEqual("Name", "Name")
    }
}
