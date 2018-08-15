import IBDecodable

extension ViewProtocol {
    func getAllSubview() -> [ViewProtocol] {
        guard let unwrappedSubviews = subviews else { return [] }
        var views = unwrappedSubviews.flatMap({ $0.view.getAllSubview() })
        views.append(contentsOf: unwrappedSubviews.map({ $0.view }))
        return views
    }
}
