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
print("\nIs Card1 and 2 are equals?")
print(card1 == card2)
print("\nIs Card1 and 3 are equals?")
print(card1 == card3)

var deck = Deck.allCards
let spades = Deck.allSpades
let diamonds = Deck.allDiamonds
let hearts = Deck.allHearts
let clubs = Deck.allClubs

print("Deck = \(deck) so there is \(deck.count) cards")
print("all spades = \(spades)")
print("all diamonds = \(diamonds)")
print("all hearts = \(hearts)")
print("all clubs = \(clubs)")

print("\nSorted deck = ")
print(deck)
print("\nBlended deck = ")
print(deck.blend())

