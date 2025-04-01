extends Button

var colours: Dictionary = {
	damage = "ac3232",
	shield = "5b6ee1",
	heal = "5b6ee1",
	mult = "76428a"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)
	draw_jokers.call_deferred()
	for i in range(0,5):
		call_deferred("fill_hand")

func _button_pressed() -> void:
	if $"../Playing".Cards.is_empty(): return
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		return
	var cards: Array[Card] = []
	for c: CanvasCard in $"../Playing".Cards:
		cards.append(c.card)
	$"../Deck".hand = cards
	var jokers: Array[Joker] = []
	for j: CanvasCard in $"../Jokers".Cards:
		cards.append(j.card as Joker)
	await play_hand(get_tree().get_nodes_in_group("enemies")[$"../Target".target], $"../CombatPlayer", cards, jokers)
	var i: int = $"../Playing".Cards.size()
	for c: CanvasCard in $"../Playing".Cards:
		c.target_position = $"../Deck".position
		c.origin_position = c.target_position
		c.animationvar = 0
		var temp: Timer = Timer.new()
		get_parent().add_child(temp)
		temp.start(0.5)
		temp.timeout.connect(func(): 
			$"../Playing".Cards = $"../Playing".Cards.filter(func(g: CanvasCard): return g != c)
			get_parent().remove_child(c)
			temp.stop()
			temp.get_parent().remove_child(temp)
		)
		$"../Deck".hand.clear()
		for h: CanvasCard in ($"../Hand" as CardContainer).Cards:
			$"../Deck".hand.append(h.card)
	for k in range (0, i):
		fill_hand()
	if get_tree().get_node_count_in_group("enemies") == 0:
		var tempPlayer: CombatEntity = $"../../../AspectRatioContainer/CombatPlayer"
		SaveData.playerStats = {
			health = tempPlayer.health,
			max_health = tempPlayer.max_health,
			shield = tempPlayer.shield,
		}
		get_tree().change_scene_to_packed(SaveData.save_scene)
		return
	if !get_parent().has_node("CombatPlayer"):
		get_tree().change_scene_to_file("res://Scenes/Win-Loss/Lose.tscn")
		return
	for e: CombatEnemy in get_tree().get_nodes_in_group("enemies"):
		e.take_turn()

func draw_jokers() -> void:
	for joker: Joker in SaveData.saveFile.jokers:
		var c = CanvasCard.init(joker)
		$"../../../Jokers/HBoxContainer".add_child(c)
		var container = get_node("../../../Jokers")
		c.parent_array = container.get_path()
		container.Cards.append(c)
		container.reorder()
		c.z_index = z_index+1

func fill_hand() -> void: 
	var deck = $"../CenterContainer/Deck"
	var c = CanvasCard.init(deck.draw_card())
	
	# Get the hand container and add the card to it
	var hand_container = get_node("../../VBoxContainer/Hand")
	hand_container.get_node("HBoxContainer").add_child(c)
	c.parent_array = hand_container.get_path()
	c.owned_by = hand_container.get_node("HBoxContainer")
	
	hand_container.Cards.append(c)
	hand_container.reorder()
	c.z_index = z_index + 1

func play_hand(enemy: CombatEntity, friendly: CombatEntity, cards: Array[Card], jokers: Array[Joker]) -> void:
	if cards.is_empty(): return
	var dict = Card.affect_dict.duplicate()
	cards = cards.duplicate(true)
	
	# Apply base card effects first
	for c: Card in cards:
		for k in c.affect.keys():
			if c.affect[k] != 0:
				dict[k] += c.affect[k]
				var target = enemy if k == "damage" else friendly
				CardNotifier.notify(str(c.affect[k]), colours[k], target)
				await get_tree().create_timer(0.1).timeout
	
	# Apply joker effects
	var pre_joker_dict = dict.duplicate()
	for joker in jokers:
		if joker.conditions:
			joker.conditions.affect(cards, dict, jokers)
	
	# Show joker effect differences
	for k in dict.keys():
		var difference = dict[k] - pre_joker_dict[k]
		if difference != 0:
			var target = enemy if k == "damage" else friendly
			CardNotifier.notify("+" + str(difference) + " (Joker)", colours[k], target)
			await get_tree().create_timer(0.1).timeout
	
	# Apply final effects
	enemy.damage(dict.damage * dict.mult)
	friendly.heal(dict.heal * dict.mult)
	friendly.shield += dict.shield 
