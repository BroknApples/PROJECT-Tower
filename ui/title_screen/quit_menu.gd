extends PanelContainer
##
## QuitMenu UI
##
## "Are you sure you want to quit?" Menu popup
##

## If the user presses yes, quit the program
func _on_yes_pressed() -> void:
	Globals.quitGame()


## If the user presses no, then close the quit menu
func _on_no_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	$".".visible = false


## Close the quit menu when 'esc' is pressed
func _input(event: InputEvent):
	if Input.is_action_just_pressed("Esc"):
		$".".visible = false
