import Foundation
import IBDecodable

struct AccessibleParser {
    static func decodeStoryboards(with storyboardPaths: [String]) -> [StoryboardTemplate] {
        let storyboardTemplates: [StoryboardTemplate] = storyboardPaths.compactMap { storyboardPath in
            log.message(.info, "Processing \((storyboardPath as NSString).lastPathComponent)...")
            let file = try? StoryboardFile(path: storyboardPath)

            guard let scenes = file?.document.scenes else {
                log.message(.error, "IBDecodable failed to decode storyboard named: \(storyboardPath)")
                return nil
            }

            let viewControllerTemplates: [ViewControllerTemplate] = scenes.compactMap { AccessibleParser.decodeScreen(scene: $0) }
            let storyboardName = ((storyboardPath as NSString).lastPathComponent as NSString).deletingPathExtension
            let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: viewControllerTemplates)
            return storyboardTemplate
        }
        return storyboardTemplates
    }

    // MARK: - Helpers
    static private func decodeScreen(scene: Scene) -> ViewControllerTemplate? {
        guard let viewController = scene.viewController else {
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

        let subviewsOfViewController = getAllViews(for: viewController)
        let mappedConnections = groupConnections(outlets: outlets, allSubviews: subviewsOfViewController)

        let templateConnections: [ConnectionTypeTemplate] = mappedConnections.map { name, connections in
            return ConnectionTypeTemplate(name: name, connections: connections)
        }

        let name = viewControllerName(customClass: viewController.viewController.customClass, elementClass: viewController.viewController.elementClass)
        return ViewControllerTemplate(name: name, connections: templateConnections)
    }

    static private func getAllViews(for viewController: AnyViewController) -> [ViewProtocol & IBIdentifiable] {
        guard let rootView = viewController.viewController.rootView else {
            log.message(.info, "Cannot get root view of \(viewController.viewController.customClass ?? viewController.viewController.elementClass)")
            return []
        }
        return ([rootView] + rootView.getAllSubviews()).compactMap { $0 as? (ViewProtocol & IBIdentifiable) }
    }

    static private func groupConnections(outlets: [Outlet], allSubviews: [ViewProtocol & IBIdentifiable]) -> [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]] {
        let mappedConnections = outlets.reduce(into: [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]](), { result, outlet in
            guard let view = allSubviews.first(where: { $0.id == outlet.destination }) else {
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
        return mappedConnections
    }

    static func viewControllerName(customClass: String?, elementClass: String?) -> String {
        guard let customClass = customClass else {
            return elementClass ?? "Unknown"
        }

        var viewControllerName = customClass
        if let lowerBound = customClass.range(of: "ViewController")?.lowerBound, lowerBound != customClass.startIndex {
           viewControllerName = String(customClass[..<lowerBound])
        }

        return viewControllerName
    }
}
