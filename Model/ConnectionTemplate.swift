struct ConnectionTemplate: CustomStringConvertible {
    let name: String
    let type: String = "View"

    var description: String {
        return name
    }
}
