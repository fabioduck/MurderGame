extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $Sword_HitBox
@onready var game = $".."
@onready var hit_box = $HitBox

const SPEED = 200
const FRICTION = 4
const PARRY_AMOUNT = 120

var sword_speed = GlobalVariables.current_level * 0.2 + 1
var animation_speed = 1
#var sword_speed = 3
var parry_count = 0

var dead = false
var parry_in_progress = false
var sword_hit = false
var hit_detected = false
# Remove?
var attacking = false
var parry_force = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# I should convert the hitbox toggling sword over to the same method used by the normal hitbox
	sword.monitorable = false
	sword.monitoring = false
	sword.visible = false
	hit_box.disabled = false
	animated_sprite.speed_scale = sword_speed

func _physics_process(delta):
	if(parry_force > 0):
		transform = transform.translated(Vector2.RIGHT * delta * parry_force)
		parry_force -= FRICTION
	else:
		parry_force = 0
		if(parry_count > 0 and parry_in_progress):
			reset(false)
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
	hit_box.disabled = !hit_box.disabled
	
func handleHit(_opponent, is_sword):
	if !hit_detected:
		if !is_sword:
			# RIP :(
			dead = true
			animated_sprite.speed_scale = animation_speed
			animated_sprite.play("death")
		attacking = false
		hit_detected = true

func parry():
	hit_detected = false
	parry_count += 1
	parry_in_progress = true
	parry_force = PARRY_AMOUNT

func attack():
	await get_tree().create_timer(1.0/GlobalVariables.current_level).timeout
	attacking = true
	if !game.round_over:
			animated_sprite.speed_scale = sword_speed
			animated_sprite.play("attack")
			
func reset(with_position):
	if(with_position):
		position = Vector2(50, 1)
	else:
		attack()
	dead = false
	parry_in_progress = false
	sword_hit = false
	hit_detected = false
	attacking = false
	sword_speed = GlobalVariables.current_level * 0.2 + 1
	animated_sprite.speed_scale = animation_speed
	animated_sprite.play("idle")
	_ready()
