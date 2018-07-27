

import UIKit

class Dog {}
class NoisyDog : Dog {}

extension Dictionary {
    mutating func addEntries(from d:[Key:Value]) {
        for (k,v) in d {
            self[k] = v
        }
    }
}


class ViewController: UIViewController {
    
    var progress = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
        
            let d = [String:String]()
            var d2 = ["CA": "California", "NY": "New York"]
            let d3 : [String:String] = [:]
            
            let state = d2["CA"]
            d2["CA"] = "Casablanca"
            d2["MD"] = "Maryland"
            d2["NY"] = nil
            
            _ = d
            _ = d3
            _ = state
            
        }

        do {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let d = ["fido": dog1, "rover": dog2]
            let d2 = d as! [String : NoisyDog]
            
            _ = d2
        }
        
        
        do {
            let d = ["CA": "California", "NY": "New York"]
            for s in d.keys {
                print(s)
            }
            
            let keys = Array(d.keys)
            
            for (abbrev, state) in d {
                print("\(abbrev) stands for \(state)")
            }
            
            for pair in d {
                print("\(pair.key) stands for \(pair.value)")
            }

            let arr = Array(d) // [("NY", "New York"), ("CA", "California")]
            print(arr)
            
            _ = d
            _ = keys
            _ = arr
            
            // let d2 = Dictionary<String,String>(arr) // nope

        }
        
        do {
            let d : [String:Int] = ["one":1, "two":2]
            let sum = d.values.reduce(0, +) // ***
            print(sum)
            
            let min = d.values.min()
            print(min) // Optional(1)
            
            let arr = Array(d.values.filter{$0 < 2})
            print(arr)
            
            let keysSorted = d.keys.sorted()
            print(keysSorted)
        }
        

        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "ChalkboardSE-Bold", size: 20)!,
            NSForegroundColorAttributeName : UIColor.darkText,
            NSShadowAttributeName : {
                let shad = NSShadow()
                shad.shadowOffset = CGSize(width:1.5,height:1.5)
                return shad
            }()
        ]
        
        let nc = NotificationCenter.default
        // Cool and long-awaited new feature of Swift 2.2: no more string selectors
        // This means the compiler will form the actual selector for you
        // You don't even have to get it totally right! Here, I've used the bare name...
        // ...but Swift will still form the selector correctly for me
        // In other words, any valid reference to the method will do
        let test = Notification.Name("test")
        nc.addObserver(self, selector:#selector(notificationArrived), name: test, object: nil)
        nc.post(name:test, object: self, userInfo: ["junk":"nonsense"])
        nc.post(name:test, object: self, userInfo: ["progress":"nonsense"])
        nc.post(name:test, object: self, userInfo: ["progress":3])
        
        do {
            var d1 = ["NY":"New York", "CA":"California"]
            let d2 = ["MD":"Maryland"]
            // d1 += d2 // nope
            // d1.appendContentsOf(d2) // nope
            let mutd1 = NSMutableDictionary(dictionary:d1)
            mutd1.addEntries(from:d2)
            d1 = mutd1 as NSDictionary as! [String:String]
            // d1 is now ["MD": "Maryland", "NY": "New York", "CA": "California"]
            print(d1)
        }
        
        do {
            var d1 = ["NY":"New York", "CA":"California"]
            let d2 = ["MD":"Maryland"]
            d1.addEntries(from:d2)
            print(d1)
        }

    }
    
    func notificationArrived(_ n:Notification) {
        let prog = (n.userInfo?["progress"] as? NSNumber)?.doubleValue
        if prog != nil {
            self.progress = prog!
            print("at last! \(self.progress)")
        } else {
            print("invalid notification")
        }
    }

    func anotherWay(n:Notification) {
        if let prog = n.userInfo?["progress"] as? Double { // chapter 10
            self.progress = prog
        }
    }


}

