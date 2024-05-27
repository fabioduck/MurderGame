extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var game = $".."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attacking = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_start_delay_timeout():
	await get_tree().create_timer(1.0/GlobalVariables.current_level).timeout
	if !game.round_over:
		attacking = true
		animation_player.play("move")
