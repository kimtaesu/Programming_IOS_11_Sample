
import UIKit

class MyTiledView : UIView {
    
    var currentImage : UIImage!
    var currentSize : CGSize = .zero
    
    let drawQueue = DispatchQueue(label: "drawQueue")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let lay = self.layer as! CATiledLayer
        let scale = lay.contentsScale
        lay.tileSize = CGSize(208*scale,238*scale)
        lay.levelsOfDetail = 3
        lay.levelsOfDetailBias = 2
    }
    
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }
    
    override func draw(_ rect: CGRect) {
//        NSLog("rect %@", NSStringFromCGRect(rect));
//        NSLog("bounds %@", NSStringFromCGRect(self.bounds));
//        NSLog("contents scale %f", self.layer.contentsScale);
//        NSLog("%@", NSStringFromCGAffineTransform(UIGraphicsGetCurrentContext()!.ctm));
//        NSLog("%@", NSStringFromCGRect(UIGraphicsGetCurrentContext()!.boundingBoxOfClipPath));
        
        drawQueue.sync { // work around nasty thread issue...
            // we are called twice simultaneously on two different background threads!

            let oldSize = self.currentSize
            // NSLog("oldSize %@", NSStringFromCGSize(oldSize))
            // NSLog("rect.size %@", NSStringFromCGSize(rect.size))
            if !oldSize.equalTo(rect.size) {
                // NSLog("%@", "not equal, making new size")
                // make a new size
                self.currentSize = rect.size
                // make a new image
                let lay = self.layer as! CATiledLayer
                
                let tr = UIGraphicsGetCurrentContext()!.ctm
                let sc = tr.a/lay.contentsScale
                let scale = sc/4.0
                
                let path = Bundle.main.path(
                    forResource: "earthFromSaturn", ofType:"png")!
                let im = UIImage(contentsOfFile:path)!
                let sz = CGSize(im.size.width * scale, im.size.height * scale)
                
                
                let f = UIGraphicsImageRendererFormat.default()
                f.opaque = true; f.scale = 1 // *
                let r = UIGraphicsImageRenderer(size: sz, format: f)
                self.currentImage = r.image { _ in
                    im.draw(in:CGRect(origin:.zero, size:sz))
                }

                
//                UIGraphicsBeginImageContextWithOptions(sz, true, 1)
//                im.draw(in:CGRect(0,0,sz.width,sz.height))
//                self.currentImage = UIGraphicsGetImageFromCurrentImageContext()!
//                UIGraphicsEndImageContext()
                
                NSLog("created image at size %@", NSStringFromCGSize(sz)) // only three times
            }
            self.currentImage?.draw(in:self.bounds)
            
            // comment out the following! it's here just so we can see the tile boundaries
            
            let bp = UIBezierPath(rect: rect)
            UIColor.white.setStroke()
            bp.stroke()
            
        }
    }
}


