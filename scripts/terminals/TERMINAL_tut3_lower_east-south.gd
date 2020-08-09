extends "res://scripts/terminals/TERMINAL.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	terminal_contents = [
		## row 1
		[],
		[],
		[],
		## row 2
		[], 
		["res://scenes/Components/NOUN_door.tscn", 0, 6, true],
		[], 
		## row 3
		[], 
		[],
		[], 
	]
