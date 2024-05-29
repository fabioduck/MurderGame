extends Node2D
@onready var player = $Player
@onready var enemy = $Enemy
@onready var timer_text = $Timer_Text
@onready var level_text = $Level_Text
@onready var round_text = $Round_Text
@onready var start_vfx = $Start_VFX
@onready var start_delay = $Start_Delay

var running = false
var round_over = false
var resetting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_text.clear()
	level_text.add_text("Level: %d" % GlobalVariables.current_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(running and !round_over):
		round_text.clear()
		if enemy.dead and !player.dead:
			round_over = true
			round_text.add_text("You win!")
			GlobalVariables.current_level += 1
			running = false
		elif player.dead:
			round_over = true
			round_text.add_text("You lose!")
			GlobalVariables.current_level = 1
			running = false
		elif player.hit_detected and !player.dead and !enemy.dead:
			round_over = true
			round_text.add_text("Tie!")
			running = false
		timer_text.running = running
	elif player.attacking and !running and !round_over:
		round_over = true
		round_text.clear()
		round_text.add_text("Cheater")
		GlobalVariables.current_level = 1
	if round_over and !resetting:
		await get_tree().create_timer(0.6).timeout
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
	enemy.reset()
	player.reset()
	start_delay.start()
	level_text.clear()
	level_text.add_text("Level: %d" % GlobalVariables.current_level)
	resetting = false
