

import UIKit

// all greatly changed in iOS 8 and much for the better in my humble opinion

class ViewController: UIViewController {
    
    var alertString = ""
    
    @IBAction func doAlertView(_ sender: Any) {
        let alert = UIAlertController(title: "Not So Fast!",
            message: "Do you really want to do this " +
            "tremendously destructive thing?",
            preferredStyle: .alert)
        // no delegate needed merely to catch which button was tapped;
        // a UIAlertAction has a handler
        // here's a general handler (though none is needed if you want to ignore)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title)")
        }
        // illustrating the three button styles
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Maybe", style: .default, handler: handler))
        // the last default one is bold in any case
        // but new in iOS 9, seems to boldify the designated button title instead
        alert.preferredAction = alert.actions[2]

        self.present(alert, animated: true)
        // dismissal is automatic when a button is tapped
    }
    
    // =====
    
    @IBAction func doAlertView2(_ sender: Any) {
        let alert = UIAlertController(title: "Enter a number:", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.keyboardType = .numberPad // ??? not on iPad
            tf.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        func handler(_ act:UIAlertAction) {
            // it's a closure so we have a reference to the alert
            let tf = alert.textFields![0] 
            print("User entered \(tf.text), tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        alert.actions[1].isEnabled = false
        self.present(alert, animated: true)
    }
    
    func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        // enable OK button only if there is text
        // hold my beer and watch this: how to get a reference to the alert
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[1].isEnabled = (tf.text != "")
    }
    
    // =====
    
    func doActionSheet(_ sender: Any) {
        let action = UIAlertController(title: "Choose New Layout", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in print("Cancel")}))
        func handler(_ act:UIAlertAction) {
            print(act.title as Any)
        }
        for s in ["3 by 3", "4 by 3", "4 by 4", "5 by 4", "5 by 5"] {
            action.addAction(UIAlertAction(title: s, style: .default, handler: handler))
        }
        // action.view.tintColor = .yellow
        self.present(action, animated: true)
        if let pop = action.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }
}
