extends Node

func _ready() -> void:
	for i: int in range(0, SaveData.enemies.size()):
		var enemy = CombatEnemy.init(SaveData.enemies[i])
		enemy.add_to_group("enemies")
		for c: Card in SaveData.enemies[i].deck:
			enemy.deck.append(c.duplicate(true))
		enemy.hand_size = SaveData.enemies[i].hand_size
		enemy.sprite = SaveData.enemies[i].sprite
		add_sibling.call_deferred(enemy)
		enemy.position = get_node(NodePath("../SpawnLocation"+str(i+1))).position
