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
            guard let viewController = scene.viewController, let connections = viewController.viewController.connections else  {
                print("Error for outlet: \(String(describing: scene.viewController?.viewController.customClass ?? scene.viewController?.viewController.elementClass))")
                return nil
            }
            let outlets: [Outlet] = connections.compactMap {
                guard let connection = $0.connection as? Outlet else {
                    print("Connection is not Outlet: \($0.connection)")
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
            if allViews.count < outlets.count { print("There must be some error") }
            return ViewControllerTemplate(name: viewControllerName, connections: outlets.compactMap { outlet in
                guard let view = allViews.filter({ $0.id == outlet.destination }).first else {
                    print("Error for outlet: \(outlet.property)")
                    return nil
                }
                return ConnectionTemplate(name: outlet.property, type: view.elementClass)
            })
        })
        guard let unwrappedViewControllerTemplates = viewControllerTemplates else { exit(0) }
        let storyboardName = ((storyboardFile as NSString).lastPathComponent as NSString).deletingPathExtension
        let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: unwrappedViewControllerTemplates)
        storyboardTemplates.append(storyboardTemplate)
    } catch let error {
        print("Something bad happened: \(error)")
    }
})

let templateAccessibilityIdentifiers = try StencilSwiftTemplate(templateString: Path("/Users/ngergo100/Desktop/template-accessibilityIdentifiers.stencil").read(),
                                                                environment: stencilSwiftEnvironment())
let templateTapMan = try StencilSwiftTemplate(templateString: Path("/Users/ngergo100/Desktop/template-tapMan.stencil").read(),
                                                                environment: stencilSwiftEnvironment())
let templateViewControllerExtension = try StencilSwiftTemplate(templateString: Path("/Users/ngergo100/Desktop/template-viewControllerExtension.stencil").read(),
                                                                environment: stencilSwiftEnvironment())

let context = ["storyboards": storyboardTemplates]
let enriched = try StencilContext.enrich(context: context, parameters: [])
let renderedAccessibilityIdentifiers = try templateAccessibilityIdentifiers.render(enriched)
let renderedTapMan = try templateTapMan.render(enriched)
let renderedViewControllerExtension = try templateViewControllerExtension.render(enriched)
print(renderedAccessibilityIdentifiers)
//print(renderedTapMan)
print(renderedViewControllerExtension)
