extends "res://scripts/terminals/grids/GRID.gd"

export var next_tut = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ButtonCommit_pressed():
	if testing == false:
		var sources = get_tree().get_nodes_in_group("source")
		var chain_key = 0
		for source in sources:
			source.record_signal_chain([], chain_key)
			chain_key = parent.signal_chains.size()
		## use signal(s)(?) to send string for next GRID_tut to load?
		parent.my_grid = next_tut
		parent.open_terminal()
		
		queue_free()
		## hide()
	else:
		get_tree().call_group("source", "record_signal_chain", 0)
