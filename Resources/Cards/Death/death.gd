extends JokerAffect

func affect(_cards: Array[Card], _score: Dictionary, _jokers: Array[Joker]):
	for card: Card in _cards:
		for key in _score.keys():
			_score[key] *= 10
