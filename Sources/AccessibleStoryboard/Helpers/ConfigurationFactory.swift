import Foundation
import PathKit
import Yams

struct Configuration: Codable {
    let enumName: String?
    let input: String
    let output: String
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
        let path = Path(input)
        let storyboardExtension = "storyboard"
        if path.isDirectory {
            let files = FileManager.default.subpaths(atPath: path.string)
            let storyboardFiles = files?.filter { $0.hasSuffix(storyboardExtension) }
            let paths = storyboardFiles?.map({ (path + $0).string })
            return paths ?? []
        } else if path.isFile, let `extension` = path.extension, `extension` == storyboardExtension {
            return [path.string]
        }
        return []
    }
}
