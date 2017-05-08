import UIKit

class UIImageCell: UICollectionViewCell {
    
    let imageFront = UIImageView(image: UIImage(named: "cellImage"))
    let imageBack = UIImageView(image: UIImage(named: "pineapple"))
    var isFliped = false
    var isMiss = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //imageFront.layer.borderWidth = 2
        //imageBack.layer.borderWidth = 2
        addSubview(imageFront)
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipImageFront(gameView: GameView) {
        UIImageView.transitionFromView(self.imageFront, toView: self.imageBack, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            
            self.isMiss = true;
            
            let rect = UIBezierPath()
            
            let x = self.imageBack.frame.origin.x
            let y = self.imageBack.frame.origin.y
            let width = self.imageBack.frame.width
            let height = self.imageBack.frame.height
            rect.moveToPoint(CGPoint(x: x, y: y))
            rect.addLineToPoint(CGPoint(x: x + width, y: y))
            rect.addLineToPoint(CGPoint(x: x + width, y: y + height))
            rect.addLineToPoint(CGPoint(x: x, y: y + height))
            rect.closePath()
            
            let progressLine = CAShapeLayer()
            progressLine.path = rect.CGPath
            progressLine.strokeColor = UIColor.redColor().CGColor
            progressLine.fillColor = UIColor.clearColor().CGColor
            progressLine.lineWidth = 5.0
            progressLine.lineCap = kCALineCapRound
            
            self.imageBack.layer.addSublayer(progressLine)
            
            CATransaction.begin()
            // create a basic animation that animates the value 'strokeEnd'
            // from 0.0 to 1.0 over 3.0 seconds
            let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            animateStrokeEnd.duration = 3.0
            animateStrokeEnd.fromValue = 0.0
            animateStrokeEnd.toValue = 1.0
            
            CATransaction.setCompletionBlock {
                if self.isMiss {
                    gameView.missFlip()
                }
                self.flipImageBack()
            }
            // add the animation
            progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
            CATransaction.commit()
            
        })
        self.isFliped = true
    }
    
    func flipImageBack() {
        self.isMiss = false
        UIImageView.transitionFromView(self.imageBack, toView: self.imageFront, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            self.imageBack.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        })
        self.isFliped = false
    }

}
