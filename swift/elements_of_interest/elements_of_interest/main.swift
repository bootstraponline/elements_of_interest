// First argument is the app path.
var arguments = Process.arguments.dropFirst()
var snapshotFilePath = arguments.popFirst()
var outputFilePath = arguments.popFirst()

if snapshotFilePath != nil && outputFilePath != nil {
    let manager = NSFileManager.defaultManager()

    if !manager.fileExistsAtPath(snapshotFilePath!) {
        print("Snapshot doesn't exist: \(snapshotFilePath)")
        exit(1)
    }

    let result = Xml().recursiveDescription(Elements.getSnapshotFromFile(snapshotFilePath!))
    try! result.writeToFile(outputFilePath!, atomically: false, encoding: NSUTF8StringEncoding)
} else {
    print("Usage: elements_of_interest path/to/input path/to/output.uix")
}
