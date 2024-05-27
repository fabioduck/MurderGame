extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var timer_text = $"../Timer_Text"
@onready var game = $".."

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attacking = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle attack
	if Input.is_action_just_pressed("attack"):
		attacking = true
		if !game.round_over:
			animation_player.play("move")

	move_and_slide()
