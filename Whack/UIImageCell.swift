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
        
        let imageHeight = UIScreen.main.bounds.height / 6.5
        let imageWidth = UIScreen.main.bounds.width / 4
        
        imageFront.frame = CGRect(x: imageFront.frame.origin.x, y: imageFront.frame.origin.y, width: imageWidth, height: imageHeight)
        imageBack.frame = CGRect(x: imageBack.frame.origin.x, y: imageBack.frame.origin.y, width: imageWidth, height: imageHeight)
        addSubview(imageFront)
        
        gameview = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipImageFront() {
        UIImageView.transition(from: self.imageFront, to: self.imageBack, duration: 1.0, options: .transitionFlipFromRight, completion: { finished in
            
            self.setPathAnimation(UIColor.red, flipImage: self.flipImageBack)
            
        })
        self.isFliped = true
    }
    
    func flipImageBack() {
        if isMiss {
            gameview?.missFlip()
        }
        self.isMiss = false
        UIImageView.transition(from: self.imageBack, to: self.imageFront, duration: 1.0, options: .transitionFlipFromRight, completion: { finished in
            self.imageBack.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        })
        self.isFliped = false
    }
    
    func flipImageFrontTimeOut() {
        imageBack.image = UIImage(named: "pineapples")
        UIImageView.transition(from: self.imageFront, to: self.imageBack, duration: 1.0, options: .transitionFlipFromRight, completion: { finished in
            
            self.setPathAnimation(UIColor.green, flipImage: self.flipImageBackTimeOut)
            
        })
        isFliped = true
        isTimeOut = true
    }
    
    func flipImageBackTimeOut() {
        UIImageView.transition(from: self.imageBack, to: self.imageFront, duration: 1.0, options: .transitionFlipFromRight, completion: { finished in
            self.imageBack.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        })
        isFliped = false
        isTimeOut = false
        imageBack.image = UIImage(named: "pineapple")
    }
    
    func setPathAnimation(_ color : UIColor, flipImage:@escaping () -> Void) {
        self.isMiss = true;
        
        let rect = UIBezierPath()
        
        let x = self.imageBack.frame.origin.x
        let y = self.imageBack.frame.origin.y
        let width = self.imageBack.frame.width
        let height = self.imageBack.frame.height
        rect.move(to: CGPoint(x: x, y: y))
        rect.addLine(to: CGPoint(x: x + width, y: y))
        rect.addLine(to: CGPoint(x: x + width, y: y + height))
        rect.addLine(to: CGPoint(x: x, y: y + height))
        rect.close()
        
        let progressLine = CAShapeLayer()
        progressLine.path = rect.cgPath
        progressLine.strokeColor = color.cgColor
        progressLine.fillColor = UIColor.clear.cgColor
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
        progressLine.add(animateStrokeEnd, forKey: "animate stroke end animation")
        CATransaction.commit()
        
    }
    
    func pauseAnimation(){
        let pausedTime = imageBack.layer.convertTime(CACurrentMediaTime(), from: nil)
        imageBack.layer.speed = 0.0
        imageBack.layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = imageBack.layer.timeOffset
        imageBack.layer.speed = 1.0
        imageBack.layer.timeOffset = 0.0
        imageBack.layer.beginTime = 0.0
        let timeSincePause = imageBack.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        imageBack.layer.beginTime = timeSincePause
    }

}
