extends Control
##
## AugmentCard Class
##
## Creates an object on the screen in the shape of a card, 
## See end of file for format of creating new augment
##
class_name Augment

@onready var _title_label = $"PanelContainer/MarginContainer2/VBoxContainer/Title Label"
@onready var _description_label = $"PanelContainer/MarginContainer2/VBoxContainer/Description Label"
@onready var _stats_label = $"PanelContainer/MarginContainer2/VBoxContainer/Stats Label"
@onready var _rarity_label = $"PanelContainer/MarginContainer/Control/Rarity Label"
@onready var _panel_container = $PanelContainer
const AugmentEssentials = preload("res://gameplay/augments/augment_essentials.gd")

var augment_name: String ## What is this augment called
var description: String ## Describes the augment's purpose in text
var stats: Array[Globals.Pair] ## What is given by this augment -- Format = [Pair.first = StatType, Pair.second = value]
# var ability_type: AbilityType TODO: Add ability Type and implement augments that give them
var icon: Texture2D
var rarity: AugmentEssentials.Rarity ## How common is this augment
var classifiers: Array[AugmentEssentials.Classifier] ## What type of objects can this augment be applied to


func _init() -> void:
	augment_name = "Blank Augment"
	description = "Placeholder augment used as the base of all augment classes."
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 100),
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 100),
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 100),
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 100)
	]


func _ready() -> void:
	# Set text data
	var words = augment_name.split(" ", false)
	words.remove_at(0)
	_title_label.text = " ".join(words)
	
	_description_label.text = description
	_stats_label.text = _statsToLabel()
	_rarity_label.text = AugmentEssentials.new().rarityToString(rarity).to_upper()
	
	# Set styles based on rarity
	var rarity_color = AugmentEssentials.new().rarityToColor(rarity)
	var panel_stylebox = load("res://assets/styles/augment_style_panel_container.tres").duplicate(true)
	panel_stylebox.border_color = rarity_color
	_panel_container.add_theme_stylebox_override("panel", panel_stylebox)
	_rarity_label.add_theme_color_override("font_color", rarity_color)


## Copy data from another augment to another
## Specifically used to display augment data using it's scene
func copy(augment: Augment) -> void:
	self.augment_name = augment.augment_name
	self.description = augment.description
	self.stats = augment.stats
	
	self.icon = augment.icon
	self.rarity = augment.rarity
	self.classifiers = augment.classifiers


func _statsToLabel() -> String:
	var label := ""
	for pair in stats:
		var type: AugmentEssentials.StatType = pair.first
		var value = pair.second
		
		if (value < 0):
			label += "-" + str(value)
		elif (value > 0):
			label += "+"  + str(value)
		
		# If its a percent earn rate value, add a % sign
		if (type == AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT || 
			type == AugmentEssentials.StatType.PLAYER_CUBES_PERCENT ||
			type == AugmentEssentials.StatType.PLAYER_XP_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_BASE_MAX_HP_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_BASE_ARMOR_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_BASE_HP_REGEN_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_MAX_HP_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_ARMOR_PERCENT ||
			type == AugmentEssentials.StatType.TOWER_HP_REGEN_PERCENT):
				label += "%"
		
		label += " " + AugmentEssentials.new().statTypeToString(type)
		label += "\n"
	
	return label


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendaryRarity() -> bool:
	rarity = AugmentEssentials.Rarity.LEGENDARY
	augment_name = AugmentEssentials.new().rarityToString(rarity) + " " + augment_name
	
	return false


## Set the augment to a epic rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEpicRarity() -> bool:
	rarity = AugmentEssentials.Rarity.EPIC
	augment_name = AugmentEssentials.new().rarityToString(rarity) + " " + augment_name
	
	return false


## Set the augment to a rare rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setRareRarity() -> bool:
	rarity = AugmentEssentials.Rarity.RARE
	augment_name = AugmentEssentials.new().rarityToString(rarity) + " " + augment_name
	
	return false


## Set the augment to an uncommon rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setUncommonRarity() -> bool:
	rarity = AugmentEssentials.Rarity.UNCOMMON
	augment_name = AugmentEssentials.new().rarityToString(rarity) + " " + augment_name
	
	return false


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setCommonRarity() -> bool:
	rarity = AugmentEssentials.Rarity.COMMON
	augment_name = AugmentEssentials.new().rarityToString(rarity) + " " + augment_name
	
	return false






##
## Creating a new augment
##
## Create new .gd file in augment_list directory
## Copy and paste code snippet below and remove comments using 'ctrl + /'
##

#extends Augment
#
#
#func _init() -> void:
	#augment_name = "Credits"
	#description = "Instantly obtain credits"
	#icon = PlaceholderTexture2D.new() # TODO: Add texture
	#classifiers = [AugmentEssentials.Classifier.PLAYER]
#
#
### Set the augment to a legendary rarity
### returns: True if the rarity exists, False if the rarity does not exist
#func setLegendaryRarity() -> bool:
	#super.setLegendaryRarity()
	#
	## Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	#stats = [
		
	#]
	#
	#return true
#
#
### Set the augment to a epic rarity
### returns: True if the rarity exists, False if the rarity does not exist
#func setEpicRarity() -> bool:
	#super.setEpicRarity()
	#
	## Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	#stats = [
		
	#]
	#
	#return true
#
#
### Set the augment to a rare rarity
### returns: True if the rarity exists, False if the rarity does not exist
#func setRareRarity() -> bool:
	#super.setRareRarity()
	#
	## Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	#stats = [
		
	#]
	#
	#return true
#
#
### Set the augment to an uncommon rarity
### returns: True if the rarity exists, False if the rarity does not exist
#func setUncommonRarity() -> bool:
	#super.setUncommonRarity()
	#
	## Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	#stats = [
		
	#]
	#
	#return true
#
#
### Set the augment to a common rarity
### returns: True if the rarity exists, False if the rarity does not exist
#func setCommonRarity() -> bool:
	#super.setCommonRarity()
	#
	## Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	#stats = [
		
	#]
	#
	#return true
