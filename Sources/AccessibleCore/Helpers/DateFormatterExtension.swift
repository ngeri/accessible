import Foundation

extension DateFormatter {
    static let accessible: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
        return dateFormatter
    }()
}
