import Foundation
import IBDecodable
import Stencil

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
            guard let viewController = scene.viewController, let connections = viewController.viewController.connections else  { return nil }
            let outlets = connections.compactMap({ $0.connection as? Outlet})
            return ViewControllerTemplate(name: viewController.viewController.customClass ?? "UnknownViewController",
                                          connections: outlets.compactMap({ ConnectionTemplate(name: $0.property )}))
        })
        guard let unwrappedViewControllerTemplates = viewControllerTemplates else { exit(0) }
        let storyboardName = ((storyboardFile as NSString).lastPathComponent as NSString).deletingPathExtension
        let storyboardTemplate = StoryboardTemplate(name: storyboardName, viewControllers: unwrappedViewControllerTemplates)
        storyboardTemplates.append(storyboardTemplate)
    } catch let error {
        print(error)
    }
})

let fsLoader = FileSystemLoader(paths: ["/Users/ngergo100/Desktop/"])
let environment = Environment(loader: fsLoader)

let context = ["storyboards": storyboardTemplates]
let result = try! environment.renderTemplate(name: "template-accessibilityIdentifiers.stencil", context: context)
print(result)
