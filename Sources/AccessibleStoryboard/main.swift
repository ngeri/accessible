import Foundation
import IBDecodable
import StencilSwiftKit
import PathKit


guard let configuration = ConfigurationFactory.readConfiguration() else {
    log.message(.error, "Cannot find or parse .accessible.yml configuration file. Please check https://github.com/ngergo100/AccessibleStoryboard/blob/master/README.md")
    exit(0)
}

let storyboardFileNames = configuration.storyboardFileNames
guard storyboardFileNames.count > 0 else {
    log.message(.error, "There are no storyboard files at path: \"\(configuration.input)\"")
    exit(0)
}

var storyboardTemplates = [StoryboardTemplate]()
configuration.storyboardFileNames.forEach({ storyboard in
    do  {
        log.message(.info, "Processing storyboard: \(storyboard)")
        let file = try StoryboardFile(path: storyboard)

        let viewControllerTemplates: [ViewControllerTemplate]? = file.document.scenes?.compactMap({ scene -> ViewControllerTemplate? in
            guard let viewController = scene.viewController else  {
                log.message(.error, "An error occured for scene with id: \(scene.id)")
                return nil
            }

            guard let connections = viewController.viewController.connections else {
                log.message(.info, "\(String(describing: viewController.viewController.customClass ?? "")) has no connections")
                return nil
            }
            let outlets: [Outlet] = connections.compactMap {
                guard let connection = $0.connection as? Outlet else {
                    log.message(.info, "Connection is not an Outlet with object: \($0.connection)")
                    return nil
                }
                return connection
            }
            var allViews = [ViewProtocol]()
            if let rootView = viewController.viewController.rootView {
                allViews.append(rootView)
                allViews.append(contentsOf: rootView.getAllSubviews())
            }
            var viewControllerName = viewController.viewController.elementClass
            if let customClass = viewController.viewController.customClass, let range = customClass.range(of: "ViewController") {
                viewControllerName = String(customClass[..<range.lowerBound])
            }

            let mappedConnections = outlets.reduce(into: [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]](), { result, outlet in
                guard let view = allViews.filter({ $0.id == outlet.destination }).first else {
                    log.message(.info, "Outlet with name '\(outlet.property)' has no view attached.")
                    return
                }

                let viewType = ConnectionTypeTemplate.mapViewClassToViewType(type: view.elementClass)

                if result[viewType] != nil {
                    result[viewType]?.append(ConnectionTemplate(name: outlet.property))
                } else {
                    result[viewType] = [ConnectionTemplate(name: outlet.property)]
                }
            })

            let templateConnections: [ConnectionTypeTemplate] = mappedConnections.map { name, connections in
                return ConnectionTypeTemplate(name: name, connections: connections)
            }

            return ViewControllerTemplate(name: viewControllerName, connections: templateConnections)
        })
        guard let unwrappedViewControllerTemplates = viewControllerTemplates else {
            log.message(.error, "IBDecodable failed to decode storyboard named: \(storyboard)")
            return
        }
        let storyboardName = ((storyboard as NSString).lastPathComponent as NSString).deletingPathExtension
        let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: unwrappedViewControllerTemplates)
        storyboardTemplates.append(storyboardTemplate)
    } catch let error {
        log.message(.error, "Something really bad happened: \(error)")
    }
})

let context: [String: Any] = ["accessibiltyEnumName": configuration.enumName ?? "Accessible",
                              "date": DateFormatter.as.string(from: Date()),
                              "storyboards": storyboardTemplates]
let enriched = try StencilContext.enrich(context: context, parameters: [])

let accessibilityIdentifiersTemplate = StencilSwiftTemplate(templateString: accessibilityIdentifiers, environment: stencilSwiftEnvironment())
let extensionsTemplate               = StencilSwiftTemplate(templateString: extensions, environment: stencilSwiftEnvironment())
let tapManTemplate                   = StencilSwiftTemplate(templateString: tapMans, environment: stencilSwiftEnvironment())

let accessibilityIdentifiersRendered = try accessibilityIdentifiersTemplate.render(enriched)
let extensionsRendered               = try extensionsTemplate.render(enriched)
let tapManRendered                   = try tapManTemplate.render(enriched)


write(content: accessibilityIdentifiersRendered, to: "\(configuration.output)/AccessibilityIdentifiers.swift")
write(content: extensionsRendered, to: "\(configuration.output)/Extensions.swift")
write(content: tapManRendered, to: "\(configuration.output)/TapMans.swift")
