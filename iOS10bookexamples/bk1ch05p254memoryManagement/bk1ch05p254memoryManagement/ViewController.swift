

import UIKit
import WebKit

class HelpViewController: UIViewController {
    weak var wv : UIWebView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let wv = UIWebView(frame:self.view.bounds)
        // ... further configuration of wv here ...
        self.view.addSubview(wv)
        self.wv = wv
    }
    // ...
}

class MyDropBounceAndRollBehavior : UIDynamicBehavior {
    let v : UIView
    init(view v:UIView) {
        self.v = v
        super.init()
    }
    override func willMove(to anim: UIDynamicAnimator?) {
        guard let anim = anim else { return }
        let sup = self.v.superview!
        let grav = UIGravityBehavior()
        grav.action = {
            [unowned self] in
            let items = anim.items(in: sup.bounds) as! [UIView]
            if items.index(of: self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
            }
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)
        // ...
    }
    // ...
}

class SecondViewController : UIViewController {
    weak var delegate : SecondViewControllerDelegate?
    // ...
}
protocol SecondViewControllerDelegate : class {
    func accept(data:Any!)
}




class ViewController: UIViewController {
    
    weak var delegate : WKScriptMessageHandler?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            print(1)
            func testRetainCycle() {
                class Dog {
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                
                _ = d
                _ = c
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        do {
            print(2)
            func testRetainCycle() {
                class Dog {
                    var cat : Cat?
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    var dog : Dog?
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c // create a...
                c.dog = d // ...retain cycle
            }
            testRetainCycle() // nothing in console
        }
        
        do {
            print(3)
            func testRetainCycle() {
                class Dog {
                    weak var cat : Cat?
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    weak var dog : Dog?
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c
                c.dog = d
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        do {
            print(4)
            func testUnowned() {
                class Boy {
                    var dog : Dog?
                    deinit {
                        print("farewell from Boy")
                    }
                }
                class Dog {
                    let boy : Boy
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        print("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
            }
            testUnowned() // nothing in console
        }
        
        do {
            print(5)
            func testUnowned() {
                class Boy {
                    var dog : Dog?
                    deinit {
                        print("farewell from Boy")
                    }
                }
                class Dog {
                    unowned let boy : Boy // *
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        print("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
                return // uncomment me to test crashing
                var b2 = Optional(Boy())
                let d2 = Dog(boy: b2!)
                b2 = nil // destroy the Boy behind the Dog's back
                print(d2.boy) // crash

            }
            testUnowned() // farewell from Boy, farewell from Dog
        }
        
        do {
            print(6)
            class FunctionHolder {
                var function : ((Void) -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let fh = FunctionHolder()
                fh.function = {
                    print(fh)
                }
            }
            testFunctionHolder() // nothing in console
        }
        
        do {
            print(7)
            class FunctionHolder {
                var function : ((Void) -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let fh = FunctionHolder()
                fh.function = {
                    [weak fh] in
                    print(fh)
                }
                fh.function!() // proving that what's printed is Optional
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
        do {
            print(8)
            class FunctionHolder {
                var function : ((Void) -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let fh = FunctionHolder()
                fh.function = {      // here comes the weak–strong dance
                    [weak fh] in     // weak
                    guard let fh = fh else { return }
                    print(fh)        // strong
                }
                fh.function!() // proving that what's printed is non-Optional
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
    }



}

