struct ConnectionTemplate: CustomStringConvertible {
    let name: String
    let type: String

    var description: String {
        return name
    }
}
