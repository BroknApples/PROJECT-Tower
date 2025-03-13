extends Control
##
## Augment Selection Screen
##
## UI interface to choose an augment
##


@onready var augment1_button = $VBoxContainer/HBoxContainer/Augment1/Button
@onready var augment2_button = $VBoxContainer/HBoxContainer/Augment2/Button
@onready var augment3_button = $VBoxContainer/HBoxContainer/Augment3/Button
signal toggled(augment: Augment)
var selected_aug: Augment


@onready var augments_hbox = $VBoxContainer/HBoxContainer
var player: Player ## What player is selecting an augment
var augments: Array[Augment]


func initialize(init_player: Player, init_augments: Array[Augment]) -> void:
	player = init_player
	augments = init_augments


func _ready() -> void:
	# Setup Buttons
	#augment1_button.toggled.connect(_on_augment_button_pressed, augments[0])
	#augment2_button.toggled.connect(_on_augment_button_pressed, augments[1])
	#augment3_button.toggled.connect(_on_augment_button_pressed, augments[2])
	
	# Setup augments
	#var i := 0
	#for child in augments_hbox.get_children():
		#child = augments[i]
		#i += 1
	pass


## Select Augment1
func _on_augment_button_pressed(pressed: bool, augment: Augment) -> void:
	if pressed:
		selected_aug = augment
		print("Selected Augment: ", selected_aug.name)
		toggled.emit(augment)


func _on_confirm_selection_button_pressed() -> void:
	pass # Replace with function body.
