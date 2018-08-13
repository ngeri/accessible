import Foundation
import SWXMLHash

let fileManager = FileManager.default
let currentDirectoryPath = fileManager.currentDirectoryPath

private let storyboardExtension = ".storyboard"

let files = fileManager.subpaths(atPath: currentDirectoryPath)
let storyboardFiles = files?.filter { $0.hasSuffix(storyboardExtension) }
print(storyboardFiles!)
