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
    
    var timer = NSTimer()
    
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
            csound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("c", ofType: "wav")!))
            esound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("e", ofType: "wav")!))
        }
        catch{
            
        }
        
        openedCell = Array(0...11)

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.Denied) {
            
        } else if (authorizedLocation && status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            flipTime = 0
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(1), target: self, selector: "flip:", userInfo: nil, repeats: true)
            authorizedLocation = false
        } 
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.MotionShake && shake > 0 {
            shake--
            shakeLabel.text = String(shake)
            shakeTimeOut = 3
            pauseCellAnimations()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            authorizedLocation = true
        }
        else {
            flipTime = 0
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(1), target: self, selector: "flip:", userInfo: nil, repeats: true)
            manager.startUpdatingLocation()
        }

    }
    
    func flip(timer: NSTimer) {
        var timeString = String(time/60) + ":"
        let seconds = time%60
        if seconds < 10 {
            timeString.appendContentsOf("0")
        }
        timeString.appendContentsOf(String(seconds))
        timerLabel.text = timeString
        time--;
        if time < 0 {
            timer.invalidate()
            esound = nil
            performSegueWithIdentifier("score", sender: self)
        }
        if timeOut != 0 {
            timeOut--;
            return;
        }
        if openedCell.count != 0 && flipTime <= 0{
            let index = Int(arc4random_uniform(UInt32(openedCell.count)))
            let cellNumToFlip = openedCell[index]
            openedCell = openedCell.filter() { $0 != cellNumToFlip }
        
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cellNumToFlip, inSection: 0)) as! UIImageCell
            
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
            flipTime--;
        }
        if shakeTimeOut != 0 {
            shakeTimeOut--
            if shakeTimeOut <= 0 {
                resumeCellAnimations()
            }
        }
    }
    
    func missFlip() {
        esound?.play()
    }
    
    func setUpReturnButton() {
        returnButton.setTitle("return", forState: .Normal)
        returnButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        returnButton.backgroundColor = UIColor.lightGrayColor()
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 2
        returnButton.layer.borderColor = UIColor.blackColor().CGColor
        returnButton.addTarget(self, action: "returnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        returnButton.titleLabel?.font = UIFont.init(name: "Helvetica", size:UIScreen.mainScreen().bounds.width/20)
        view.addSubview(returnButton)
        
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        //left
        let leftConstraint = NSLayoutConstraint(item: returnButton, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: returnButton, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 0.2, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: returnButton, attribute: .Top, relatedBy: .Equal,
            toItem: collectionView, attribute:  .Bottom, multiplier: 1.0, constant: 0)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: returnButton, attribute: .Bottom, relatedBy: .Equal,
            toItem: view, attribute:  .Bottom, multiplier: 1.0, constant: -10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setUpShakeLabel() {
        let shakeStackView = UIStackView()
        shakeStackView.axis = .Horizontal
        shakeStackView.distribution = .FillEqually
        shakeStackView.alignment = .Fill
        shakeStackView.spacing = 10
        
        let shakeTextLabel = UILabel()
        shakeTextLabel.text = "shake:"
        shakeTextLabel.font = UIFont.systemFontOfSize(UIScreen.mainScreen().bounds.height/40)
        shakeStackView.addArrangedSubview(shakeTextLabel)
        
        setUILael(shakeLabel, text: String(shake), size: UIScreen.mainScreen().bounds.height/40)
        shakeStackView.addArrangedSubview(shakeLabel)
        
        view.addSubview(shakeStackView)
        
        shakeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: UIScreen.mainScreen().bounds.width*0.6)
        //right
        let rightConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .Top, relatedBy: .Equal,
            toItem: collectionView, attribute:  .Bottom, multiplier: 1.0, constant: 0)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: shakeStackView, attribute: .Bottom, relatedBy: .Equal,
            toItem: view, attribute:  .Bottom, multiplier: 1.0, constant: -10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setUILael(label: UILabel, text : String, size : CGFloat) {
        label.text = text
        label.backgroundColor = UIColor.blackColor()
        label.textColor = UIColor.redColor()
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.darkGrayColor().CGColor
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.init(name: "digital-7", size: size)
    }
    
    func setUpStackView() {
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 10

        let scoreTextLabel = UILabel()
        scoreTextLabel.text = "score:"
        stackView.addArrangedSubview(scoreTextLabel)
        setUILael(scoreLabel, text: "0", size: UIScreen.mainScreen().bounds.height/20)
        stackView.addArrangedSubview(scoreLabel)
        let timeTextLabel = UILabel()
        timeTextLabel.text = "time:"
        stackView.addArrangedSubview(timeTextLabel)
        setUILael(timerLabel, text: "0", size: UIScreen.mainScreen().bounds.height/20)
        stackView.addArrangedSubview(timerLabel)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: stackView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: stackView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .Top, relatedBy: .Equal,
            toItem: topLayoutGuide, attribute:  .Bottom, multiplier: 1.0, constant: 10)
        
        let stackViewHeight = stackView.heightAnchor.constraintEqualToConstant(UIScreen.mainScreen().bounds.height/10)
        
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, stackViewHeight])
    }
    
    func setUpController() {
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: height/50, left: width/50, bottom: height/50, right: width/50)
        layout.itemSize = CGSize(width: width/4, height: height/6)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UIImageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundView = nil;
        collectionView.backgroundColor = UIColor.clearColor();
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //left
        let leftConstraint = NSLayoutConstraint(item: collectionView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0)
        //right
        let rightConstraint = NSLayoutConstraint(item: collectionView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0)
        
        //top
        let topConstraint = NSLayoutConstraint(item: collectionView, attribute: .TopMargin, relatedBy: .Equal,
            toItem: stackView, attribute:  .BottomMargin, multiplier: 1.0, constant: 10)
        
        //bottom
        let bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .BottomMargin, relatedBy: .Equal,
            toItem: view, attribute:  .BottomMargin, multiplier: 1.0, constant: -height/15)
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UIImageCell
        cell.gameview = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UIImageCell

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
        for(var i = 0; i < 12; i++) {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! UIImageCell
            if cell.isFliped {
                cell.pauseAnimation()
            }
        }
    }
    
    func resumeCellAnimations() {
        for(var i = 0; i < 12; i++) {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! UIImageCell
            if cell.isFliped {
                cell.resumeAnimation()
            }
        }
    }
    
    func returnClick(Sender: UIButton!) {
        timer.invalidate()
        pauseCellAnimations()
        let alert = UIAlertController(title: "Alert", message: "are you sure you want to return", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { action in
            self.performSegueWithIdentifier("return", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Cancel, handler: { action in
            self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(1), target: self, selector: "flip:", userInfo: nil, repeats: true)
            self.resumeCellAnimations()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender:    AnyObject?)   {
        
        if (segue.identifier == "score") {
            
            let vc = segue.destinationViewController as!  GameEndView
            vc.score = score
            vc.location = location
            
        }
    }
    
}