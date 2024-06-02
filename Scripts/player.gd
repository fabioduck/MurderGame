extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $Sword_HitBox
@onready var game = $".."
@onready var hit_vfx = $Hit_VFX
@onready var hit_vfx_head = $Hit_VFX_Head
@onready var hit_sfx = $Hit_SFX
@onready var hit_box = $HitBox
@onready var enemy = $"../Enemy"
@onready var parry_sfx = $Parry_SFX



const SPEED = 200
const FRICTION = 4
const MIN_X = -80
const FALL_SPEED = 120

var PARRY_AMOUNT = 100


var modified_speed = SPEED
var sword_speed = 3
var animation_speed = 1
var parry_count = 0
var distance_moved = 0

var dead = false
var falling = false
var parry_in_progress = false
var sword_hit = false
var hit_detected = false
# Remove?
var attacking = false
var parry_force = 0
var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	# I should convert the hitbox toggling sword over to the same method used by the normal hitbox
	sword.monitorable = false
	sword.monitoring = false
	sword.visible = false
	hit_box.disabled = false
	animated_sprite.speed_scale = 1.5
	start_position = position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("attack") and !parry_in_progress and !attacking and !dead:
		if !game.round_over:
			attacking = true
			modified_speed = SPEED
			PARRY_AMOUNT = 120
			animated_sprite.speed_scale = sword_speed
			animated_sprite.play("attack")
	if Input.is_action_just_pressed("heavy_attack") and !parry_in_progress and !attacking and !dead:
		if !game.round_over:
			attacking = true
			modified_speed = SPEED * 0
			PARRY_AMOUNT = 0
			animated_sprite.speed_scale = sword_speed * 1.5
			animated_sprite.play("attack")
			await get_tree().create_timer(0.7).timeout
			reset(false)
func _physics_process(delta):
	if(PARRY_AMOUNT == 0):
		# After blocking, set distance moved with a random offset
		distance_moved = enemy.distance_moved + randi_range(-20, 20)
		if distance_moved > 80:
			distance_moved = 80
	else:
		distance_moved = position.x - start_position
	if falling:
		transform = transform.translated(Vector2.DOWN * delta * FALL_SPEED)
	if position.x < MIN_X and !dead:
		falling = true
		dead = true
		animated_sprite.speed_scale = animation_speed
		animated_sprite.play("death")
	if(parry_force > 0):
		transform = transform.translated(Vector2.LEFT * delta * parry_force)
		parry_force -= FRICTION
	else:
		parry_force = 0
		if(parry_count > 0 and parry_in_progress):
			reset(false)
	if attacking and !hit_detected:
		transform = transform.translated(Vector2.RIGHT * delta * modified_speed)
	if animated_sprite.frame > 3 and animated_sprite.animation == "attack":
		sword.monitorable = true
		sword.monitoring = true
		sword.visible = true
		hit_box.disabled = true
	else:
		sword.monitorable = false
		sword.monitoring = false
		sword.visible = false
		hit_box.disabled = false

func _on_area_entered(area):
	handleHit(area, false)

func _on_sword_hit_box_area_entered(area):
	sword_hit = true
	handleHit(area, true)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "death":
		pass
	
func toggleSword():
	sword.monitorable = !sword.monitorable
	sword.monitoring = !sword.monitoring
	sword.visible = !sword.visible
	hit_box.disabled = !hit_box.disabled
	print("Hitbox disabled: %s" % hit_box.disabled)
	
func handleHit(_opponent, is_sword):
	if !hit_detected:
		if !is_sword:
			# RIP :(
			dead = true
			animated_sprite.speed_scale = animation_speed
			animated_sprite.play("death")
			hit_vfx_head.play()
			hit_sfx.play()
		else:
			hit_vfx.play()
		attacking = false
		hit_detected = true

func parry():
	parry_sfx.pitch_scale = randi_range(2,3)
	parry_sfx.play()
	parry_count += 1
	hit_detected = false
	parry_in_progress = true
	if(PARRY_AMOUNT != 0):
		var difference_in_distance = abs(distance_moved - enemy.distance_moved)
		if difference_in_distance < 10:
			difference_in_distance = 10
		print("P Distance: %s" % distance_moved)
		print("E Distance %s" % enemy.distance_moved)
		print("P Pushback: %s" % (enemy.distance_moved * 2))
		parry_force = (enemy.distance_moved * 2)
		if parry_force < 40:
			parry_force = 40
	else:
		parry_force = 80
		
func reset(with_position):
	if(with_position):
		position = Vector2(-50, 1)
	dead = false
	parry_in_progress = false
	sword_hit = false
	falling = false
	hit_detected = false
	attacking = false
	animated_sprite.speed_scale = animation_speed
	animated_sprite.play("idle")
	_ready()
	
