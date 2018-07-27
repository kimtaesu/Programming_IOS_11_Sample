// example no longer in the book; I've replaced my use of 
// UIPercentDrivenInteractiveTransition with UIViewPropertyAnimator
// in iOS 10
// so, just translated into Swift 3 for historical purposes

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window : UIWindow?
    var rightEdger : UIScreenEdgePanGestureRecognizer!
    var leftEdger : UIScreenEdgePanGestureRecognizer!
    var inter : UIPercentDrivenInteractiveTransition!
    var interacting = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tbc = self.window!.rootViewController as! UITabBarController
        tbc.delegate = self
        
        // keep ref to g.r.s, because can't learn which one it is by asking for "edges" later
        // (always comes back as None)
        
        let sep = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep.edges = .right
        tbc.view.addGestureRecognizer(sep)
        sep.delegate = self
        self.rightEdger = sep
        
        let sep2 = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep2.edges = .left
        tbc.view.addGestureRecognizer(sep2)
        sep2.delegate = self
        self.leftEdger = sep2
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let result : UIViewControllerInteractiveTransitioning? = self.interacting ? self.inter : nil
        // no interaction if we didn't use g.r.
        return result
    }
}

extension AppDelegate : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        let tbc = self.window!.rootViewController as! UITabBarController
        var result = false
        
        if g == self.rightEdger {
            result = (tbc.selectedIndex < tbc.viewControllers!.count - 1)
        }
        else {
            result = (tbc.selectedIndex > 0)
        }
        return result
    }
    
    func pan(_ g:UIScreenEdgePanGestureRecognizer) {
        let v = g.view!
        let tbc = self.window!.rootViewController as! UITabBarController
        let delta = g.translation(in: v)
        let percent = fabs(delta.x/v.bounds.size.width)
        switch g.state {
        case .began:
            self.inter = UIPercentDrivenInteractiveTransition()
            self.interacting = true
            if g == self.rightEdger {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
        case .changed:
            self.inter.update(percent)
        case .ended:
            // self.inter.completionSpeed = 0.5
            // (try completionSpeed = 2 to see "ghosting" problem after a partial)
            // (can occur with 1 as well)
            // (setting to 0.5 seems to fix it)
            // now using delay in completion handler to solve the issue
            
            if percent > 0.5 {
                self.inter.finish()
            } else {
                self.inter.cancel()
            }
            self.interacting = false
        case .cancelled:
            self.inter.cancel()
            self.interacting = false
        default: break
        }
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let vc1 = transitionContext.viewController(forKey: .from)!
        let vc2 = transitionContext.viewController(forKey: .to)!
        
        let con = transitionContext.containerView
        
        let r1start = transitionContext.initialFrame(for: vc1)
        let r2end = transitionContext.finalFrame(for: vc2)
        
        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = transitionContext.view(forKey: .from)!
        let v2 = transitionContext.view(forKey: .to)!
        
        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = tbc.viewControllers!.index(of: vc1)!
        let ix2 = tbc.viewControllers!.index(of: vc2)!
        let dir : CGFloat = ix1 < ix2 ? 1 : -1
        var r1end = r1start
        r1end.origin.x -= r1end.size.width * dir
        var r2start = r2end
        r2start.origin.x += r2start.size.width * dir
        v2.frame = r2start
        con.addSubview(v2)
        
        // interaction looks much better if animation curve is linear
        let opts : UIViewAnimationOptions = self.interacting ? .curveLinear : []
        
        if !self.interacting {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        UIView.animate(withDuration: 0.4, delay:0, options:opts, animations: {
            v1.frame = r1end
            v2.frame = r2end
            }, completion: {
                _ in
                delay (0.1) { // needed to solve "black ghost" problem after partial gesture
                    let cancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!cancelled)
                    if UIApplication.shared.isIgnoringInteractionEvents {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            })
    }
}
