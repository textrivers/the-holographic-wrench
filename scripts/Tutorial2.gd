extends "res://scripts/LVL_basics.gd"

func _ready():
	pass # Replace with function body.
	## use this space in extending scripts to specify:
	instance_pos_dict = {
		1: Vector3(0, 8, 4),
		2: Vector3(0, 8, 6),
		3: Vector3(0, 8, 8),
		4: Vector3(0, 8, 10)
	}
	instance_rot_mod = -90
	items_max = 5
	
	while instance_counter < 5:
		add_players()
	
	populate_boxes()
