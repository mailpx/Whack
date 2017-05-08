import UIKit

class WinView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        setTitle()
        setButton()
        
    }
    
    func setTitle(){
        let title:UILabel = UILabel(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height/10, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height/10))
        title.font = UIFont.init(name: "Helvetica", size: UIScreen.mainScreen().bounds.height/10)
        title.text = "you won"
        title.textAlignment = NSTextAlignment.Center
        
        view.addSubview(title)
    }
    
    func setButton(){
        let button = UIButton()
        button.setTitle("return to menu", forState: .Normal)
        button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: "returnToMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blackColor().CGColor
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size:screenWidth/20)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonHeight = button.heightAnchor.constraintEqualToConstant(screenHeight/10)
        let buttonWidth = button.widthAnchor.constraintEqualToConstant(CGFloat(screenWidth/2))
        let buttonx = button.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let buttony = button.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        
        NSLayoutConstraint.activateConstraints([buttonHeight, buttonWidth, buttonx, buttony])
    }
    
    func returnToMenu(Sender: UIButton!) {
        self.performSegueWithIdentifier("menu1", sender: self)
    }
    
}

