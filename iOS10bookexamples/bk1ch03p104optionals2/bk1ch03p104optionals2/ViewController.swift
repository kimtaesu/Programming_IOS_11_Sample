

import UIKit

class Dog {
    var noise : String?
    func speak() -> String? {
        return self.noise
    }
}

func doThis(_ f:()->String?) {
    let s = f()
    print(s)
}

func optionalStringMaker() -> String! {
    return Optional("Howdy")
}

func doThis2(_ f:()->String!) {
    let s = f()
    print(s)
}

func optionalStringMaker2() -> String? {
    return Optional("Howdy")
}


var ios : String! = "howdy"
var opt : String? = "howdy"

class ViewController: UIViewController {
    
    @IBOutlet var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // type substitution works only one way
        doThis(optionalStringMaker)
        // doThis2(optionalStringMaker2) // no
        
        // value substitution, works both ways
        ios = opt
        opt = ios
    
        let stringMaybe : String? = "howdy"
        let upper = stringMaybe!.uppercased() // legal but dangerous
        // let upper2 = stringMaybe.uppercaseString // compile error
        let upper3 = stringMaybe?.uppercased()
        print(upper3)
        
        let stringMaybe2 : String? = nil
        let upper4 = stringMaybe2?.uppercased() // no crash!
        print(upper4)
        
        // longer chain - still just one Optional results
        let f = self.view.window?.rootViewController?.view.frame

        let d = Dog()
        let bigname = d.speak()?.uppercased()

        let s : String? = "Howdy"
        if s == "Howdy" { print("equal") }
        
        // becomes illegal in seed 6
        // equality still works with Optional, but comparison does not
//        let i : Int? = 2
//        if i < 3 { print("less") }
        // you can, however, say this (though of course you can crash if i is nil):
        let i : Int! = 2
        if i < 3 { print("less") } // involves forced unwrapping
        
        do {
            let i : Int? = 2
            if i != nil && i! < 3 {
                print("less")
            }
        }
        
        var crash : Bool {return false}
        if crash {
            let c : UIColor! = nil
            if c != .red { // crash at runtime
                // and if you change it to == you'll crash the compiler!'
                print("it is not red")
            }
        }


        let arr = [1,2,3]
        let ix = (arr as NSArray).index(of:4)
        print(ix)
        if ix == NSNotFound { print("not found") }
        
        let arr2 = [1,2,3]
        let ix2 = arr2.index(of:4)
        if ix2 == nil { print("not found") }


        _ = upper
        _ = f
        _ = bigname
        
        let v = UIView()
        let c = v.backgroundColor
        // let c2 = c.withAlphaComponent(0.5) // compile error
        let c2 = c?.withAlphaComponent(0.5)
        
        _ = c2


    
    }
    
}

// they fixed this API!

class MyLayer : CALayer {
    override func draw(in: CGContext) {
        //
    }
}

