import UIKit

import Foundation
import AVFoundation
class GameView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var collectionView: UICollectionView!
    let stackView = UIStackView()
    
    var csound : AVAudioPlayer? = AVAudioPlayer()
    var esound : AVAudioPlayer? = AVAudioPlayer()
    
    let scoreLabel = UILabel()
    let missLabel = UILabel()
    
    var openedCell = [Int]();
    
    let MAXSCORE = 10
    let MAXMISS = 3
    var score = 0
    var miss = 0
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpStackView()
        setUpController()
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let time = arc4random_uniform(2) + 2
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(time), target: self, selector: "flip:", userInfo: nil, repeats: true)
        flip(timer)

    }
    
    func flip(timer: NSTimer) {
        if openedCell.count != 0 {
            let index = Int(arc4random_uniform(UInt32(openedCell.count)))
            let cellNumToFlip = openedCell[index]
            openedCell = openedCell.filter() { $0 != cellNumToFlip }
        
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: cellNumToFlip, inSection: 0)) as! UIImageCell
            cell.flipImageFront(self)
        }
    }
    
    func missFlip() {
        miss += 1;
        esound?.play()
        missLabel.text = String(miss)
        if miss >= MAXMISS {
            timer.invalidate()
            performSegueWithIdentifier("lose", sender: self)
        }
        
    }
    
    func setUILael(label: UILabel) {
        label.text = "0"
        label.backgroundColor = UIColor.blackColor()
        label.textColor = UIColor.redColor()
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.darkGrayColor().CGColor
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.init(name: "digital-7", size: UIScreen.mainScreen().bounds.height/20)
    }
    
    func setUpStackView() {
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 10

        let scoreTextLabel = UILabel()
        scoreTextLabel.text = "score:"
        stackView.addArrangedSubview(scoreTextLabel)
        setUILael(scoreLabel)
        stackView.addArrangedSubview(scoreLabel)
        let missTextLabel = UILabel()
        missTextLabel.text = "miss:"
        stackView.addArrangedSubview(missTextLabel)
        setUILael(missLabel)
        stackView.addArrangedSubview(missLabel)
        
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
        layout.itemSize = CGSize(width: width/4, height: height/5.5)
        
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
            toItem: view, attribute:  .BottomMargin, multiplier: 1.0, constant: 0)
        
        //add constraints
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UIImageCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UIImageCell
        
        if cell.isFliped {
            score+=1
            csound?.play()
            scoreLabel.text = String(score)
            if score >= MAXSCORE {
                timer.invalidate()
                performSegueWithIdentifier("win", sender: self)
            }
            cell.flipImageBack()
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}