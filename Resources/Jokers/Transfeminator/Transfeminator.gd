extends JokerAffect

func affect(cards: Array[Card], score: Dictionary, jokers: Array[Joker]):
	for c: Card in cards.filter(func(c: Card): return c.type == Card.CardType.HEALER):
		score.heal += c.affect.heal
