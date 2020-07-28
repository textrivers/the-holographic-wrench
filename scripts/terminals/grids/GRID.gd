extends Control

export var testing = false
var parent
var my_terminal_contents = []

func _ready():
	parent = get_parent()
	populate_inventory()
	populate_terminal()
	if testing == false:
		$ButtonSaveReload.hide()
	## modulate.a = 0
	

func _on_ButtonCommit_pressed():
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		parent.can_be_opened = true
		Signals.emit_signal("close_terminal")
		record_inventory()
		record_terminal()
		var sources = get_tree().get_nodes_in_group("source")
		var chain_key = 0
		for source in sources:
			source.record_signal_chain([], chain_key)
			chain_key = parent.signal_chains.size()
		## print(parent.signal_chains)
		queue_free()
		## hide()
	else:
		get_tree().call_group("source", "record_signal_chain", 0)

func _on_ButtonExit_pressed():
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		parent.can_be_opened = true
		Signals.emit_signal("close_terminal")
		queue_free()
		## hide()
	else:
		print("exit")

func _on_ButtonSaveReload_pressed():
	record_inventory()
	record_terminal()
	for content in my_terminal_contents:
		print(str(content) + ",")
	get_tree().reload_current_scene()
	
func populate_inventory():
	var inv_index = 0
	for i in $Inventory.get_children():
		if !i.is_in_group("box"):
			continue
		if inv_index >= game_data.player_inventory.size():
			break
		## might need to error-check this:
		var inv_item = game_data.player_inventory[inv_index][0]
		var inv_inst = load(inv_item).instance()
		inv_inst.connect_config = game_data.player_inventory[inv_index][1]
		i.add_child(inv_inst)
		inv_index += 1

func populate_terminal():
	## only populate if parent has up-to-date contents
	if parent.is_in_group("terminal") && parent.terminal_contents != []:
		my_terminal_contents = parent.terminal_contents
		## print(my_terminal_contents)
		var term_index = 0
		for i in $Machine_Grid.get_children():
			## breakpoint
			if term_index >= my_terminal_contents.size():
					break
			if i.is_in_group("box"):
				if my_terminal_contents[term_index] != []:
					var term_item = my_terminal_contents[term_index][0]
					var term_item_inst = load(term_item).instance()
					term_item_inst.pre_rot_left = my_terminal_contents[term_index][1]
					term_item_inst.connect_config = my_terminal_contents[term_index][2]
					i.add_child(term_item_inst)
				term_index += 1

func record_inventory():
	## clear array
	game_data.player_inventory.clear()
	## iterate over children of $Inventory
	for i in $Inventory.get_children():
		if !i.is_in_group("box"):
			continue
		## write items to inventory
		for j in i.get_children():
			if j.is_in_group("component"):
				game_data.player_inventory.append([j.filename, j.connect_config])
				j.queue_free()
	## print(game_data.player_inventory)

func record_terminal():
	var term_index = 0
	## clear array
	my_terminal_contents.clear()
	## iterate over Machine
	for i in $Machine_Grid.get_children():
		if i.is_in_group("box"):
			var item_found = false
			for j in i.get_children():
				if j.is_in_group("component"):
					my_terminal_contents.append([j.filename, 0, 0])
					## convert rotation degrees to pre_rot_left integer
					var pre_rot_temp 
					## achieve negative degrees
					while j.rotation_degrees > 0:
						j.rotation_degrees -= 360
					pre_rot_temp = int(abs(j.rotation_degrees / 90))
					my_terminal_contents[term_index][1] = pre_rot_temp
					my_terminal_contents[term_index][2] = j.connect_config
					item_found = true
			if item_found == false:
				my_terminal_contents.append([])
			term_index += 1
	if parent.is_in_group("terminal"):
		parent.terminal_contents = my_terminal_contents
		## print(parent.terminal_contents)
