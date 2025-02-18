extends Node2D

@export var possible_cards: Array[Card] = []
@export var num_cards: int = 0
var e: Sprite2D
var done: bool = false

func _ready() -> void:
	$AnimatedSprite2D.animation_looped.connect(func(): 
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 3)

func open_chest() -> void:
	$AnimatedSprite2D.play("default")
	done = true
	for i in range(num_cards):
		if !possible_cards.is_empty():
			var card = possible_cards.pick_random().duplicate()
			# Add card to appropriate list in SaveData
			if card is Joker:
				SaveData.jokers.append(card)
			else:
				SaveData.deck.append(card)
			owner.get_node("HUD").notify(owner.get_node("HUD").eStyles.POSITIVE, card.texture)
			
			# Remove card from possible rewards to prevent duplicates
			possible_cards.erase(card)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = load("res://Resources/Textures/UI/E.tres")
		self.add_child(sprite)
		e = sprite
		sprite.position = Vector2(0, -1*sprite.texture.get_size().y)




func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		self.remove_child.call_deferred(e)


func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	event = event as InputEventKey
	if event.keycode != KEY_E: return
	var characters = $Area2D.get_overlapping_bodies().filter(func(overlap: Node2D): return overlap is CharacterBody2D)
	if not characters.is_empty() && !done:
		open_chest()
		
