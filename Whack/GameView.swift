import UIKit

import Foundation
import MapKit
import AVFoundation
class GameView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate{
    
    var collectionView: UICollectionView!
    let stackView = UIStackView()
    
    let manager = CLLocationManager()
    var location = CLLocation()
    
    var csound : AVAudioPlayer? = AVAudioPlayer()
    var esound : AVAudioPlayer? = AVAudioPlayer()
    
    let scoreLabel = UILabel()
    let timerLabel = UILabel()
    let shakeLabel = UILabel()
    let returnButton = UIButton();
    
    var openedCell = [Int]();
    
    let MAXTIMEOUT = 3
    var time = 60
    var score = 0
    var timeOut = 0
    var flipTime = 0
    var shake = 3
    var shakeTimeOut = 0;
    var authorizedLocation = false
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        setUpStackView()
        setUpController()
        setUpReturnButton()
        setUpShakeLabel()
        
        //set sounds
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        do{
            csound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "c", ofType: "wav")!))
            esound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "e", ofType: "wav")!))
        }
        catch{
            
        }
        
        openedCell = Array(0...11)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            
        } else if (authorizedLocation && status == CLAuthorizationStatus.authorizedWhenInUse) {
            flipTime = 0
            timer = Timer.scheduledTimer(timeInterval: Double(1), target: self, selector: #selector(GameView.flip(_:)), userInfo: nil, repeats: true)
            authorizedLocation = false
        } 
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.motionShake && shake > 0 {
            shake -= 1
            shakeLabel.text = String(shake)
            shakeTimeOut = 3
            pauseCellAnimations()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            authorizedLocation = true
        }
        else {
            flipTime = 0
            timer = Timer.scheduledTimer(timeInterval: Double(1), target: self, selector: #selector(GameView.flip(_:)), userInfo: nil, repeats: true)
            manager.startUpdatingLocation()
        }

    }
    
    func flip(_ timer: Timer) {
        var timeString = String(time/60) + ":"
        let seconds = time%60
        if seconds < 10 {
            timeString.append("0")
        }
        timeString.append(String(seconds))
        timerLabel.text = timeString
        time -= 1;
        if time < 0 {
            timer.invalidate()
            esound = nil
            performSegue(withIdentifier: "score", sender: self)
        }
        if timeOut != 0 {
            timeOut -= 1;
            return;
        }
        if openedCell.count != 0 && flipTime <= 0{
            let index = Int(arc4random_uniform(UInt32(openedCell.count)))
            let cellNumToFlip = openedCell[index]
            openedCell = openedCell.filter() { $0 != cellNumToFlip }
        
            let cell = collectionView.cellForItem(at: IndexPath(row: cellNumToFlip, section: 0)) as! UIImageCell
            
            let isCellTimeOut = Int(arc4random_uniform(4))
            if isCellTimeOut == 0 {
                cell.flipImageFrontTimeOut()
            }
            else {
                cell.flipImageFront()
            }
            if shakeTimeOut > 0 {
                cell.pauseAnimation()
            }
            flipTime = 1
        }
        else {
            flipTime -= 1;
        }
        if shakeTimeOut != 0 {
            shakeTimeOut -= 1
            if shakeTimeOut <= 0 {
                resumeCellAnimations()
            }
        }
    }
    
    func missFlip() {
        esound?.play()
    }
    
    func setUpReturnButton() {
        returnButton.setTitle("return", for: UIControlState())
        returnButton.setTitleColor(UIColor.yellow, for: UIControlState())
        returnButton.backgroundColor = UIColor.lightGray
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 2
        returnButton.layer.borderColor = UIColor.black.cgColor
        returnButton.addTarget(self, action: #selector(GameView.returnClick(_:)), for: UIControlEvents.touchUpInside)
        
        returnButton.titleLabel?.font = UIFont.init(name: "Helvetica", size:UIScreen.main.bounds.width/20)
        view.addSubview(returnButton)
        
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        //left
        let leftConstraint = NSLayoutConstraint(item: returnButton, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: returnButton, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 0.2, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: returnButton, attribute: .top, relatedBy: .equal,
            toItem: collectionView, attribute:  .bottom, multiplier: 1.0, constant: 0)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: returnButton, attribute: .bottom, relatedBy: .equal,
            toItem: view, attribute:  .bottom, multiplier: 1.0, constant: -10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setUpShakeLabel() {
        let shakeStackView = UIStackView()
        shakeStackView.axis = .horizontal
        shakeStackView.distribution = .fillEqually
        shakeStackView.alignment = .fill
        shakeStackView.spacing = 10
        
        let shakeTextLabel = UILabel()
        shakeTextLabel.text = "shake:"
        shakeTextLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/40)
        shakeStackView.addArrangedSubview(shakeTextLabel)
        
        setUILael(shakeLabel, text: String(shake), size: UIScreen.main.bounds.height/40)
        shakeStackView.addArrangedSubview(shakeLabel)
        
        view.addSubview(shakeStackView)
        
        shakeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: UIScreen.main.bounds.width*0.6)
        //right
        let rightConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .top, relatedBy: .equal,
            toItem: collectionView, attribute:  .bottom, multiplier: 1.0, constant: 0)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .bottom, relatedBy: .equal,
            toItem: view, attribute:  .bottom, multiplier: 1.0, constant: -10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setUILael(_ label: UILabel, text : String, size : CGFloat) {
        label.text = text
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.red
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.init(name: "digital-7", size: size)
    }
    
    func setUpStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10

        let scoreTextLabel = UILabel()
        scoreTextLabel.text = "score:"
        stackView.addArrangedSubview(scoreTextLabel)
        setUILael(scoreLabel, text: "0", size: UIScreen.main.bounds.height/20)
        stackView.addArrangedSubview(scoreLabel)
        let timeTextLabel = UILabel()
        timeTextLabel.text = "time:"
        stackView.addArrangedSubview(timeTextLabel)
        setUILael(timerLabel, text: "0", size: UIScreen.main.bounds.height/20)
        stackView.addArrangedSubview(timerLabel)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: stackView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: stackView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal,
            toItem: topLayoutGuide, attribute:  .bottom, multiplier: 1.0, constant: 10)
        
        let stackViewHeight = stackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, stackViewHeight])
    }
    
    func setUpController() {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: height/50, left: width/50, bottom: height/50, right: width/50)
        layout.itemSize = CGSize(width: width/4, height: height/6)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UIImageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundView = nil;
        collectionView.backgroundColor = UIColor.clear;
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: collectionView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: collectionView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: collectionView, attribute: .topMargin, relatedBy: .equal,
            toItem: stackView, attribute:  .bottomMargin, multiplier: 1.0, constant: 10)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottomMargin, relatedBy: .equal,
            toItem: view, attribute:  .bottomMargin, multiplier: 1.0, constant: -height/15)
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UIImageCell
        cell.gameview = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! UIImageCell

        if cell.isFliped {
            if cell.isTimeOut{
                timeOut = MAXTIMEOUT;
                cell.flipImageBackTimeOut()
            }
            else {
                score+=1
                csound?.play()
                scoreLabel.text = String(score)
                cell.isMiss = false
                cell.flipImageBack()
            }
            openedCell.append(indexPath.item)
        }
        
    }
    
    func pauseCellAnimations() {
        for i in 0 ..< 12 {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! UIImageCell
            if cell.isFliped {
                cell.pauseAnimation()
            }
        }
    }
    
    func resumeCellAnimations() {
        for i in 0 ..< 12 {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! UIImageCell
            if cell.isFliped {
                cell.resumeAnimation()
            }
        }
    }
    
    func returnClick(_ Sender: UIButton!) {
        timer.invalidate()
        pauseCellAnimations()
        let alert = UIAlertController(title: "Alert", message: "are you sure you want to return", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.default, handler: { action in
            self.performSegue(withIdentifier: "return", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.cancel, handler: { action in
            self.timer = Timer.scheduledTimer(timeInterval: Double(1), target: self, selector: #selector(GameView.flip(_:)), userInfo: nil, repeats: true)
            self.resumeCellAnimations()
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender:    Any?)   {
        
        if (segue.identifier == "score") {
            
            let vc = segue.destination as!  GameEndView
            vc.score = score
            vc.location = location
            
        }
    }
    
}
