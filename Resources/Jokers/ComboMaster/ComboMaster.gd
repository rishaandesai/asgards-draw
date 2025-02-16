extends JokerAffect

func affect(cards: Array[Card], score: Dictionary, _jokers: Array[Joker]):
	# Add 0.5 multiplier for each card beyond the first
	if cards.size() > 1:
		score.mult += (cards.size() - 1) * 0.5 