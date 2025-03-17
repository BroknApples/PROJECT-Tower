extends PanelContainer
##
## SaveSelectMenu UI
##
## Prompts user to select a previous save or create a new one
##


@onready var selected_save_label = $"HBoxContainer/SaveDescription MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/SelectedSave Label"
const DEFAULT_SELECTED_SAVE_LABEL_TEXT = "None"
var selected_save

## Create a game data node and load data from a save file
func _on_start_game_button_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	
	# TODO: Implement save files
	var save_id = 1
	var game_scene = load("res://gameplay/game_data.tscn").instantiate();
	game_scene.save_id = save_id
	
	get_tree().get_root().add_child(game_scene)
	if (!game_scene.game_loaded):
		# TODO: Once save files are implemented, change print() to display the selected save
		print("ERROR: Could not load save file.")
		get_tree().get_root().remove_child(game_scene)
	else:
		get_tree().get_root().remove_child($"..")

## Close the Save select menu when 'esc' is pressed
func _input(event: InputEvent):
	if Input.is_action_just_pressed("Esc"):
		$".".visible = false
