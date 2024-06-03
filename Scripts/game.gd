extends Node2D
@onready var player = $Player
@onready var enemy = $Enemy
@onready var timer_text = $Sign
@onready var level_text = $Level_Text
@onready var round_text = $Round_Text
@onready var start_vfx = $Start_VFX
@onready var start_delay = $Start_Delay
@onready var music = $Music
@onready var camera = $Camera2D
@onready var canvas_layer = $CanvasLayer
@onready var panic = $panic
@onready var ui = $UI

var sfx_volume = -6

var running = false
var round_over = false
var resetting = false
var music_muted = false
var parry = false
var paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	show_round_text()
	set_highscore()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	start_vfx.volume_db = sfx_volume
	if Input.is_action_just_pressed("pause"):
		paused = !paused
	if (!paused):
		ui.visible = false
		if start_delay.is_stopped() and !running:
			start_delay.start()
		start_delay.paused = false
	else:
		ui.visible = true
		start_delay.paused = true
			
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
			if GlobalVariables.current_level == 1:
				round_text.add_text("You had\n%s hat :(" % (GlobalVariables.current_level))
			else:
				round_text.add_text("You had\n%s hats" % (GlobalVariables.current_level))
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
		resetting = true
		await get_tree().create_timer(1.5).timeout
		reload()
	
func _on_start_delay_timeout():
	if !round_over:
		start_vfx.play()
		panic.play()
		timer_text.running = true
		enemy.attack()
		running = true
		timer_text.start_time = Time.get_ticks_msec()
		await get_tree().create_timer(0.6).timeout
		panic.stop()

func reload():
	print("Game reset initiated")
	round_over = false
	running = false
	show_round_text()
	timer_text.reset()
	start_delay.reset()
	enemy.reset(true)
	player.reset(true)
	start_delay.start()
	set_highscore()
	resetting = false
	
func set_highscore():
	if GlobalVariables.current_level > GlobalVariables.highscore:
		GlobalVariables.highscore += 1
	level_text.clear()
	level_text.add_text("Hat Score: %d" % GlobalVariables.highscore)
	
func show_round_text():
	round_text.clear()
	round_text.push_color(Color(0.7, 0.6, 0.5))
	round_text.add_text("Level: %d" % GlobalVariables.current_level)
	await get_tree().create_timer(1).timeout
	round_text.clear()
