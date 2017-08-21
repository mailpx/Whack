import Foundation

class Score : NSObject, NSCoding {
    var player : String
    var scoreNumber: String
    var latitude : String
    var longitude : String
    
    init(player : String, scoreNumber : String, latitude : Double, longitude : Double) {
        self.player = player
        self.scoreNumber = scoreNumber
        self.latitude = String(latitude)
        self.longitude = String(longitude)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.player = (aDecoder.decodeObject(forKey: "name") as? String)!
        self.scoreNumber = (aDecoder.decodeObject(forKey: "score") as? String)!
        self.latitude = (aDecoder.decodeObject(forKey: "latitude") as? String)!
        self.longitude = (aDecoder.decodeObject(forKey: "longitude") as? String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.player, forKey: "name")
        aCoder.encode(self.scoreNumber, forKey: "score")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
    }
}
