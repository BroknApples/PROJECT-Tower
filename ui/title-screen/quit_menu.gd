extends PanelContainer

func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	$".".visible = false

func _input(event):
	if Input.is_action_just_pressed("Esc"):
		$".".visible = false
