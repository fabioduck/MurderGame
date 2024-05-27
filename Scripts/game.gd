extends Node2D
@onready var player = $Player
@onready var enemy = $Enemy
@onready var timer_text = $Timer_Text
@onready var level_text = $Level_Text
@onready var round_text = $Round_Text

var running = false
var round_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_text.clear()
	level_text.add_text("Level: %d" % GlobalVariables.current_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(running and !round_over):
		round_text.clear()
		if player.attacking and enemy.attacking:
			round_over = true
			round_text.add_text("Tie")
			running = false
		elif player.attacking:
			round_over = true
			round_text.add_text("You win!")
			GlobalVariables.current_level += 1
			running = false
		elif enemy.attacking:
			round_over = true
			round_text.add_text("You lose!")
			GlobalVariables.current_level = 1
			running = false
		timer_text.running = running
	elif player.attacking and !running and !round_over:
		round_over = true
		round_text.clear()
		round_text.add_text("You lose!")
		GlobalVariables.current_level = 1
		
	if round_over:
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
	
func _on_start_delay_timeout():
	if !round_over:
		timer_text.running = true
		running = true
		timer_text.start_time = Time.get_ticks_msec()
