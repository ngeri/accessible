import Foundation

extension DateFormatter {
    static let `as`: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
        return dateFormatter
    }()
}
