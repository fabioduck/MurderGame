extends Node2D

var enemy = preload("res://Prefabs/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func destroy():
	if self.get_child_count() > 0:
		self.get_child(0).queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func respawn():
	var enemy_instance = enemy.instantiate()
	self.add_child(enemy_instance)
	return enemy_instance
