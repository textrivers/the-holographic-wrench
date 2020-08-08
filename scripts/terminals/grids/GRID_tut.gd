extends "res://scripts/terminals/grids/GRID.gd"

export var next_tut = ""

func _ready():
	pass

func _on_ButtonCommit_pressed():
	if testing == false:
		
		parent.my_grid = next_tut
		
		var verbs = get_tree().get_nodes_in_group("verb")
		for verb in verbs:
			if verb.lit == true:
				verb.trace_signal()
		
		if parent.parse_tutorial_path() == true:
			queue_free()
		## hide()
	else:
		## get_tree().call_group("source", "record_signal_chain", 0)
		var verbs = get_tree().get_nodes_in_group("verb")
		for verb in verbs:
			if verb.lit == true:
				verb.trace_signal()
			queue_free()


func _on_ButtonExitTut_pressed():
	record_inventory()
	if game_data.player_inventory.size() == 3:
		get_tree().change_scene("res://scenes/Tutorial3.tscn")
