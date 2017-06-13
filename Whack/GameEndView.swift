import UIKit
import MapKit

class GameEndView: UIViewController {
    
    let stackView = UIStackView()
    
    var score = 0
    var location = CLLocation()
    var newHighScore = false
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        stackView.axis  = UILayoutConstraintAxis.Vertical
        stackView.distribution  = .EqualSpacing
        stackView.alignment = .Center
        stackView.spacing   = view.frame.height*0.1
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        
        setText("your score is " + String(score))
        
        let preferences = NSUserDefaults.standardUserDefaults()
        if let scoresdata = preferences.objectForKey("Scores") as? NSData {
            if let scores =  NSKeyedUnarchiver.unarchiveObjectWithData(scoresdata) {
                if let temp = scores as?[Score] {
                    if temp.count < 10 || temp[temp.count-1].scoreNumber < score {
                        setText("new highscore")
                        setScoreView()
                        newHighScore = true
                    }
                }
            }
            
        }
        else {
            setText("new highscore")
            setScoreView()
            newHighScore = true
        }
        
        setButton()


    }
    
    func setText(text : String){
        let title:UILabel = UILabel()
        title.font = UIFont.init(name: "Helvetica", size: UIScreen.mainScreen().bounds.height/20)
        title.text = text
        title.widthAnchor.constraintEqualToConstant(self.view.frame.width).active = true
        title.font = UIFont.init(name: "Helvetica", size: UIScreen.mainScreen().bounds.height/20)
        title.textAlignment = .Center
        title.textAlignment = NSTextAlignment.Center
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        
        stackView.addArrangedSubview(title)
    }
    
    func setScoreView() {
        let stackScoreView = UIStackView()
        stackScoreView.axis = .Horizontal
        stackScoreView.distribution = .Fill
        stackScoreView.alignment = .Fill
        stackScoreView.widthAnchor.constraintEqualToConstant(view.frame.width*0.8).active = true
        
        //Text Label
        let nameLabel = UILabel()
        nameLabel.text = "enter name:"
        stackScoreView.addArrangedSubview(nameLabel)

        //Text Field
        textField.font = UIFont.systemFontOfSize(15)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        stackScoreView.addArrangedSubview(textField)
        textField.widthAnchor.constraintEqualToConstant(view.frame.width*0.5).active = true
        
        stackView.addArrangedSubview(stackScoreView)
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
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size: UIScreen.mainScreen().bounds.width/20)
        stackView.addArrangedSubview(button)
        
        button.widthAnchor.constraintEqualToConstant(view.frame.width*0.5).active = true
    }
    
    func returnToMenu(Sender: UIButton!) {
        if(newHighScore) {
            let preferences = NSUserDefaults.standardUserDefaults()
            let playerName = textField.text ?? ""
            if let scoresdata = preferences.objectForKey("Scores") as? NSData {
                if let scores =  NSKeyedUnarchiver.unarchiveObjectWithData(scoresdata) {
                    if var temp = scores as?[Score] {
                        if temp.count == 10 {
                            temp.popLast()
                        }
                        temp.append(Score(player: playerName, scoreNumber: score, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        temp.sortInPlace { $0.scoreNumber > $1.scoreNumber }
                        preferences.setValue(NSKeyedArchiver.archivedDataWithRootObject(temp), forKey: "Scores")
                    }
                }
            } else {
                let scores : [Score] = [Score(player: playerName, scoreNumber: score, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)]
                preferences.setValue(NSKeyedArchiver.archivedDataWithRootObject(scores), forKey: "Scores")
            }
            preferences.synchronize()
        }
        
        self.performSegueWithIdentifier("menu", sender: self)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}

