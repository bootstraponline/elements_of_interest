import Foundation

/*

required attribute keys:

class
text
content-desc
index
bounds

class:sometext {contentdesc}[0,0][1080,1776]
<node class="class" text="sometext" content-desc="contentdesc" index="0" bounds="[0,0][1080,1776]">

*/
class Xml {
    var result: AEXMLDocument = AEXMLDocument()
    var scaleFactor: Int = 2; // required for retina screenshot support

    func getDescription(snapshot: XCElementSnapshot, node: AEXMLElement) {

        let compactDesc = snapshot.compactDescription.characters
        let type = String(compactDesc.split { $0 == " " }.last!)

        let value = snapshot.value as! String

        let identifier = snapshot.identifier
        let frame       = snapshot.frame
        let origin      = frame.origin
        let originX: Int = Int(origin.x) * scaleFactor
        let originY: Int = Int(origin.y) * scaleFactor
        let width: Int   = Int(frame.width) * scaleFactor
        let height: Int  = Int(frame.height) * scaleFactor

        /*
        uiautomatorviewer bounds calculation logic
        https://github.com/bootstraponline/platform_tools_swt/blob/8996e71047a2bd11efee46ef14e02435ab5fa07a/uiautomatorviewer/src/main/java/com/android/uiautomator/tree/UiNode.java#L87

        [x,y,width,height]
        width = width - x
        height = height - y
        */

        let bounds = "[\(originX),\(originY)][\(width+originX),\(height+originY)]"

        // ios specific attributes

        let label = snapshot.label
        let placeholderValue = snapshot.placeholderValue
        let hasKeyboardFocus = snapshot.hasKeyboardFocus
        let isMainWindow = snapshot.isMainWindow
        let enabled = snapshot.enabled
        // <node class="class" text="sometext" content-desc="contentdesc" index="0" bounds="[0,0][1080,1776]">

        let parent = node.addChild(name: "node", attributes: ["class": type, "text":value,
            "content-desc":identifier, "index":"0", "bounds":bounds, "type":type, "value":value,
            "identifier":identifier, "label":label, "placeholderValue":placeholderValue,
            "hasKeyboardFocus":"\(hasKeyboardFocus)", "isMainWindow":"\(isMainWindow)",
            "originX": "\(originX)", "originY": "\(originY)", "width":"\(width)", "height":"\(height)", "enabled":"\(enabled)"])

        for child in snapshot.children {
            getDescription(child as! XCElementSnapshot, node: parent)
        }
    }

    func recursiveDescription(snapshot: XCElementSnapshot?) -> String {
        if snapshot == nil {
          return ""
        }

        result = AEXMLDocument()
        let root = result.addChild(name: "hierarchy", attributes: ["rotation":"0"])

        getDescription(snapshot!, node: root)

        return result.xmlString
    }
}
