extends PanelContainer
##
## QuitMenu UI
##
## "Are you sure you want to quit?" Menu popup
##

## If the user presses yes, quit the program
func _on_yes_pressed() -> void:
	get_tree().quit()


## If the user presses no, then close the quit menu
func _on_no_pressed() -> void:
	$".".visible = false


## Close the quit menu when 'esc' is pressed
func _input(event):
	if Input.is_action_just_pressed("Esc"):
		$".".visible = false
