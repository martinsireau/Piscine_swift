print("Check the 2 enum:\n")

print("COLOR :")
for color in Color.allColors {
        print(color.rawValue)
}
print("VALUE :")
for value in Value.allValues {
        print(value.rawValue)
}

print("\nCreate 3 card:")
let card1 = Card(c: Color.Spade, v: Value.Ace)
let card2 = Card(c: Color.Diamond, v: Value.Two)
let card3 = Card(c: Color.Spade, v: Value.Ace)

print(card1)
print(card2)
print(card3)
print("\nCheck if cards are equals:")
print(card1 == card2)
print(card1 == card3)

var deck = Deck.allCards
let spades = Deck.allSpades
let diamonds = Deck.allDiamonds
let hearts = Deck.allHearts
let clubs = Deck.allHearts

print("Deck = \(deck) so there is \(deck.count) cards")
print("all spades = \(spades)")
print("all diamonds = \(diamonds)")
print("all hearts = \(hearts)")
print("all clubs = \(clubs)")

var myDeckSorted = Deck(hasToBeSort: true)

print("\nDisplay Deck Description :\n")
print(myDeckSorted)

var myDeckBlended = Deck(hasToBeSort: false)

print("\nBlended : \n")
print(myDeckBlended)

print("\nDraw method, take the first card of cards and place it in outs.\nlet's do this 10 times")

for _ in 0...9 {
        _ = myDeckSorted.draw()
}

print("\ncards now :\n")
print(myDeckSorted.cards)
print("\nouts now :\n")
print(myDeckSorted.outs)

print("\nFold method, place card c in discards if she's in outs: ")
myDeckSorted.fold(c: card1)
myDeckSorted.fold(c: card2)

print("\nouts now :\n")
print(myDeckSorted.outs)

print("\ndiscards now :\n")
print(myDeckSorted.discards)
