extends Control

export var testing = false

func _ready():
	populate_inventory()
	print(game_data.player_inventory)

func _on_ButtonCommit_pressed():
	print("commit")
	record_inventory()
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
	else:
		pass

func _on_ButtonExit_pressed():
	print("exit")
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
	else:
		print(game_data.player_inventory)

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
		
func record_inventory():
	## breakpoint
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
	print(game_data.player_inventory)

