extends Node2D

@onready var paper = $Paper
@onready var paw = $Paw
@onready var button = $Button

var clicked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_mouse_entered():
	if !paper.is_playing():
		paper.frame = 1
		paw.frame = 1


func _on_button_mouse_exited():
	if !paper.is_playing():
		paper.frame = 0
		paw.frame = 0
		
func reset():
	paper.frame = 0
	paw.frame = 0
	clicked = false


func _on_button_button_down():
	paper.play()
	paw.play()

func _on_paper_animation_finished():
	clicked = true
