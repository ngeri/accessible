import Foundation
import IBDecodable

struct AccessibleParser {
    static func decodeStoryboards(with storyboardPaths: [String]) -> [StoryboardTemplate] {
        let storyboardTemplates: [StoryboardTemplate] = storyboardPaths.compactMap({ storyboardPath in
            do  {
                log.message(.info, "Processing storyboard: \(storyboardPath)")
                let file = try StoryboardFile(path: storyboardPath)

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

                    let subviewsOfViewController = getAllViews(for: viewController)
                    let mappedConnections = groupConnections(outlets: outlets, allSubviews: subviewsOfViewController)

                    let templateConnections: [ConnectionTypeTemplate] = mappedConnections.map { name, connections in
                        return ConnectionTypeTemplate(name: name, connections: connections)
                    }

                    var viewControllerName = viewController.viewController.elementClass
                    if let customClass = viewController.viewController.customClass {
                        let lowerBound = customClass.range(of: "ViewController")?.lowerBound ?? customClass.endIndex
                        viewControllerName = String(customClass[..<lowerBound])
                    } else {
                        log.message(.warning, "Cannot detect custom class type")
                    }

                    return ViewControllerTemplate(name: viewControllerName, connections: templateConnections)
                })
                guard let unwrappedViewControllerTemplates = viewControllerTemplates else {
                    log.message(.error, "IBDecodable failed to decode storyboard named: \(storyboardPath)")
                    return nil
                }
                let storyboardName = ((storyboardPath as NSString).lastPathComponent as NSString).deletingPathExtension
                let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: unwrappedViewControllerTemplates)
                return storyboardTemplate
            } catch let error {
                log.message(.error, "Something really bad happened: \(error)")
                return nil
            }
        })
        return storyboardTemplates
    }

    // MARK: - Helpers

    static private func getAllViews(for viewController: AnyViewController) -> [ViewProtocol] {
        guard let rootView = viewController.viewController.rootView else {
            log.message(.info, "Cannot get root view of \(viewController.viewController.customClass ?? viewController.viewController.elementClass)")
            return []
        }
        return [rootView] + rootView.getAllSubviews() 
    }

    static private func groupConnections(outlets: [Outlet], allSubviews: [ViewProtocol]) -> [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]] {
        let mappedConnections = outlets.reduce(into: [ConnectionTypeTemplate.ViewType: [ConnectionTemplate]](), { result, outlet in
            guard let view = allSubviews.filter({ $0.id == outlet.destination }).first else {
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
}
