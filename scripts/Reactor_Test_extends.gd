extends "res://scripts/LVL_basics.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	## use this space in extending scripts to specify:
	instance_pos_dict = {
		1: Vector3(-27, 1.667, -4.5),
		2: Vector3(-27, 1.667, -1.5),
		3: Vector3(-27, 1.667, 2.5),
		4: Vector3(-27, 1.667, 5.5)
	}
	instance_rot_mod = -90
	items_max = 12
	
	while instance_counter < 5:
		add_players()
	
	populate_boxes()
