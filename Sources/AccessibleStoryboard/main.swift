import Foundation
import IBDecodable

let fileManager = FileManager.default
let currentDirectoryPath = fileManager.currentDirectoryPath

private let storyboardExtension = ".storyboard"

let files = fileManager.subpaths(atPath: currentDirectoryPath)
let storyboardFiles = files?.filter { $0.hasSuffix(storyboardExtension) }


if let storyboardFile = storyboardFiles?.first {
    do  {
        let file = try StoryboardFile(path: storyboardFile)
        let connections: [AnyConnection]? = file.document.scenes?.reduce(into: [AnyConnection](), { (result, scene) in
            if let connections = scene.viewController?.viewController.connections {
                result.append(contentsOf: connections)
            }
        })
    } catch let error {
        print(error)
    }
}

