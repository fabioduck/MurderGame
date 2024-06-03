extends Node2D
@onready var player = $".."
@onready var local_transform = $Local_Transform
@onready var hat = $Local_Transform/Hat0

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	local_transform.position = Vector2.ZERO
	local_transform.rotation_degrees = 0
	local_transform.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_frame_changed():
	if GlobalVariables.current_level == 2:
		hat.visible = true
	elif local_transform.get_child_count() < GlobalVariables.current_level:
		var new_hat = hat.duplicate()
		new_hat.position.y = new_hat.position.y - 4 * (GlobalVariables.current_level - 2)
		local_transform.add_child(new_hat)
	if player.animated_sprite.animation == "idle":
		if !player.animated_sprite.frame == 0 and !player.animated_sprite.frame == 8 and !player.animated_sprite.frame == 4:
			if player.animated_sprite.frame > 3:
				local_transform.position.y = local_transform.position.y - 1
			else:
				local_transform.position.y = local_transform.position.y + 1
	elif player.animated_sprite.animation == "attack":
		if player.animated_sprite.frame == 1:
			local_transform.position.x = local_transform.position.x + 1
		elif player.animated_sprite.frame == 2:
			local_transform.position.x = local_transform.position.x + 3
			local_transform.position.y = local_transform.position.y + 1
		elif player.animated_sprite.frame == 3:
			local_transform.position.x = local_transform.position.x + 2
			local_transform.position.y = local_transform.position.y + 1
			local_transform.rotation_degrees = 10
	elif player.animated_sprite.animation == "death":
		remove_hats()

func _on_animated_sprite_2d_animation_changed():
	if GlobalVariables.current_level == 1 and local_transform != null:
		remove_hats()
	_ready()
	
func remove_hats():
	local_transform.visible = false
	hat.visible = false
	for child in local_transform.get_children():
		if child.name != "Hat0":
			local_transform.remove_child(child)
	_ready()
