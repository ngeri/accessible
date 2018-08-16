import Foundation
import IBDecodable
import StencilSwiftKit
import PathKit

let fileManager = FileManager.default
let currentDirectoryPath = fileManager.currentDirectoryPath

private let storyboardExtension = ".storyboard"

let files = fileManager.subpaths(atPath: currentDirectoryPath)
let storyboardFiles = files?.filter { $0.hasSuffix(storyboardExtension) }

var storyboardTemplates = [StoryboardTemplate]()
storyboardFiles?.forEach({ storyboardFile in
    do  {
        let file = try StoryboardFile(path: storyboardFile)

        let viewControllerTemplates: [ViewControllerTemplate]? = file.document.scenes?.compactMap({ scene -> ViewControllerTemplate? in
            guard let viewController = scene.viewController else  {
                print("An error occured for scene with id: \(scene.id)")
                return nil
            }

            guard let connections = viewController.viewController.connections else {
                print("\(String(describing: viewController.viewController.customClass ?? "")) has no connections")
                return nil
            }
            let outlets: [Outlet] = connections.compactMap {
                guard let connection = $0.connection as? Outlet else {
                    print("Connection is not an Outlet with name: \($0.connection)")
                    return nil
                }
                return connection
            }
            var allViews = [ViewProtocol]()
            if let rootView = viewController.viewController.rootView {
                allViews.append(rootView)
                allViews.append(contentsOf: rootView.getAllSubview())
            }
            var viewControllerName = viewController.viewController.elementClass
            if let customClass = viewController.viewController.customClass, let range = customClass.range(of: "ViewController") {
                viewControllerName = String(customClass[..<range.lowerBound])
            }

            let mappedConnections = outlets.reduce(into: [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]](), { result, outlet in
                guard let view = allViews.filter({ $0.id == outlet.destination }).first else {
                    print("Outlet with name: \(outlet.property) has no view attached.")
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
        guard let unwrappedViewControllerTemplates = viewControllerTemplates else { exit(0) }
        let storyboardName = ((storyboardFile as NSString).lastPathComponent as NSString).deletingPathExtension
        let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: unwrappedViewControllerTemplates)
        storyboardTemplates.append(storyboardTemplate)
    } catch let error {
        print("Something bad happened: \(error)")
    }
})

let context: [String: Any] = ["storyboards": storyboardTemplates,
                              "date": DateFormatter.as.string(from: Date())]
let enriched = try StencilContext.enrich(context: context, parameters: [])

let accessibilityIdentifiersTemplate = StencilSwiftTemplate(templateString: accessibilityIdentifiers, environment: stencilSwiftEnvironment())
let tapManTemplate                   = StencilSwiftTemplate(templateString: tapMans, environment: stencilSwiftEnvironment())
let extensionsTemplate               = StencilSwiftTemplate(templateString: extensions, environment: stencilSwiftEnvironment())

let accessibilityIdentifiersRendered = try accessibilityIdentifiersTemplate.render(enriched)
let tapManRendered                   = try tapManTemplate.render(enriched)
let extensionsRendered               = try extensionsTemplate.render(enriched)
print(accessibilityIdentifiersRendered)
print(tapManRendered)
print(extensionsRendered)
