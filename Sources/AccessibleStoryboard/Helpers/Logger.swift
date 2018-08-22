import Foundation

let log = Logger()

enum LogLevel {
    case info, warning, error
}

enum ANSIColor: UInt8, CustomStringConvertible {
    case reset = 0

    case black = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`

    var description: String {
        return "\u{001B}[\(self.rawValue)m"
    }

    func format(_ string: String) -> String {
        if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
            isatty(fileno(stdout)) != 0 {
            return "\(self)\(string)\(ANSIColor.reset)"
        } else {
            return string
        }
    }
}

struct Logger {

    func message(_ level: LogLevel, _ string: CustomStringConvertible) {
        switch level {
        case .info:
            fputs(ANSIColor.blue.format("ℹ️  \(string)\n"), stdout)
        case .warning:
            fputs(ANSIColor.yellow.format("⚠️  \(string)\n"), stderr)
        case .error:
            fputs(ANSIColor.red.format("❌ \(string)\n"), stderr)
        }
    }

}
