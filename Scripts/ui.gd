extends Control
@onready var play_button = $UiBackground/Play_Button
@onready var settings_button = $UiBackground/Settings_Button
@onready var back_button = $Settings_Background/Back_Button
@onready var game = $".."
@onready var music = $"../Music"
@onready var music_slider = $"Settings_Background/Music Slider"
@onready var sound_slider = $"Settings_Background/Sound Slider"
@onready var ui_background = $UiBackground
@onready var settings_background = $Settings_Background

# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider.value = music.volume_db
	sound_slider.value = game.sfx_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(music_slider.value == -20):
		music.volume_db = -80
	if(sound_slider.value == -20):
		game.sfx_volume = -80
		
	if play_button.clicked:
		game.paused = false
	elif settings_button.clicked:
		ui_background.visible = false
		settings_background.visible = true
	if back_button.clicked:
		ui_background.visible = true
		settings_background.visible = false
	if ui_background.visible:
		back_button.reset()
	else:
		play_button.reset()
		settings_button.reset()
	if !visible:
		ui_background.visible = true
		settings_background.visible = false
		play_button.reset()
		settings_button.reset()
		back_button.reset()


func _on_music_slider_value_changed(value):
	music.volume_db = value


func _on_sound_slider_value_changed(value):
	game.sfx_volume = value
