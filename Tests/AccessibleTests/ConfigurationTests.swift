import XCTest
@testable import AccessibleCore

class ConfigurationTests: XCTestCase {

    func testFullConfiguration() {

        let configuration = ConfigurationFactory.decodeConfiguration(fullCorrectlyFormattedConfiguration)

        XCTAssert(configuration != nil, "Correctly formatted '.accessible.yml' MUST NOT be nil")
        XCTAssert(configuration?.outputs.tapMansPath != nil, "outputs.tapMansPath MUST NOT be nil")
    }

    func testOnlyIDsConfiguration() {

        let configuration = ConfigurationFactory.decodeConfiguration(onlyIDsCorrectlyFormattedConfiguration)

        XCTAssert(configuration != nil, "Correctly formatted '.accessible.yml' MUST NOT be nil")
        XCTAssert(configuration?.outputs.tapMansPath == nil, "outputs.tapMansPath MUST BE nil")
    }

    func testWrongConfiguration() {

        let configuration = ConfigurationFactory.decodeConfiguration(wronglyFormattedConfiguration)

        XCTAssert(configuration == nil, "Wrongly formatted '.accessible.yml' MUST BE nil")
    }
}

fileprivate let fullCorrectlyFormattedConfiguration = """
inputs: 
- Inputs/Paths
outputs:
identifiersPath: Identifier/Path
testableExtensionsPath: Testable/Extensions/Path
tapMansPath: Tap/Mans/Path
"""

fileprivate let onlyIDsCorrectlyFormattedConfiguration = """
inputs: 
- Inputs/Paths
outputs:
identifiersPath: Identifier/Path
"""

fileprivate let wronglyFormattedConfiguration = """
inputs: Inputs/Paths
outputs:
identifiersPath: Identifier/Path
tapMansPath: Tap/Mans/Path
"""
