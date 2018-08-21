import PathKit

func write(content: String, to: String) {
    let path = Path.current + to
    log.message(.info, "Writing to \(path)")
    do {
        if try path.exists && path.read(.utf8) == content {
            log.message(.info, "Not writing the file as content is unchanged") // TODO: Needs to handle first line which contains current date
            return
        }
        try path.write(content)
        log.message(.info, "File written: \(path)")
    } catch let error {
        log.message(.error, error.localizedDescription)
    }
}
