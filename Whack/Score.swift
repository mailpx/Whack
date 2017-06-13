import Foundation

class Score : NSObject, NSCoding {
    var player : String
    var scoreNumber: Int
    var latitude : Double
    var longitude : Double
    
    init(player : String, scoreNumber : Int, latitude : Double, longitude : Double) {
        self.player = player
        self.scoreNumber = scoreNumber
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.player = (aDecoder.decodeObjectForKey("name") as? String)!
        self.scoreNumber = (aDecoder.decodeObjectForKey("score") as? Int)!
        self.latitude = (aDecoder.decodeObjectForKey("latitude") as? Double)!
        self.longitude = (aDecoder.decodeObjectForKey("longitude") as? Double)!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.player, forKey: "name")
        aCoder.encodeObject(self.scoreNumber, forKey: "score")
        aCoder.encodeObject(self.latitude, forKey: "latitude")
        aCoder.encodeObject(self.longitude, forKey: "longitude")
    }
}
