extends Node2D

@export var possible_cards: Array[Card] = []
@export var num_cards: int = 3

var interaction_sprite: Sprite2D
var is_opened: bool = false

func _ready() -> void:
	setup_animation_callback()
	if possible_cards.is_empty():
		load_all_cards()

func setup_animation_callback() -> void:
	$AnimatedSprite2D.animation_looped.connect(func():
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 3
	)

func load_all_cards() -> void:
	var all_cards = (load("res://Resources/all_cards.tscn") as PackedScene).instantiate()
	possible_cards = all_cards.AllCards.duplicate()

func open_chest() -> void:
	if is_opened:
		return
		
	is_opened = true
	$AnimatedSprite2D.play("default")
	distribute_cards()

func distribute_cards() -> void:
	for i in range(num_cards):
		if possible_cards.is_empty():
			break
			
		var card = possible_cards.pick_random().duplicate()
		add_card_to_inventory(card)
		show_card_notification(card)
		possible_cards.erase(card)

func add_card_to_inventory(card: Card) -> void:
	if card is Joker:
		SaveData.saveFile.jokers.append(card)
	else:
		SaveData.saveFile.deck.append(card)

func show_card_notification(card: Card) -> void:
	print_debug(owner)
	owner.get_node("HUD").notify(owner.get_node("HUD").eStyles.POSITIVE, card.texture)

func show_interaction_prompt() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Resources/Textures/UI/E.tres")
	sprite.position = Vector2(0, -sprite.texture.get_size().y)
	add_child(sprite)
	interaction_sprite = sprite

func hide_interaction_prompt() -> void:
	if interaction_sprite:
		remove_child.call_deferred(interaction_sprite)
		interaction_sprite = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		show_interaction_prompt()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		hide_interaction_prompt()

func _input(event: InputEvent) -> void:
	if not _is_valid_interaction(event):
		return
		
	var characters = $Area2D.get_overlapping_bodies().filter(
		func(overlap: Node2D): return overlap is CharacterBody2D
	)
	
	if not characters.is_empty() and not is_opened:
		open_chest()

func _is_valid_interaction(event: InputEvent) -> bool:
	if not event is InputEventKey:
		return false
	return (event as InputEventKey).keycode == KEY_E
