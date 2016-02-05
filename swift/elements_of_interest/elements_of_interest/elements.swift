import Foundation
import XCTest

class Elements {
    static func getResource(name: String, ofType: String) -> String {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: ofType)!
        return path
    }

    static func getSnapshot() -> XCElementSnapshot {
        // Must dynamically locate the bundle because main bundle isn't available in testing target
        let path = getResource("elements", ofType: "plist")

        let object = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSArray
        let snapshot = object.firstObject as! XCElementSnapshot
        return snapshot
    }

    static func getSnapshotFromFile(path: String) -> XCElementSnapshot? {
        // Could not cast value of type 'XCElementSnapshot' (0x101625238) to 'NSArray' (0x7fff7c5ee5f0).
        let object = NSKeyedUnarchiver.unarchiveObjectWithFile(path)

        // /Test/Attachments/Snapshot_ is always XCElementSnapshot
        // /Test/Attachments/ElementsOfInterest_ is always NSArray
        if object!.dynamicType == XCElementSnapshot.self {
            return object as? XCElementSnapshot
        } else {
            let firstObject = (object as! NSArray).firstObject
            if firstObject == nil { // sometimes the snapshot is nil :(
                return nil
            }
            return firstObject as? XCElementSnapshot
        }
    }

    static func getDesc() -> String {
        let path = getResource("desc", ofType: "txt")
        let url = NSURL(fileURLWithPath: path)
        return try! String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
    }
}
