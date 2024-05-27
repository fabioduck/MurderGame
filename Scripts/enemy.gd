extends CharacterBody2D

@onready var timer = $"../Timer"
@onready var animation_player = $AnimationPlayer
@onready var timer_text = $"../RichTextLabel"


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_time = 0
var attacking = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
func _process(delta):
	if(attacking):
		var time_elapsed = (Time.get_ticks_msec() - start_time) * 0.1
		timer_text.clear()
		timer_text.add_text(str(time_elapsed).pad_decimals(0))


func _on_timer_timeout():
	attacking = true
	start_time = Time.get_ticks_msec()
	animation_player.play("move")
