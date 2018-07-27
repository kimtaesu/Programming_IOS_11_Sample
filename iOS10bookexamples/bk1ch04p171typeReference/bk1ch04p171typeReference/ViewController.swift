
import UIKit

class Dog {
    class var whatDogsSay : String {
        return "Woof"
    }
    func bark() {
        print(type(of:self).whatDogsSay)
    }
}
class NoisyDog : Dog {
    override class var whatDogsSay : String {
        return "Woof woof woof"
    }
}

func dogTypeExpecter(_ whattype:Dog.Type) {
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let d = Dog()
        d.bark()
        let nd = NoisyDog()
        nd.bark() // Woof woof woof
        print(type(of:nd))
    
        dogTypeExpecter(Dog) // oooh, compiler now warns
        dogTypeExpecter(Dog.self)
        dogTypeExpecter(NoisyDog) // ditto
        dogTypeExpecter(NoisyDog.self)
        dogTypeExpecter(type(of:d))
        dogTypeExpecter(type(of:d).self)
        dogTypeExpecter(type(of:nd))
        dogTypeExpecter(type(of:nd).self)
        
        let ddd = Dog.self
        let dddd = type(of:ddd)
        print(ddd == Dog.self)
        print(dddd == type(of:Dog.self)) // oooookay...


    }



}

