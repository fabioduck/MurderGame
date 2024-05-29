extends Node2D

var player = preload("res://Prefabs/player.tscn")
# Called when the node enters the scene tree for the first time.
func destroy():
	if self.get_child_count() > 0:
		self.get_child(0).queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func respawn():
	var player_instance = player.instantiate()
	self.add_child(player_instance)
	return player_instance
