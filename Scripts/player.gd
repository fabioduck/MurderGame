extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $Sword_HitBox
@onready var game = $".."

const SPEED = 200
var sword_speed = 1

var dead = false
var sword_hit = true
var hit_detected = false
# Remove?
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sword.monitorable = false
	sword.monitoring = false
	sword.visible = false
	animated_sprite.speed_scale = sword_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attacking = true
		if !game.round_over:
			animated_sprite.play("attack")
	

func _physics_process(delta):
	if attacking and !hit_detected:
		transform = transform.translated(Vector2.RIGHT * delta * SPEED)

func _on_area_entered(area):
	handleHit(area, false)

func _on_sword_hit_box_area_entered(area):
	sword_hit = true
	handleHit(area, true)

func _on_animated_sprite_2d_animation_finished():
	toggleSword()
	
func toggleSword():
	sword.monitorable = !sword.monitorable
	sword.monitoring = !sword.monitoring
	sword.visible = !sword.visible
	
func handleHit(opponent, is_sword):
	if !hit_detected:
		if !is_sword:
			# RIP :(
			dead = true
			toggleSword()
			animated_sprite.play("idle")
			animated_sprite.pause()
		attacking = false
		hit_detected = true
