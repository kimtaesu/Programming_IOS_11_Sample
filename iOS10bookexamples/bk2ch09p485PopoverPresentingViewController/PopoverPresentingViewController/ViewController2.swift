

import UIKit

class ViewController2: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // showing how behavior of modalInPopover for presented-inside-popover has changed from iOS 7

    let workaround = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = self.popoverPresentationController {
            if workaround {
                print("del")
                pop.delegate = self
            }
        }
    }
    
    // and here's how to work around it
    // (you could argue that this is a better way in any case, I suppose)
    // works on iOS 9 and 8, restoring the iOS 7 behavior
    
    func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
        let ok = pop.presentedViewController.presentedViewController == nil
        print(ok)
        return ok
    }

}
