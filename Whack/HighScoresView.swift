
import UIKit
import MapKit

class HighScoresView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = UITableView()
    let mapView = MKMapView()
    let button = UIButton()
    var items: [Score] = []
    var portraitConstraint : [NSLayoutConstraint] = []
    var landscapeConstraint: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        button.setTitle("return to menu", forState: .Normal)
        button.addTarget(self, action: "returnToMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(button);
        button.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        constraintPortrait()
        constraintLandscape()
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft{
            view.addConstraints(landscapeConstraint)
        }
        else if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight{
            view.addConstraints(landscapeConstraint)
        }
        else if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
            view.addConstraints(portraitConstraint)
        }
        else if UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown{
            view.addConstraints(portraitConstraint)
        }
        
        let preferences = NSUserDefaults.standardUserDefaults()
        if let scoresdata = preferences.objectForKey("Scores") as? NSData {
            if let scores =  NSKeyedUnarchiver.unarchiveObjectWithData(scoresdata) {
                if let temp = scores as?[Score] {
                    items = temp
                }
            }
        }

    }
    
    
    func constraintPortrait() {
        //tableView
        //left
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal,
            toItem: topLayoutGuide, attribute:  .Bottom, multiplier: 1.0, constant: 10))
        portraitConstraint.append(tableView.heightAnchor.constraintEqualToConstant(UIScreen.mainScreen().bounds.height/3))
        
        //mapView
        //left
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .TopMargin, relatedBy: .Equal,
            toItem: tableView, attribute:  .BottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .BottomMargin, relatedBy: .Equal,
            toItem: view, attribute:  .BottomMargin, multiplier: 1.0, constant: -UIScreen.mainScreen().bounds.height/10))
        
        //botton
        //left
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .TopMargin, relatedBy: .Equal,
            toItem: mapView, attribute:  .BottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal,
            toItem: view, attribute:  .Bottom, multiplier: 1.0, constant: -10))
    }
    
    func constraintLandscape() {
        //tableView
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .LeftMargin, relatedBy: .Equal,
            toItem: view, attribute:  .LeftMargin, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 0.5, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal,
            toItem: topLayoutGuide, attribute:  .Bottom, multiplier: 1.0, constant: 10))
    landscapeConstraint.append(tableView.heightAnchor.constraintEqualToConstant(UIScreen.mainScreen().bounds.width*0.9))
        
        //mapView
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .Left, relatedBy: .Equal,
            toItem: tableView, attribute:  .Right, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal,
            toItem: topLayoutGuide, attribute:  .Bottom, multiplier: 1.0, constant: 10))
        //bottom
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .BottomMargin, relatedBy: .Equal,
            toItem: view, attribute:  .BottomMargin, multiplier: 1.0, constant: -UIScreen.mainScreen().bounds.height/10))
        
        //botton
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal,
            toItem: tableView, attribute:  .Right, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .RightMargin, relatedBy: .Equal,
            toItem: view, attribute:  .RightMargin, multiplier: 1.0, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .TopMargin, relatedBy: .Equal,
            toItem: mapView, attribute:  .BottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal,
            toItem: view, attribute:  .Bottom, multiplier: 1.0, constant: -10))
    }

    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:    UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.sharedApplication().statusBarOrientation
            
            switch orient {
            case .Portrait:
                self.view.removeConstraints(self.landscapeConstraint)
                self.view.addConstraints(self.portraitConstraint)
                break
            default:
                self.view.removeConstraints(self.portraitConstraint)
                self.view.addConstraints(self.landscapeConstraint)
                break
            }
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                
        })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    func returnToMenu(Sender: UIButton!) {
        self.performSegueWithIdentifier("menu2", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
    
        if cell.contentView.subviews.count != 0 {
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        if indexPath.row >= items.count {
            cell.textLabel?.text?.removeAll()
            if indexPath.row == 0 {
                cell.textLabel?.text = "no highscore"
            }
            return cell
        }
        
        let stackScoreView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        stackScoreView.axis = .Horizontal
        stackScoreView.distribution = .FillEqually
        stackScoreView.alignment = .LastBaseline

        let playerName = UILabel()
        playerName.text = items[indexPath.row].player
        stackScoreView.addArrangedSubview(playerName)

        let playerScore = UILabel()
        playerScore.text = String(items[indexPath.row].scoreNumber)
        stackScoreView.addArrangedSubview(playerScore)
        
        cell.contentView.addSubview(stackScoreView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = items[indexPath.row].latitude
        annotation.coordinate.longitude = items[indexPath.row].longitude
        annotation.title = items[indexPath.row].player
        annotation.subtitle = "socre is " + String(items[indexPath.row].scoreNumber)
        mapView.showAnnotations([annotation], animated: true)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= items.count {
            return
        }
        
        var region = MKCoordinateRegion()
        let location = CLLocation(latitude: items[indexPath.row].latitude, longitude: items[indexPath.row].longitude)
        region.center = location.coordinate
        var span = MKCoordinateSpan()
        span.latitudeDelta = 1
        span.longitudeDelta = 1
        region.span = span
        
        mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
