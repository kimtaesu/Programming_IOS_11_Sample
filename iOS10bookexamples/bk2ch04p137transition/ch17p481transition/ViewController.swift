

import UIKit


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet var v : MyView!
    @IBOutlet var outer : UIView!
    @IBOutlet var inner : UIView!
    
    var useAnimator = false
    
    @IBAction func doButton(_ sender: Any?) {
        switch useAnimator {
        case false:
            self.animate()
        case true:
            let anim = UIViewPropertyAnimator(duration: 4, curve: .linear) {
                self.animate()
            }
            anim.startAnimation()
            delay(2) {
                anim.pauseAnimation()
                anim.isReversed = true
                anim.startAnimation() // crash! Okay, that's what I wanted to know, thanks
            }
        }
    }
    
    func animate() {
        let opts : UIViewAnimationOptions = .transitionFlipFromLeft
        UIView.transition(with:self.iv, duration: 0.8, options: opts,
            animations: {
                self.iv.image = UIImage(named:"Smiley")
            })
        
        // ======
        
        self.v.reverse = !self.v.reverse
        UIView.transition(with:self.v, duration: 1, options: opts,
            animations: {
                self.v.setNeedsDisplay()
            })
        
        // ======
                
        let opts2 : UIViewAnimationOptions = [.transitionFlipFromLeft, .allowAnimatedContent]
        UIView.transition(with:self.outer, duration: 1, options: opts2,
            animations: {
                var f = self.inner.frame
                f.size.width = self.outer.frame.width
                f.origin.x = 0
                self.inner.frame = f
            })
        
    }
    
}
