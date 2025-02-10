extends Node

func _ready() -> void:
	for e: EnemyType in SaveData.enemies:
		var enemy = CombatEnemy.init(e)
		print(enemy)
		enemy.add_to_group("enemies")
		add_sibling.call_deferred(enemy)
		enemy.position = get_node(NodePath("../SpawnLocation"+str(SaveData.enemies.find(e)+1))).position
