import Foundation
import IBDecodable
import Stencil

let fileManager = FileManager.default
let currentDirectoryPath = fileManager.currentDirectoryPath

private let storyboardExtension = ".storyboard"

let files = fileManager.subpaths(atPath: currentDirectoryPath)
let storyboardFiles = files?.filter { $0.hasSuffix(storyboardExtension) }


if let storyboardFile = storyboardFiles?.first {
    do  {
        let file = try StoryboardFile(path: storyboardFile)
        let outlets: [Outlet]? = file.document.scenes?.reduce(into: [Outlet](), { (result, scene) in
            guard let connections = scene.viewController?.viewController.connections else  { return }
            let outlets = connections.compactMap { $0.connection as? Outlet}
            result.append(contentsOf: outlets)
        })

        guard let unwrappedOutlets = outlets else { exit(0) }

        let env = Environment()
        let context = ["connections": unwrappedOutlets.map({ $0.property })]
        let result = try env.renderTemplate(string: """
{% for connection in connections %}static let {{connection}} = Home.{{connection}}
{% endfor %}
""", context: context)
        print(result)
    } catch let error {
        print(error)
    }
}
