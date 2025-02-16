extends JokerAffect

func affect(cards: Array[Card], score: Dictionary, _jokers: Array[Joker]):
	for c: Card in cards.filter(func(c: Card): return c.type == Card.CardType.MULT):
		score.mult += c.affect.mult 