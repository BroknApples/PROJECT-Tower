extends WorldClass
##
## TestWorld : extends WorldClass
##
## World used to test feature implementation
##


func _init() -> void:
	# Initialize super class
	var enemies = {
		"res://game_objects/enemies/Square/square.tscn": 0.5,
		"res://game_objects/enemies/triangle/triangle.tscn": 0.5
	}
	var s_rate = 100
	super._init("TestWorld", s_rate, enemies)
