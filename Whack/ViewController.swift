

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createButton()
    }

    
    func createButton() {
        let button = UIButton()
        button.setTitle("Play", forState: .Normal)
        button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func buttonClick(Sender: UIButton!) {
        performSegueWithIdentifier("game", sender: self)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        
    }


}

