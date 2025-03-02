extends WorldClass
##
## TestWorld : extends WorldClass
##
## World used to test feature implementation
##


func _init() -> void:
	# Initialize super class
	var enemies = {
		"res://game_objects/enemies/Square/square.tscn": 0.8,
		"res://game_objects/enemies/triangle/triangle.tscn": 0.2
	}
	var s_rate = 760
	super._init("TestWorld", s_rate, enemies)
