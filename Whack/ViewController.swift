

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        createGameButton()
        createHighScoresButton()
    }

    
    func setButton(button: UIButton, buttonName: String) {
        button.setTitle(buttonName, forState: .Normal)
        button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func createHighScoresButton() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let button = UIButton(frame: CGRect(x: screenWidth/4, y: screenHeight*0.6, width: screenWidth/2, height: screenHeight/10))
        setButton(button, buttonName: "High Scores")
        button.addTarget(self, action: "buttonHighScoresClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size:screenWidth/20)
        view.addSubview(button)
    }
    
    func createGameButton() {
        let button = UIButton()
        setButton(button, buttonName: "Play")
        button.addTarget(self, action: "buttonGameClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size:screenWidth/20)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraintEqualToConstant(CGFloat(screenHeight/10)).active = true
        button.widthAnchor.constraintEqualToConstant(CGFloat(screenWidth/2)).active = true
        NSLayoutConstraint(item: button, attribute: .TopMargin, relatedBy: .Equal,
            toItem: view, attribute:  .BottomMargin, multiplier: 0.3, constant: 0).active = true
        NSLayoutConstraint(item: button, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: screenWidth/4).active = true
        /*let buttonx = button.centerXAnchor.constraintEqualToAnchor(NSLayoutXAxisAnchor(
        let buttony = button.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)

        NSLayoutConstraint.activateConstraints([buttonHeight, buttonWidth, buttonx, buttony])*/

        
    }
    
    func buttonGameClick(Sender: UIButton!) {
        performSegueWithIdentifier("game", sender: self)
    }
    
    func buttonHighScoresClick(Sender: UIButton!) {
        performSegueWithIdentifier("highscores", sender: self)
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

