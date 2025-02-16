extends JokerAffect

func affect(cards: Array[Card], score: Dictionary, _jokers: Array[Joker]):
	for c: Card in cards.filter(func(c: Card): return c.type == Card.CardType.HEALER):
		score.shield += c.affect.heal / 2  # Add half of healing as shield 