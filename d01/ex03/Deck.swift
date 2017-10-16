import Foundation

class Deck : NSObject {
    static let allSpades : [Card] = Value.allValues.map {Card(c: Color.Spade, v: $0)}
    static let allDiamonds : [Card] = Value.allValues.map {Card(c: Color.Diamond, v: $0)}
    static let allHearts : [Card] = Value.allValues.map {Card(c: Color.Heart, v: $0)}
    static let allClubs : [Card] = Value.allValues.map {Card(c: Color.Club, v: $0)}

    static let allCards : [Card] = allSpades + allDiamonds + allHearts + allClubs
}

extension Array {
    mutating func blend() -> Array{
        let c = count
        if c < 1 { return self }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(c)))
            if (i != j) {
                (self[i], self[j]) = (self[j], self[i])
            }
        }
        return self
    }
}
