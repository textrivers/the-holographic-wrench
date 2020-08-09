extends "res://scripts/terminals/TERMINAL.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	terminal_contents = [
		## row 1
		["res://scenes/Components/SOURCE.tscn", 3, 0, false],
		["res://scenes/Components/MODIFIER_nearest.tscn", 1, 2, false],
		["res://scenes/Components/NOUN_light.tscn", 1, 2, false],
		["res://scenes/Components/VERB_activate.tscn", 1, 0, true],
		## row 2
		[], 
		[],
		[], 
		[], 
		## row 3
		[], 
		[],
		[], 
		[], 
		## row 4
		[],
		["res://scenes/Components/NOUN_terminal.tscn", 1, 2, true], 
		[],
		[],
	]
