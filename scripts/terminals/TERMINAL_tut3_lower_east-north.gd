extends "res://scripts/terminals/TERMINAL.gd"

func _ready():
	terminal_contents = [
		## row 1
		[],
		["res://scenes/Components/VERB_activate.tscn", 3, 0, false],
		[],
		## row 2
		["res://scenes/Components/MODIFIER_this.tscn", 3, 5, false], 
		["res://scenes/Components/SOURCE.tscn", 1, 2, false],
		[], 
		## row 3
		["res://scenes/Components/NOUN_terminal.tscn", 0, 5, false], 
		["res://scenes/Components/VERB_destroy.tscn", 1, 0, false],
		[], 
	]
