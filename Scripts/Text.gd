extends RichTextLabel
var running = false
var start_time = 0;

# Called when the node enters the scene tree for the first time.
func _ready(): 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(running):
		clear()
		var time_elapsed = (Time.get_ticks_msec() - start_time) * 0.1
		add_text(str(time_elapsed).pad_decimals(0))
