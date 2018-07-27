
import UIKit
import UserNotifications
import UserNotificationsUI

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



// Info.plist must contain these keys:

// UNNotificationExtensionCategory
// UNNotificationExtensionInitialContentSizeRatio

// optional: UNNotificationExtensionDefaultContentHidden

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(320, 80)
    }
    
    func didReceive(_ notification: UNNotification) {
        let req = notification.request
        let content = req.content
        let atts = content.attachments
        if let att = atts.first, att.identifier == "cup" {
            if att.url.startAccessingSecurityScopedResource() { // system has copy!
                if let data = try? Data(contentsOf: att.url) {
                    self.imageView.image = UIImage(data: data)
                }
                att.url.stopAccessingSecurityScopedResource()
            }
        }
        self.view.setNeedsLayout() // seems to help things along
    }
}
