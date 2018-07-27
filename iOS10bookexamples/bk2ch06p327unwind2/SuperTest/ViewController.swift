

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    override var description : String {
        get {
            if self.lab != nil {
                return "View Controller \(self.lab.text!)"
            }
            else {
                return super.description
            }
        }
    }
    
    @IBAction func doUnwind(_ sender:UIStoryboardSegue) {
        
    }
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        var result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        
        // uncomment this to do a grand unwind to root
        // result = self.description == "View Controller 1"

        print("\(self) \(#function) \(action) \(result)")
        
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(self) \(#function)")
        }
    }

    
}
