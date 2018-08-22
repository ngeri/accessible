import Foundation
import PathKit
import Yams

struct Configuration: Codable {
    let inputs: [String]
    let output: String
    let enumName: String?
    let tapManOutput: String?
}

struct ConfigurationFactory {

    static private let configFileName = ".accessible.yml"

    static func readConfiguration() -> Configuration? {
        do {
            let configurationString = try (Path.current + configFileName).read(.utf8)
            let decoder = YAMLDecoder()
            let configuration = try decoder.decode(Configuration.self, from: configurationString)
            return configuration
        } catch {
            return nil
        }
    }
}

extension Configuration {
    var storyboardFileNames: [String] {
        let paths = inputs.map({ Path($0) })
        let storyboardExtension = "storyboard"
        let filePaths = paths.reduce(into: [String]()) { (result, path) in
            if path.isDirectory {
                let files = FileManager.default.subpaths(atPath: path.string)
                let storyboardFiles = files?.filter({ $0.hasSuffix(storyboardExtension) }).map({ (path + $0).string })
                result.append(contentsOf: storyboardFiles ?? [])
            } else if path.isFile, let `extension` = path.extension, `extension` == storyboardExtension {
                result.append(path.string)
            }
        }

        return filePaths
    }
}
