extends "res://scripts/terminals/grids/GRID.gd"

export var next_tut = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ButtonCommit_pressed():
	if testing == false:
		##var sources = get_tree().get_nodes_in_group("source")
		## var chain_key = 0
		## for source in sources:
		## 	source.record_signal_chain([], chain_key)
		## 	chain_key = parent.signal_chains.size()
		
		parent.my_grid = next_tut
		parent.open_terminal()
		
		var verbs = get_tree().get_nodes_in_group("verb")
		for verb in verbs:
			if verb.lit == true:
				verb.trace_signal()
		queue_free()
		
		queue_free()
		## hide()
	else:
		## get_tree().call_group("source", "record_signal_chain", 0)
		var verbs = get_tree().get_nodes_in_group("verb")
		for verb in verbs:
			if verb.lit == true:
				verb.trace_signal()
		queue_free()
