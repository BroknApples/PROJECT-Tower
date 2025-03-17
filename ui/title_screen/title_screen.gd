extends Control
##
## TitleScreen UI
##
## Screen that appears when you first launch the game or exit your save file
##


@onready var quit_menu = $"QuitMenu PanelContainer"
@onready var save_select_menu = $"SaveSelectMenu PanelContainer"
var audio_manager = preload("res://misc/AudioManager.tscn")
var settings_menu = preload("res://ui/settings/settings.tscn")

# TESTING
func _ready() -> void:
	# Setup Audio Manager -- Add to root tree
	audio_manager = audio_manager.instantiate()
	get_tree().get_root().add_child.call_deferred(audio_manager)
	
	# Setup Settings Menu -- Add to root tree
	settings_menu = settings_menu.instantiate()
	get_tree().get_root().add_child.call_deferred(settings_menu)
	
	# TESTING
	var window = get_viewport().get_window()
	var test_size = Vector2i(1280, 720)
	window.size = test_size
	window.position = test_size/4
	# TESTING
	pass


## If the user presses play, display the SaveSelect UI
func _on_play_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	save_select_menu.visible = true


## If the user presses settings, display the Settings UI
func _on_settings_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	settings_menu.open()


## If the user presses quit, display the QuitMenu UI
func _on_quit_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	quit_menu.visible = true
