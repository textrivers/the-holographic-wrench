extends "res://scripts/terminals/TERMINAL.gd"

func _ready():
	terminal_contents = [
		## row 1
		["res://scenes/Components/SOURCE.tscn", 3, 0, false],
		[],
		[],
		["res://scenes/Components/SOURCE.tscn", 2, 0, false],
		## row 2
		[], 
		["res://scenes/Components/VERB_activate.tscn", 1, 0, false],
		["res://scenes/Components/VERB_activate.tscn", 0, 0, false], 
		[], 
		## row 3
		[], 
		["res://scenes/Components/VERB_activate.tscn", 2, 0, false],
		["res://scenes/Components/VERB_activate.tscn", 3, 0, false], 
		[], 
		## row 4
		["res://scenes/Components/SOURCE.tscn", 0, 0, false],
		[], 
		[],
		["res://scenes/Components/SOURCE.tscn", 1, 0, false],
	]
