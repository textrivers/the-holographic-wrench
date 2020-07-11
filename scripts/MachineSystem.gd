extends Control

export var testing = false
var parent
var my_terminal_contents = [
	## row 1 
	[],
	[],
	["res://scenes/components/Component_numtest-3_2a.tscn", 3],
	[],
	## row 2
	["res://scenes/Components/Component_SOURCE_1.tscn", 3],
	["res://scenes/Components/Component_light_2b.tscn", 1],
	["res://scenes/Components/Component_nearest_2a.tscn", 2],
	[],
	## row 3
	[],
	[],
	[],
	["res://scenes/Components/Component_circuit-complete_1.tscn", 0],
	## row 3
	["res://scenes/Components/Component_circuit-complete_1.tscn", 0],
	["res://scenes/Components/Component_surveillance-bot_2a.tscn", 0],
	["res://scenes/Components/Component_surveillance-bot_3.tscn", 0],
	["res://scenes/Components/Component_surveillance-bot_4.tscn", 0]
]

func _ready():
	parent = get_parent()
	populate_inventory()
	populate_terminal()
	print(game_data.player_inventory)
	for child in get_children():
		## child.owner = self
		print(str(child.name) + " | " + str(child.get_owner()))
	if testing == false:
		$ButtonSaveReload.hide()

func set_children_owner(_passed_child):
	for child in get_children():
		child.owner = self
		set_children_owner(child)

func _on_ButtonCommit_pressed():

	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		parent.can_be_opened = true
		get_tree().paused = false
		queue_free()
		record_inventory()
		record_terminal()
	else:
		print("commit")

func _on_ButtonExit_pressed():
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		## parent.can_be_opened = true
		get_tree().paused = false
		queue_free()
	else:
		print("exit")

func _on_ButtonSaveReload_pressed():
	record_inventory()
	record_terminal()
	## save_self_scene()
	if testing == true:
		get_tree().reload_current_scene()
	
func populate_inventory():
	var inv_index = 0
	for i in $Inventory.get_children():
		if !i.is_in_group("box"):
			continue
		if inv_index >= game_data.player_inventory.size():
			break
		## might need to error-check this:
		var inv_item = game_data.player_inventory[inv_index]
		var inv_inst = load(inv_item).instance()
		i.add_child(inv_inst)
		inv_index += 1

func populate_terminal():
	## copy parent's manifest
	if parent.is_in_group("terminal"):
		my_terminal_contents = parent.terminal_contents
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
				i.add_child(term_item_inst)
			term_index += 1

func record_inventory():
	var inv_index = 0
	## clear array
	game_data.player_inventory.clear()
	## iterate over children of $Inventory
	for i in $Inventory.get_children():
		if !i.is_in_group("box"):
			continue
		## write items to inventory
		for j in i.get_children():
			if j.is_in_group("item"):
				game_data.player_inventory.append(j.filename)
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
				if j.is_in_group("item"):
					my_terminal_contents.append([j.filename, 0])
					## convert rotation degrees to pre_rot_left integer
					var pre_rot_temp 
					## achieve negative degrees
					while j.rotation_degrees > 0:
						j.rotation_degrees -= 360
					pre_rot_temp = abs(j.rotation_degrees / 90)
					my_terminal_contents[term_index][1] = pre_rot_temp
					item_found = true
			if item_found == false:
				my_terminal_contents.append([])
			term_index += 1
	if parent.is_in_group("terminal"):
		parent.terminal_contents = my_terminal_contents
