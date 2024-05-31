extends Node2D
@onready var player = $Player
@onready var enemy = $Enemy
@onready var timer_text = $Timer_Text
@onready var level_text = $Level_Text
@onready var round_text = $Round_Text
@onready var start_vfx = $Start_VFX
@onready var start_delay = $Start_Delay
@onready var music = $Music
@onready var camera = $Camera2D
@onready var canvas_layer = $CanvasLayer


var running = false
var round_over = false
var resetting = false
var music_muted = false
var parry = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_text.clear()
	level_text.add_text("Level: %d" % GlobalVariables.current_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Press mute input to toggle music
	if Input.is_action_just_pressed("mute"):
		if !music_muted:
			music_muted = true
			music.stop()
		else:
			music_muted = false
			music.play()
	# Press shader input to toggle scan lines
	if Input.is_action_just_pressed("shader"):
		canvas_layer.visible = !canvas_layer.visible
		# The scan lines shader zooms in the screen a bit so we scale the camera zoom accordingly
		if(canvas_layer.visible):
			camera.zoom = Vector2(3.79, 3.79)
		else:
			camera.zoom = Vector2(4.17, 4.17)
	if(running and !round_over):
		round_text.clear()
		if enemy.dead and !player.dead:
			round_over = true
			round_text.push_color(Color(0.2, 0.75, 0.2))
			round_text.add_text("You win!")
			GlobalVariables.current_level += 1
			running = false
		elif player.dead:
			round_over = true
			round_text.push_color(Color(0.8, 0.2, 0.2))
			round_text.add_text("You Died\nLevel: %s" % GlobalVariables.current_level)
			GlobalVariables.current_level = 1
			running = false
		elif player.hit_detected and !player.dead and !enemy.dead:
			round_over = false
			parry = true
			player.parry()
			enemy.parry()
			running = true
		timer_text.running = running
	elif player.attacking and !running and !round_over:
		round_over = true
		round_text.clear()
		round_text.push_color(Color(0.8, 0.2, 0.2))
		round_text.add_text("Cheater")
		GlobalVariables.current_level = 1
	if round_over and !resetting:
		await get_tree().create_timer(0.8).timeout
		reload()
	
func _on_start_delay_timeout():
	if !round_over:
		start_vfx.play()
		timer_text.running = true
		enemy.attack()
		running = true
		timer_text.start_time = Time.get_ticks_msec()

func reload():
	resetting = true
	round_over = false
	running = false
	round_text.clear()
	timer_text.reset()
	start_delay.reset()
	enemy.reset(true)
	player.reset(true)
	start_delay.start()
	level_text.clear()
	level_text.add_text("Level: %d" % GlobalVariables.current_level)
	resetting = false
