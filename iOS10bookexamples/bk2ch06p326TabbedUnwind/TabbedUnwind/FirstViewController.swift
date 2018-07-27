

import UIKit

/*
Showing how iOS 9 performs a complex unwind involving multiple parent view controllers.
In the first tab, do a push.
Switch to the second tab. Do a present.
Now unwind. We successfully unwind all the way back to the first tab!
So the second tab dismisses, the tab controller switches to the first tab, and the first tab nav controller pops.
How on earth is this possible?! There's no code at all (except for the unwind-to-here marker), but the right thing happens.

Logging reveals the sequence:

// prelude: source gets a chance to veto the whole thing
 ExtraViewController2 shouldPerformSegue(withIdentifier:sender:) true

// === first we establish the path from the source to the destination
// === we also establish _who_ is the destination; note that we only ask "can perform" if you have no eligible children
// (makes perfect sense: having eligible children already means "it's not me")

// I have no children and it isn't me
 SecondViewController allowedChildViewControllersForUnwinding(from:) []
 SecondViewController canPerformUnwindSegueAction(_:from:withSender:) iAmFirst: false

// I have no children and it isn't me
This one looks like a bug to me: why do we go _down_ into a child when we were told there were no eligible children?
 ExtraViewController2 allowedChildViewControllersForUnwinding(from:) []
 ExtraViewController2 canPerformUnwindSegueAction(_:from:withSender:) iAmFirst: false

// I have one! it's the nav controller in the first tab
 MyTabBarController allowedChildViewControllersForUnwinding(from:) [<TabbedUnwind.MyNavController: 0x7f9319023600>]

// I have two!
 MyNavController allowedChildViewControllersForUnwinding(from:) [<TabbedUnwind.ExtraViewController: 0x7f931850b6a0>, <TabbedUnwind.FirstViewController: 0x7f931b00b2e0>]

// I have no children and it isn't me
 ExtraViewController allowedChildViewControllersForUnwinding(from:) []
 ExtraViewController canPerformUnwindSegueAction(_:from:withSender:) iAmFirst: false

I have no children and it _is_ me!
 FirstViewController allowedChildViewControllersForUnwinding(from:) []
 FirstViewController canPerformUnwindSegueAction(_:from:withSender:) iAmFirst: true

// === we have now established the path; now we perform the unwind in stages
// === note that MyTabBarController is told to unwind to the nav controller; the nav controller is told to unwind to the root vc

 ExtraViewController2 prepare(for:sender:)
 FirstViewController iAmFirst // the marker method is called

 MyTabBarController dismiss(animated:completion:)

 MyTabBarController unwind(for:towardsViewController:) <TabbedUnwind.MyNavController: 0x7f9319023600>
 MyTabBarController set selectedViewController // responds by switching tabs
 
 MyNavController unwind(for:towardsViewController:) <TabbedUnwind.FirstViewController: 0x7f931b00b2e0>
 MyNavController popToViewController(_:animated:) // responds by popping
 
 farewell from ExtraViewController
 farewell from ExtraViewController2


*/

class FirstViewController: UIViewController {
    
    @IBAction func iAmFirst (_ sender:UIStoryboardSegue!) {
        print("\(type(of:self)) \(#function)")
    }
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }



}

