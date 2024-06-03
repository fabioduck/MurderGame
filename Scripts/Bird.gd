extends AnimatedSprite2D

# Birbs
@onready var bird_0 = $Bird0
@onready var bird_1 = $Bird1
@onready var bird_2 = $Bird2
@onready var bird_3 = $Bird3

# Export variables that are nice to adjust
@export var SPEED = 50
@export var SPAWN_MIN_DELAY = 1
@export var SPAWN_MAX_DELAY = 10

# Set spawn area to scenery bounds
var MIN_HEIGHT = -50
var MAX_HEIGHT = -100

# Needed variables for logic
var dir
var waiting
var first_run = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn a random grouping of birds based on percentage
	var bird_randomizer = randi() % 100
	if bird_randomizer < 30:
		bird_0.visible = false
		bird_1.visible = false
		bird_2.visible = false
		bird_3.visible = false
	elif bird_randomizer < 50:
		bird_0.visible = false
		bird_1.visible = false
		bird_2.visible = false
		bird_3.visible = true
	elif bird_randomizer < 70:
		bird_0.visible = false
		bird_1.visible = false
		bird_2.visible = true
		bird_3.visible = false
	else:
		bird_0.visible = true
		bird_1.visible = true
		bird_2.visible = true
		bird_3.visible = true
	
	# This waiting toggle is kind of gross but _process keeps running to this prevents the birds logic from running over and over. 
	# Eventually I may look up a better solution
	waiting = false
	
	# Save previous direction and set a new random dir of 0 or 1
	var prev_dir = dir
	dir = randi() % 2
	# Using this to make sure the first run is always 0. I don't remember why but its fine
	if(first_run):
		dir = 0
		prev_dir = 0
		first_run = false
	# I'm sure there is a much more elegant way to set the birds direction but eh.. this works
	if(dir != prev_dir):
			scale.x = -scale.x
	# Spawn outside the screen at a random height within the allowed range
	if(dir==0):
		position = Vector2(-200, randi_range(MAX_HEIGHT, MIN_HEIGHT))
	else:
		position = Vector2(200, randi_range(MAX_HEIGHT, MIN_HEIGHT))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !waiting:
		# I should really look for a Vector2.Forward instead of LEFT, RIGHT toggling but oh well
		if(dir==0):
			transform = transform.translated(Vector2.RIGHT * delta * SPEED)
		else:
			transform = transform.translated(Vector2.LEFT * delta * SPEED)
		# If outside of spawn area, restart!
		if position.x > 210 || position.x < -210:
			waiting = true
			# Wait for spawn delay
			await get_tree().create_timer(randi_range(SPAWN_MIN_DELAY, SPAWN_MAX_DELAY)).timeout
			_ready()
