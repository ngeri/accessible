import Foundation
import PathKit
import Yams

enum IBFileType: String {
    case storyboard
    case xib
}

struct OutputConfiguration: Decodable {
    let identifiersPath: String
    let tapMansPath: String?
}

struct Configuration: Decodable {
    let inputs: [String]
    let outputs: OutputConfiguration
    let enumName: String?
}

struct ConfigurationFactory {

    static private let configFileName = ".accessible.yml"

    static func readConfiguration() -> Configuration? {
        guard let configurationString = try? (Path.current + configFileName).read(.utf8),
            let configuration = decodeConfiguration(configurationString) else {
                return nil
        }
        return configuration
    }

    static func decodeConfiguration(_ configurationString: String) -> Configuration? {
        let decoder = YAMLDecoder()
        let configuration = try? decoder.decode(Configuration.self, from: configurationString)
        return configuration
    }
}

extension Configuration {
    func getStoryboardFilePaths() -> [String] {
        let paths = inputs.map { Path($0) }
        let filePaths = paths.reduce(into: [String]()) { (result, path) in
            if path.isDirectory {
                let files = FileManager.default.subpaths(atPath: path.string)
                let storyboardFiles = files?.filter { $0.hasSuffix(IBFileType.storyboard.rawValue) }.map { (path + $0).string }
                result.append(contentsOf: storyboardFiles ?? [])
            } else if path.isFile, let `extension` = path.extension, `extension` == IBFileType.storyboard.rawValue {
                result.append(path.string)
            }
        }

        return filePaths
    }
}
