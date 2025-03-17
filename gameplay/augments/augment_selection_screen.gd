extends Control
##
## Augment Selection Screen
##
## UI interface to choose an augment
##


var AugmentEssentials = load("res://gameplay/augments/augment_essentials.gd")
@onready var augments_hbox = $VBoxContainer/HBoxContainer ## HBoxContainer that holds the augments
@onready var _confirm_button = $"VBoxContainer/MarginContainer/ConfirmSelection Button"
var player: Player ## What player is selecting an augment
var augments: Array[Augment] ## List of randomly generated augments
var selected_aug: int ## Index of the selected aug


func initialize(init_player: Player, init_augments: Array[Augment]) -> void:
	player = init_player
	augments = init_augments
	selected_aug = -1


func _ready() -> void:
	# Set player to a semi-paused state
	player.setSemiPausedState(true)
	
	# Start confirm button in disabled state
	_confirm_button.disabled = true
	
	# Remove Placeholder Augments
	for child in augments_hbox.get_children():
		child.queue_free()
	
	# Add New Augments
	for i in range(augments.size()):
		var aug = augments[i] ## Augment in array
		
		var augment_scene = load("res://gameplay/augments/augment.tscn").instantiate() ## Scene instance used for selecting an augment
		augment_scene.copy(aug)
		augments_hbox.add_child(augment_scene)
		augments_hbox.move_child(augment_scene, i)
		
		# Connect Signals
		var augment_button = augment_scene.get_node("Button")
		augment_button.connect("toggled",  _on_augment_button_pressed.bind(i))


## Select an augment and deselect the others
## pressed: is the button pressed
## augment: Which augment em
func _on_augment_button_pressed(pressed: bool, index: int) -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	if pressed:
		print("Selected Augment: ", augments[index].augment_name)
		
		# Remove other augments from being in the pressed state
		if (selected_aug != -1):
			for i in range(augments_hbox.get_child_count()):
				if (i != index):
					var aug = augments_hbox.get_child(i)
					print("Deselecting Augment: ", aug.augment_name)
					aug.get_node("Button").button_pressed = false
		
		# Change selected augment index value
		selected_aug = index
		_confirm_button.disabled = false
	else:
		selected_aug = -1
		_confirm_button.disabled = true


## Add augment and delete selection screen
func _on_confirm_selection_button_pressed() -> void:
	if (selected_aug == -1): return # No augment has been selected
	
	AudioManager.playStream(AudioManager.UI_CLICK1)
	
	player.addAugment(augments[selected_aug])
	player.setSemiPausedState(false)
	self.queue_free()


## Hide augment selection screen
func _on_open_close_button_pressed() -> void:
	AudioManager.playStream(AudioManager.UI_CLICK1)
	if ($Panel.visible):
		player.setSemiPausedState(false)
	else:
		player.setSemiPausedState(true)
	
	$Panel.visible = !$Panel.visible
	$VBoxContainer.visible = !$VBoxContainer.visible
