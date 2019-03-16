import IBDecodable

extension ViewProtocol {
    var allSubviews: [ViewProtocol & IBIdentifiable] {
        guard let subviews = subviews else { return [] }
        return subviews.flatMap { $0.view.allSubviews } + subviews.compactMap { $0.view as? (ViewProtocol & IBIdentifiable) }
    }
}
