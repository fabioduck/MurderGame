extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_wait_time(randf_range(1.2, 3))
	
func reset():
	_ready()
	start()
