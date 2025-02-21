extends Control


@onready var input_button_scene = preload("res://ui/settings/input_button.tscn");
@onready var action_list = $"PanelContainer/MarginContainer/Input Settings VBox/ScrollContainer/Action List";


var is_remapping = false;
var action_to_remap = null;
var remapped_key = null;

# What actions should be remappable
var input_actions = {
	"input_map_name": "your_display_name"	
};

func _ready():
	_create_action_list();
	
func _create_action_list():
	InputMap.load_from_project_settings();
	var label_button = action_list.find_child("Label Button");
	for item in action_list.get_children():
		if (item == label_button): continue;
		
		item.queue_free();
		
	for action in input_actions:
		var button = input_button_scene.instantiate();
		var action_label = button.find_child("Action Label");
		var key_label = button.find_child("Key Label");
		
		action_label.text = input_actions[action];
		
		var events = InputMap.action_get_events(action);
		if events.size() > 0:
			key_label.text = events[0].as_text().trim_suffix(" (Physical)");
		else:
			key_label.text = "";
	
		action_list.add_child(button);
