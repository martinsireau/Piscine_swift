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
