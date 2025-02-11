extends Node

func _ready() -> void:
	for i: int in range(0, SaveData.enemies.size()):
		var enemy = CombatEnemy.init(SaveData.enemies[i])
		enemy.add_to_group("enemies")
		enemy.deck = SaveData.enemies[i].deck
		enemy.hand_size = SaveData.enemies[i].hand_size
		add_sibling.call_deferred(enemy)
		enemy.position = get_node(NodePath("../SpawnLocation"+str(i+1))).position
