extends Control

export var testing = false

func _ready():
	populate_inventory()
	print(game_data.player_inventory)
	for child in get_children():
		## child.owner = self
		print(str(child.name) + " | " + str(child.get_owner()))

func set_children_owner(_passed_child):
	for child in get_children():
		child.owner = self
		set_children_owner(child)

func _on_ButtonCommit_pressed():
	record_inventory()
	save_self_scene()
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
	else:
		print("commit")

func _on_ButtonExit_pressed():
	if testing == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		queue_free()
	else:
		print("exit")

func _on_ButtonSaveReload_pressed():
	record_inventory()
	save_self_scene()
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
	print(game_data.player_inventory)

func save_self_scene():
	for child in get_children():
		child.set_owner(self)
	var packedscene = PackedScene.new()
	packedscene.pack(get_tree().get_current_scene())
	var err = ResourceSaver.save("res://scenes/Machine_System.tscn", packedscene) 
	if err:
		print(str(err)) 
	## TODO Must save with a unique filename that the game can find later? 
	## Send this to the parent terminal? 


