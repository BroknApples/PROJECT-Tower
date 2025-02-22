extends Control

@onready var quit_menu = $"QuitMenu PanelContainer"
@onready var save_select_menu = $"SaveSelectMenu PanelContainer"

func _on_play_pressed() -> void:
	save_select_menu.visible = true


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings/settings.tscn")


func _on_quit_pressed() -> void:
	quit_menu.visible = true
