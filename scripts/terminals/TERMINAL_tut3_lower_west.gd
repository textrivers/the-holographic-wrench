extends "res://scripts/terminals/TERMINAL.gd"

func _ready():
	terminal_contents = [
		## row 1
		["res://scenes/Components/SOURCE.tscn", 3, 1, false],
		["res://scenes/Components/MODIFIER_farthest.tscn", 3, 3, false],
		[],
		["res://scenes/Components/VERB_deactivate.tscn", 1, 0, true],
		## row 2
		[], 
		[],
		["res://scenes/Components/SOURCE.tscn", 2, 0, false], 
		["res://scenes/Components/SOURCE.tscn", 2, 0, false], 
		## row 3
		[], 
		["res://scenes/Components/VERB_deactivate.tscn", 0, 0, true],
		["res://scenes/Components/SOURCE.tscn", 2, 0, false], 
		["res://scenes/Components/MODIFIER_nearest.tscn", 1, 5, true], 
		## row 4
		["res://scenes/Components/VERB_activate.tscn", 0, 0, false],
		["res://scenes/Components/SOURCE.tscn", 2, 0, false], 
		["res://scenes/Components/SOURCE.tscn", 2, 0, false],
		["res://scenes/Components/NOUN_terminal.tscn", 1, 5, true],
	]
