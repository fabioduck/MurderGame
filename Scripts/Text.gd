extends AnimatedSprite2D
var running = false
var start_time = 0;
@onready var sign_text = $Sign_Text
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready(): 
	label.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(running):
		var time_elapsed = (Time.get_ticks_msec() - start_time) * 0.1		
		label.text = str(time_elapsed).pad_decimals(0)
func reset():
	_ready()
