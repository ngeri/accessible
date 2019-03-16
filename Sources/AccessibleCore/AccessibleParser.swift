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
            let storyboardTemplate = StoryboardTemplate(name: storyboardName, filePath: storyboardPath, viewControllers: viewControllerTemplates)
            return storyboardTemplate
        }
        return storyboardTemplates
    }
}
// MARK: - Helper extension
fileprivate extension AccessibleParser {

    static func decodeScreen(scene: Scene) -> ViewControllerTemplate? {
        guard let viewController = scene.viewController else {
            log.message(.error, "An error occured for scene with id: \(scene.id)")
            return nil
        }

        let viewTypeTemplates = fetchAllViews(for: viewController)

        return ViewControllerTemplate(name: createFormattedNameFromViewControllerClass(viewController), viewTypeTemplates: viewTypeTemplates)
    }

    static func fetchAllViews(for viewController: AnyViewController) -> [ViewTypeTemplate] {
        guard let rootView = viewController.viewController.rootView as? (ViewProtocol & IBIdentifiable) else {
            log.message(.info, "Cannot get root view of \(viewController.viewController.customClass ?? viewController.viewController.elementClass)")
            return []
        }

        let allViews = rootView.allSubviews + [rootView]

        let grouppedViews = allViews.reduce(into: [ViewTypeTemplate.ViewType: [ViewTemplate]]()) { result, view in
            let viewType = ViewTypeTemplate.mapViewClassToViewType(type: view.elementClass)
            if result[viewType] != nil {
                result[viewType]?.append(ViewTemplate(name: view.userLabel ?? view.id))
            } else {
                result[viewType] = [ViewTemplate(name: view.userLabel ?? view.id)]
            }
        }

        return grouppedViews.map { return ViewTypeTemplate(name: $0.key, viewTemplates: $0.value) }
    }

    static func createFormattedNameFromViewControllerClass(_ viewController: AnyViewController) -> String {
        guard let customClass = viewController.viewController.customClass else {
            return viewController.viewController.elementClass
        }

        var viewControllerName = customClass
        if let lowerBound = customClass.range(of: "ViewController")?.lowerBound, lowerBound != customClass.startIndex {
            viewControllerName = String(customClass[..<lowerBound])
        }

        return viewControllerName
    }
}
