extends Control

# Start Game button pressed -- TOOD: Change to load a save file once implemented
func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/World1.tscn")
