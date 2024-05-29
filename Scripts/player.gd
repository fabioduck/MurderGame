extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $Sword_HitBox
@onready var game = $".."
@onready var hit_vfx = $Hit_VFX
@onready var hit_vfx_head = $Hit_VFX_Head
@onready var hit_sfx = $Hit_SFX


const SPEED = 300
var sword_speed = 1.5

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	await get_tree().create_timer(0.1).timeout
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
			hit_vfx_head.play()
		else:
			hit_vfx.play()
		hit_sfx.play()
		attacking = false
		hit_detected = true
		
func reset():
	position = Vector2(-50, 0)
	dead = false
	sword_hit = false
	hit_detected = false
	attacking = false
	animated_sprite.play("idle")
	_ready()
	
