

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello world"
            let s2 = s.capitalized // "Hello World"
            print(s2)
        }

        do {
            let s = "hello"
            let range = s.range(of:"ell") // Optional(Range(1..<4))
            print(range)
        }
        
        do {
            let s = "hello"
            let range = (s as NSString).range(of:"ell") // (1,3), an NSRange
            print(range) // why have they lost the ability to show me an NSRange?
            print(NSStringFromRange(range))
        }
        
        do {
            let s = "hello"
            // let sss = s.substring(with:NSMakeRange(1,3)) // compile error
            // let ssss = s.substring(with:1...3)
            let ss = (s as NSString).substring(with: NSRange(location: 1,length: 3))
            print(ss)
        }
        
    }


}

