import Foundation
import StencilSwiftKit
import PathKit

public class AccessibleTool {

	public init() {}

	public func run() throws {
		guard let configuration = ConfigurationFactory.readConfiguration() else {
		    log.message(.error, "Cannot find or parse .accessible.yml configuration file. Please check https://github.com/ngergo100/Accessible")
		    exit(0)
		}

		let storyboardFileNames = configuration.storyboardFileNames
		guard storyboardFileNames.count > 0 else {
		    log.message(.error, "There are no storyboard files at the given paths")
		    exit(0)
		}

		let storyboardTemplates = AccessibleParser.decodeStoryboards(with: storyboardFileNames)

		let context: [String: Any] = ["accessibiltyEnumName": configuration.enumName ?? "Accessible",
		                              "date": DateFormatter.accessible.string(from: Date()),
		                              "storyboards": storyboardTemplates]
		let enriched = try StencilContext.enrich(context: context, parameters: [])

		let accessibilityIdentifiersTemplate = StencilSwiftTemplate(templateString: accessibilityIdentifiers, environment: stencilSwiftEnvironment())
		let extensionsTemplate               = StencilSwiftTemplate(templateString: extensions, environment: stencilSwiftEnvironment())
		let tapManTemplate                   = StencilSwiftTemplate(templateString: tapMans, environment: stencilSwiftEnvironment())

		let accessibilityIdentifiersRendered = try accessibilityIdentifiersTemplate.render(enriched)
		let extensionsRendered               = try extensionsTemplate.render(enriched)
		let tapManRendered                   = try tapManTemplate.render(enriched)


		write(content: accessibilityIdentifiersRendered, to: "\(configuration.outputs.identifiersPath)/AccessibilityIdentifiers.swift")
		if let testableExtensionsPath = configuration.outputs.testableExtensionsPath {
		    write(content: extensionsRendered, to: "\(testableExtensionsPath)/UITestableExtensions.swift")
		}
		if let tapMansPath = configuration.outputs.tapMansPath {
		    write(content: tapManRendered, to: "\(tapMansPath)/UITapMans.swift")
		}

	}
}

