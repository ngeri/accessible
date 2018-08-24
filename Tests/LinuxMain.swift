import XCTest

import AccessibleTests

var tests = [XCTestCaseEntry]()
tests += accessibleTests.allTests()
XCTMain(tests)