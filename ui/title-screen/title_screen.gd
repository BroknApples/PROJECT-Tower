extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/mode-select/choose-save.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
