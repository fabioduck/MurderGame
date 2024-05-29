extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $Sword_HitBox
@onready var game = $".."

const SPEED = 200
var sword_speed = GlobalVariables.current_level * 0.2 + 1

var dead = false
var sword_hit = false
var hit_detected = false
# Remove?
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sword.monitorable = false
	sword.monitoring = false
	sword.visible = false
	animated_sprite.speed_scale = sword_speed

func _physics_process(delta):
	if attacking and !hit_detected:
		transform = transform.translated(Vector2.LEFT * delta * SPEED)

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
	
func handleHit(_opponent, is_sword):
	if !hit_detected:
		if !is_sword:
			# RIP :(
			dead = true
			animated_sprite.play("idle")
			animated_sprite.pause()
		attacking = false
		hit_detected = true


func attack():
	await get_tree().create_timer(1.0/GlobalVariables.current_level).timeout
	attacking = true
	if !game.round_over:
			animated_sprite.play("attack")
			
func reset():
	position = Vector2(50, 0)
	dead = false
	sword_hit = false
	hit_detected = false
	attacking = false
	sword_speed = GlobalVariables.current_level * 0.2 + 1
	animated_sprite.play("idle")
	_ready()
