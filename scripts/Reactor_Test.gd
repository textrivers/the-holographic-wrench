extends Navigation

var instance_counter = 1
var instance_pos = Vector3(-27, 1.667, -7.5)

func _ready():
	randomize()
	
	Signals.connect("item_found", self, "increment_item_count")
	Signals.connect("reset_level", self, "increment_player")
	
	$GUI/Panel/CenterContainer/Label.set_text(str(game_data.items_found_counter) + " items found")
	
	while instance_counter < 5:
		add_players()
	
	$AnyKeyControl/Panel/RichTextLabel.set_text("Press CTRL to begin player " + str(game_data.scene_counter))
	
	## POPULATE BOXES ------------------------------
	## making sure all boxes know their box ID number
	var box_counter = 0
	for n in game_data.all_boxes:
			n.box_ID = box_counter
			box_counter += 1
	
	if game_data.scene_counter == 1:
		var selected_box
		var item_count = 0
	
		## create items dict, populate boxes
		for i in range(game_data.all_boxes.size()):
			game_data.items_dict[i] = [-1, -1, 0]
		
		while item_count < 12:
			selected_box = randi() % game_data.all_boxes.size()
			if game_data.all_boxes[selected_box].has_item() == true:
				continue
			else:
				game_data.all_boxes[selected_box].add_item()
				item_count += 1
				game_data.items_dict[selected_box][2] = 1
	else: 
		for i in game_data.items_dict:
			if game_data.items_dict[i][2] == 1:
				game_data.all_boxes[i].add_item()

func add_players():
	var player
	if instance_counter == game_data.scene_counter:
		player = load(game_data.player_dict[instance_counter]).instance()
	else: 
		player = load(game_data.ghost_dict[instance_counter]).instance()
		player.ghost_ID = instance_counter
	player.translation = instance_pos
	player.translation.z += 3 * instance_counter
	player.rotation_degrees.y = -90
	add_child(player)
	instance_counter += 1
	return

func increment_player():
	if game_data.scene_counter < 4: 
		game_data.scene_counter += 1
		get_tree().reload_current_scene()
		game_data.all_boxes.clear()
		game_data.items_found_counter = 0

func increment_item_count():
	$GUI/Panel/CenterContainer/Label.set_text(str(game_data.items_found_counter) + " items found")
