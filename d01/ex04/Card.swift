import Foundation

class Card : NSObject {
    var color : Color
    var value : Value
    
    init(c: Color, v: Value) {
        color = c
        value = v
    }
    
    override var description: String{
        return "(\(value.rawValue), \(color))"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let card = object as? Card
        if (card?.color == self.color && card?.value == self.value) {
            return true
        }
        return false
    }
}
