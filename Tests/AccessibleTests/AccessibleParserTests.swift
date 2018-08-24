import XCTest
@testable import Accessible

final class AccessibleParserTests: XCTestCase {
    func test_viewControllerNameFrom_defaultViewController() {
        let customClassName = "ViewController"
        let viewController = FakeViewController(customClass: customClassName)
        
        XCTAssertEqual(AccessibleParser.viewControllerName(from: viewController), "ViewController")
    }
    
    static var allTests = [
        ("test_viewControllerNameFrom_defaultViewController", test_viewControllerNameFrom_defaultViewController),
    ]
}
