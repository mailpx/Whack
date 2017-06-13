import UIKit

class UIImageCell: UICollectionViewCell {
    
    let imageFront = UIImageView(image: UIImage(named: "cellImage"))
    let imageBack = UIImageView(image: UIImage(named: "pineapple"))
    var isFliped = false
    var isMiss = false
    var isTimeOut = false
    var gameview : GameView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageHeight = UIScreen.mainScreen().bounds.height / 6.5
        let imageWidth = UIScreen.mainScreen().bounds.width / 4
        
        imageFront.frame = CGRectMake(imageFront.frame.origin.x, imageFront.frame.origin.y, imageWidth, imageHeight)
        imageBack.frame = CGRectMake(imageBack.frame.origin.x, imageBack.frame.origin.y, imageWidth, imageHeight)
        addSubview(imageFront)
        
        gameview = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipImageFront() {
        UIImageView.transitionFromView(self.imageFront, toView: self.imageBack, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            
            self.setPathAnimation(UIColor.redColor(), flipImage: self.flipImageBack)
            
        })
        self.isFliped = true
    }
    
    func flipImageBack() {
        if isMiss {
            gameview?.missFlip()
        }
        self.isMiss = false
        UIImageView.transitionFromView(self.imageBack, toView: self.imageFront, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            self.imageBack.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        })
        self.isFliped = false
    }
    
    func flipImageFrontTimeOut() {
        imageBack.image = UIImage(named: "pineapples")
        UIImageView.transitionFromView(self.imageFront, toView: self.imageBack, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            
            self.setPathAnimation(UIColor.greenColor(), flipImage: self.flipImageBackTimeOut)
            
        })
        isFliped = true
        isTimeOut = true
    }
    
    func flipImageBackTimeOut() {
        UIImageView.transitionFromView(self.imageBack, toView: self.imageFront, duration: 1.0, options: .TransitionFlipFromRight, completion: { finished in
            self.imageBack.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        })
        isFliped = false
        isTimeOut = false
        imageBack.image = UIImage(named: "pineapple")
    }
    
    func setPathAnimation(color : UIColor, flipImage:() -> Void) {
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
        progressLine.strokeColor = color.CGColor
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
            flipImage();
        }
        // add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        CATransaction.commit()
        
    }
    
    func pauseAnimation(){
        let pausedTime = imageBack.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        imageBack.layer.speed = 0.0
        imageBack.layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = imageBack.layer.timeOffset
        imageBack.layer.speed = 1.0
        imageBack.layer.timeOffset = 0.0
        imageBack.layer.beginTime = 0.0
        let timeSincePause = imageBack.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        imageBack.layer.beginTime = timeSincePause
    }

}
