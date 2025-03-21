extends Control
##
## PlayerGui
##
## All in-game gui elements for a player
##


@onready var hp_progress_bar = $"PlayerMainData/HealthBar PanelContainer/MarginContainer/TextureProgressBar"
@onready var curr_hp_label = $"PlayerMainData/HealthBar PanelContainer/MarginContainer/TextureProgressBar/MarginContainer/Label"
@onready var credit_count_label = $"CreditsAndCubes/MarginContainer/VBoxContainer/Credits HBoxContainer/MarginContainer/CreditCount Label"
@onready var cube_count_label = $"CreditsAndCubes/MarginContainer/VBoxContainer/Cubes HBoxContainer/MarginContainer/CubeCount Label"
@onready var xp_progress_bar = $"PlayerMainData/XpBar ProgressBar"
@onready var playtime_label = $"SaveData/Playtime MarginContainer/Playtime Label"
@onready var wave_number_label = $"WorldData/WaveNum MarginContainer/WaveNumber Label"
@onready var world_number_label = $"WorldData/WorldNumAndDiff MarginContainer/HBoxContainer/WorldNumber Label"
@onready var difficulty_vbox = $"WorldData/WorldNumAndDiff MarginContainer/HBoxContainer/VBoxContainer"

# TESTING: Move these into the game_data.gd file and setup general data loading
var hours = 2
var minutes = 10
var seconds: float = 0


func _ready() -> void:
	# TESTING
	setMaxHp(500.4)
	setCurrHp(60.576)
	setCredits(12430)
	setCubes(124)
	setWaveNumber(2)
	setWorldNumber(3)
	setPlaytime(hours, minutes, seconds)
	setDifficulty(Globals.Difficulty.HARD)
	# TESTING



func _process(delta: float) -> void:
	seconds += delta
	if seconds >= 60:
		seconds -= 60
		minutes += 1
	if minutes >= 60:
		minutes -= 60
		hours += 1
	
	setPlaytime(hours, minutes, seconds)


## Set new maximum value on the health bar
func setMaxHp(new_max_hp: float) -> void:
	hp_progress_bar.max_value = new_max_hp

## Set new current value on the health bar
func setCurrHp(new_curr_hp: float) -> void:
	hp_progress_bar.value = new_curr_hp
	curr_hp_label.text = str(round(new_curr_hp))

## Set the text displayed in the credit count labels
func setCredits(new_credit_count: int) -> void:
	# TODO: Shorten the number to display a suffix like "M" for a million, or "K" for a thousand, etc.
	credit_count_label.text = str(new_credit_count)


## Set the text displayed in the cube count labels
func setCubes(new_cube_count: int) -> void:
	# TODO: Shorten the number to display a suffix like "M" for a million, or "K" for a thousand, etc.
	cube_count_label.text = str(new_cube_count)


## Set the xp percent in the progress bar
func setXp(new_xp: float) -> void:
	xp_progress_bar.value = new_xp


## Set the max value of an xp bar
func setXpMax(new_xp_max: float) -> void:
	xp_progress_bar.min_value = 0.0
	xp_progress_bar.max_value = new_xp_max

## Display the current total playtime of a save file, seconds are rounded to the nearest hundreth -> (.00)
func setPlaytime(hours: int, minutes: int, seconds: float) -> void:
	playtime_label.text = str(hours) + ":" + str(minutes) + ":" + str("%02d" % int(seconds)) + ":" + str("%02d" % int((seconds - int(seconds)) * 100))


## Set the text displayed in the wave number label
func setWaveNumber(new_wave_number: int) -> void:
	# Set value at the top right of the screen
	wave_number_label.text = str(new_wave_number)


## Set the text dispalyed in the world number label
func setWorldNumber(new_world_number: int) -> void:
	# Set value at the top left of the screen
	world_number_label.text = "World " + str(new_world_number)


## Set the number of difficulty textures displayed (Easy = 1, Normal = 2, Hard = 3, Insane = 4)
func setDifficulty(new_difficulty: Globals.Difficulty) -> void:
	# Set value at the top left of the screen
	# Names of Child Elements = "Easy" "Medium" "Hard" "Insane"
	var easy_texture_rect = difficulty_vbox.get_child(Globals.Difficulty.EASY)
	var medium_texture_rect = difficulty_vbox.get_child(Globals.Difficulty.MEDIUM)
	var hard_texture_rect = difficulty_vbox.get_child(Globals.Difficulty.HARD)
	var insane_texture_rect = difficulty_vbox.get_child(Globals.Difficulty.INSANE)
	
	# TODO: Set textures to black or something and keep visible
	# I wish GDScript match statements had fallthrough like C++
	match new_difficulty:
		Globals.Difficulty.INSANE:
			insane_texture_rect.visible = true
			hard_texture_rect.visible = true
			medium_texture_rect.visible = true
			easy_texture_rect.visible = true
		Globals.Difficulty.HARD:
			insane_texture_rect.visible = false
			hard_texture_rect.visible = true
			medium_texture_rect.visible = true
			easy_texture_rect.visible = true
		Globals.Difficulty.MEDIUM:
			insane_texture_rect.visible = false
			hard_texture_rect.visible = false
			medium_texture_rect.visible = true
			easy_texture_rect.visible = true
		Globals.Difficulty.EASY:
			insane_texture_rect.visible = false
			hard_texture_rect.visible = false
			medium_texture_rect.visible = false
			easy_texture_rect.visible = true
