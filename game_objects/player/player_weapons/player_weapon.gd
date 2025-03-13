extends WeaponClass
##
## PlayerWeapon Class
##
## Modified version of the Weapon Class that fits a player_weapon's needs
##
class_name PlayerWeapon


const _DEFAULT_ATTACK_POS = Vector2(100, 100)
var cursor_shape: CompressedTexture2D
var cursor_hotspot: Vector2
var attack_pos_locked: bool
var canvas_layer: CanvasLayer
var attack_locked_texture_rect: TextureRect ## Draw this item only when attack position is locked
var attack_pos: Vector2

func _init(init_cursor_shape: CompressedTexture2D, init_weapon_name: String, init_audio: WeaponAudio, init_weapon_stats: WeaponStats) -> void:
	super._init(init_weapon_name, init_audio, init_weapon_stats)
	
	cursor_shape = init_cursor_shape
	cursor_hotspot = cursor_shape.get_size() / 2
	attack_pos = Vector2(0, 0)
	attack_pos_locked = false
	
	setWeaponCursor()


func _ready() -> void:
	super._ready()
	
	#
	# Setup attack lock texture rect
	# Uses a canvas layer
	#
	
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	attack_locked_texture_rect = TextureRect.new()
	attack_locked_texture_rect.texture = cursor_shape
	attack_locked_texture_rect.visible = false # Set to invisible until used
	
	canvas_layer.add_child(attack_locked_texture_rect)


func _input(event):
	if Input.is_action_just_pressed("AttackLock"):
		lockAttackPosition()


# Child classes should NOT overwrite this process function
func _process(delta: float) -> void:
	if (!attack_pos_locked):
		attack_pos = Globals.getMousePosition()
	super._process(delta)
	# TODO: For player weapons, i need to make a custom fire mode(on at least some of them)
	# Right now, it always fires in intervals, but if it can fire, it needs to check if there is something to shoot, every so many frames
	# otherwise it feels like something is off when using the weapon


## Virtual Method -- Can be overwritten
## Find default attack position for a player_weapon
func findAttackPosition() -> Vector2:
	return attack_pos


func lockAttackPosition() -> void:
	# TODO: Need to change cursor back to default when locked and place an icon in the screen to show where it is locked to
	if (!attack_pos_locked):
		attack_pos_locked = true
		Globals.setCursorShape(null) # Sets it back to default
		attack_locked_texture_rect.visible = true
		attack_locked_texture_rect.position = attack_pos - (attack_locked_texture_rect.size / 2)
		print("Locked PlayerWeapon '" + weapon_name + "' to position: (" + str(attack_pos.x) + ", " + str(attack_pos.y) + ")")
	else:
		attack_pos_locked = false
		setWeaponCursor()
		attack_locked_texture_rect.visible = false
		print("Unlocked PlayerWeapon '" + weapon_name + "'")


func setWeaponCursor() -> void:
	Globals.setCursorShape(cursor_shape, Input.CURSOR_ARROW, cursor_hotspot) # set a bool to centered
