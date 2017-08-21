

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)

        createGameButton()
        createHighScoresButton()
    }

    
    func setButton(_ button: UIButton, buttonName: String) {
        button.setTitle(buttonName, for: UIControlState())
        button.setTitleColor(UIColor.yellow, for: UIControlState())
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func createHighScoresButton() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let button = UIButton(frame: CGRect(x: screenWidth/4, y: screenHeight*0.6, width: screenWidth/2, height: screenHeight/10))
        setButton(button, buttonName: "High Scores")
        button.addTarget(self, action: #selector(ViewController.buttonHighScoresClick(_:)), for: UIControlEvents.touchUpInside)
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size:screenWidth/20)
        view.addSubview(button)
    }
    
    func createGameButton() {
        let button = UIButton()
        setButton(button, buttonName: "Play")
        button.addTarget(self, action: #selector(ViewController.buttonGameClick(_:)), for: UIControlEvents.touchUpInside)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size:screenWidth/20)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CGFloat(screenHeight/10)).isActive = true
        button.widthAnchor.constraint(equalToConstant: CGFloat(screenWidth/2)).isActive = true
        NSLayoutConstraint(item: button, attribute: .topMargin, relatedBy: .equal,
            toItem: view, attribute:  .bottomMargin, multiplier: 0.3, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: screenWidth/4).isActive = true

        
    }
    
    func buttonGameClick(_ Sender: UIButton!) {
        performSegue(withIdentifier: "game", sender: self)
    }
    
    func buttonHighScoresClick(_ Sender: UIButton!) {
        performSegue(withIdentifier: "highscores", sender: self)
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    
    @IBAction func unwindToViewController(_ segue: UIStoryboardSegue) {

    }


}

