import IBDecodable

extension ViewProtocol {
    func getAllSubviews() -> [ViewProtocol] {
        guard let unwrappedSubviews = subviews else { return [] }
        var views = unwrappedSubviews.flatMap({ $0.view.getAllSubviews() })
        views.append(contentsOf: unwrappedSubviews.map({ $0.view }))
        return views
    }
}
