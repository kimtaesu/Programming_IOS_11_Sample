
import UIKit
import CoreText

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    @IBOutlet var lab2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ff = UIFont(name: "GillSans-BoldItalic", size: 20)!
        let dd = ff.fontDescriptor
        let vis = dd.object(forKey:UIFontDescriptorVisibleNameAttribute)!
        print(vis)
        let traits = dd.symbolicTraits
        let isItalic = traits.contains(.traitItalic)
        let isBold = traits.contains(.traitBold)
        print(isItalic, isBold)
        
        var which : Int { return 1 }
        
        switch which {
        case 0:
            let desc = UIFontDescriptor(name:"Didot", size:18)
            // print(desc.fontAttributes())
            let d = [
                UIFontFeatureTypeIdentifierKey:kLetterCaseType,
                UIFontFeatureSelectorIdentifierKey:kSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes(
                [UIFontDescriptorFeatureSettingsAttribute:[d]]
            )
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        case 1:
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
            // print(desc.fontAttributes())
            let d = [
                UIFontFeatureTypeIdentifierKey:kLowerCaseType,
                UIFontFeatureSelectorIdentifierKey:kLowerCaseSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes(
                [UIFontDescriptorFeatureSettingsAttribute:[d]]
            )
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        default:break
        }
        
        
        // =========
        
        do {
            
            var whichh : Int { return 0 }

            switch whichh {
            case 0:
                var f = UIFont.preferredFont(forTextStyle:.title2)
                
                let desc = f.fontDescriptor
                let d = [
                    UIFontFeatureTypeIdentifierKey:kStylisticAlternativesType,
                    UIFontFeatureSelectorIdentifierKey:kStylisticAltOneOnSelector
                ]
                let desc2 = desc.addingAttributes(
                    [UIFontDescriptorFeatureSettingsAttribute:[d]]
                )
                f = UIFont(descriptor: desc2, size: 0)
                
                self.lab2.font = f
                self.lab2.text = "1234567890 Hill IO" // notice the straight 6 and 9

            case 1:
                var f = UIFont.preferredFont(forTextStyle:.title2)
                
                let desc = f.fontDescriptor
                let d = [
                    UIFontFeatureTypeIdentifierKey:kStylisticAlternativesType,
                    UIFontFeatureSelectorIdentifierKey:kStylisticAltSixOnSelector
                ]
                let desc2 = desc.addingAttributes(
                    [UIFontDescriptorFeatureSettingsAttribute:[d]]
                )
                f = UIFont(descriptor: desc2, size: 0)
                
                self.lab2.text = "1234567890 Hill IO" // adds curvy ell
                self.lab2.font = f


            default:break
            }
            
//            let mas = NSMutableAttributedString(string: "offloading fistfights", attributes: [
//                NSFontAttributeName:UIFont(name: "Didot", size: 20)!,
//                NSLigatureAttributeName:0
//                ])
//            self.lab2.attributedText = mas
            
//            self.lab2.font = UIFont(name: "Papyrus", size: 20)
//            self.lab2.text = "offloading fistfights"
            
            do {
                let desc = UIFontDescriptor(name: "Didot", size: 20) as CTFontDescriptor
                let f = CTFontCreateWithFontDescriptor(desc,0,nil)
                let arr = CTFontCopyFeatures(f)
                print(arr as Any)
                
                
            }
        
        }
    }
    
    
    
}
