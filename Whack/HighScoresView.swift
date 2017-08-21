
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        button.setTitle("return to menu", for: UIControlState())
        button.addTarget(self, action: #selector(HighScoresView.returnToMenu(_:)), for: UIControlEvents.touchUpInside)
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.backgroundColor = UIColor.lightGray
        view.addSubview(button);
        button.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        constraintPortrait()
        constraintLandscape()
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            view.addConstraints(landscapeConstraint)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            view.addConstraints(landscapeConstraint)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            view.addConstraints(portraitConstraint)
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            view.addConstraints(portraitConstraint)
        }
        
        let preferences = UserDefaults.standard
        if let scoresdata = preferences.object(forKey: "Scores") as? Data {
            if let scores =  NSKeyedUnarchiver.unarchiveObject(with: scoresdata) {
                if let temp = scores as?[Score] {
                    items = temp
                }
            }
        }

    }
    
    
    func constraintPortrait() {
        //tableView
        //left
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
            toItem: topLayoutGuide, attribute:  .bottom, multiplier: 1.0, constant: 10))
        portraitConstraint.append(tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3))
        
        //mapView
        //left
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .topMargin, relatedBy: .equal,
            toItem: tableView, attribute:  .bottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        portraitConstraint.append(NSLayoutConstraint(item: mapView, attribute: .bottomMargin, relatedBy: .equal,
            toItem: view, attribute:  .bottomMargin, multiplier: 1.0, constant: -UIScreen.main.bounds.height/10))
        
        //botton
        //left
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0))
        //right
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0))
        //top
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .topMargin, relatedBy: .equal,
            toItem: mapView, attribute:  .bottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        portraitConstraint.append(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal,
            toItem: view, attribute:  .bottom, multiplier: 1.0, constant: -10))
    }
    
    func constraintLandscape() {
        //tableView
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .leftMargin, relatedBy: .equal,
            toItem: view, attribute:  .leftMargin, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 0.5, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal,
            toItem: topLayoutGuide, attribute:  .bottom, multiplier: 1.0, constant: 10))
    landscapeConstraint.append(tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.9))
        
        //mapView
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .left, relatedBy: .equal,
            toItem: tableView, attribute:  .right, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal,
            toItem: topLayoutGuide, attribute:  .bottom, multiplier: 1.0, constant: 10))
        //bottom
        landscapeConstraint.append(NSLayoutConstraint(item: mapView, attribute: .bottomMargin, relatedBy: .equal,
            toItem: view, attribute:  .bottomMargin, multiplier: 1.0, constant: -UIScreen.main.bounds.height/10))
        
        //botton
        //left
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal,
            toItem: tableView, attribute:  .right, multiplier: 1.0, constant: 0))
        //right
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .rightMargin, relatedBy: .equal,
            toItem: view, attribute:  .rightMargin, multiplier: 1.0, constant: 0))
        //top
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .topMargin, relatedBy: .equal,
            toItem: mapView, attribute:  .bottomMargin, multiplier: 1.0, constant: 10))
        //bottom
        landscapeConstraint.append(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal,
            toItem: view, attribute:  .bottom, multiplier: 1.0, constant: -10))
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator:    UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
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
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func returnToMenu(_ Sender: UIButton!) {
        self.performSegue(withIdentifier: "menu2", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
    
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
        stackScoreView.axis = .horizontal
        stackScoreView.distribution = .fillEqually
        stackScoreView.alignment = .lastBaseline

        let playerName = UILabel()
        playerName.text = items[indexPath.row].player
        stackScoreView.addArrangedSubview(playerName)

        let playerScore = UILabel()
        playerScore.text = String(items[indexPath.row].scoreNumber)
        stackScoreView.addArrangedSubview(playerScore)
        
        cell.contentView.addSubview(stackScoreView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = Double(items[indexPath.row].latitude)!
        annotation.coordinate.longitude = Double(items[indexPath.row].longitude)!
        annotation.title = items[indexPath.row].player
        annotation.subtitle = "socre is " + String(items[indexPath.row].scoreNumber)
        mapView.showAnnotations([annotation], animated: true)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= items.count {
            return
        }
        
        var region = MKCoordinateRegion()
        let location = CLLocation(latitude: Double(items[indexPath.row].latitude)!, longitude: Double(items[indexPath.row].longitude)!)
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
