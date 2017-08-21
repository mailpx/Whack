import UIKit
import MapKit

class GameEndView: UIViewController {
    
    let stackView = UIStackView()
    
    var score: Int = 0
    var location = CLLocation()
    var newHighScore = false
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = .equalSpacing
        stackView.alignment = .center
        stackView.spacing   = view.frame.height*0.1
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        setText("your score is " + String(score))
        
        let preferences = UserDefaults.standard
        if let scoresdata = preferences.object(forKey: "Scores") as? Data {
            if let scores =  NSKeyedUnarchiver.unarchiveObject(with: scoresdata) {
                if let temp = scores as?[Score] {
                    if temp.count < 10 || Int(temp[temp.count-1].scoreNumber)! < score {
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
    
    func setText(_ text : String){
        let title:UILabel = UILabel()
        title.font = UIFont.init(name: "Helvetica", size: UIScreen.main.bounds.height/20)
        title.text = text
        title.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        title.font = UIFont.init(name: "Helvetica", size: UIScreen.main.bounds.height/20)
        title.textAlignment = .center
        title.textAlignment = NSTextAlignment.center
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 0
        
        stackView.addArrangedSubview(title)
    }
    
    func setScoreView() {
        let stackScoreView = UIStackView()
        stackScoreView.axis = .horizontal
        stackScoreView.distribution = .fill
        stackScoreView.alignment = .fill
        stackScoreView.widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
        
        //Text Label
        let nameLabel = UILabel()
        nameLabel.text = "enter name:"
        stackScoreView.addArrangedSubview(nameLabel)

        //Text Field
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        stackScoreView.addArrangedSubview(textField)
        textField.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        
        stackView.addArrangedSubview(stackScoreView)
    }
    
    func setButton(){
        let button = UIButton()
        button.setTitle("return to menu", for: UIControlState())
        button.setTitleColor(UIColor.yellow, for: UIControlState())
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(GameEndView.returnToMenu(_:)), for: UIControlEvents.touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size: UIScreen.main.bounds.width/20)
        stackView.addArrangedSubview(button)
        
        button.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
    }
    
    func returnToMenu(_ Sender: UIButton!) {
        if(newHighScore) {
            let preferences = UserDefaults.standard
            let playerName = textField.text ?? ""
            if let scoresdata = preferences.object(forKey: "Scores") as? Data {
                if let scores =  NSKeyedUnarchiver.unarchiveObject(with: scoresdata) {
                    if var temp = scores as? [Score] {
                        if temp.count == 10 {
                            temp.popLast()
                        }
                        temp.append(Score(player: playerName, scoreNumber: String(score), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        temp.sort { $0.scoreNumber > $1.scoreNumber }
                        preferences.setValue(NSKeyedArchiver.archivedData(withRootObject: temp), forKey: "Scores")
                    }
                }
            } else {
                let scores : [Score] = [Score(player: playerName, scoreNumber: String(score), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)]
                preferences.setValue(NSKeyedArchiver.archivedData(withRootObject: scores), forKey: "Scores")
            }
            preferences.synchronize()
        }
        
        self.performSegue(withIdentifier: "menu", sender: self)
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
    
}

