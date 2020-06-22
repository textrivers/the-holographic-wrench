extends Navigation

var instance_counter = 1
var instance_pos_dict = {}
var instance_rot_mod = 0

var items_max

func _ready():
	randomize()
	
	## use this space in extending scripts to specify:
	## instance_pos_dict = all four player start positions
	## instance_rot_mod = change starting rotation if needed
	## items_max = items available on the level
	
	Signals.connect("reset_level", self, "increment_player")
	
	$GUI/Panel/CenterContainer/Label.set_text("0 items found")
	
	## moved add_players() to extending scripts
	## move populate_boxes() to extending scripts also
	
	$GUI/AnyKeyControl/Panel/RichTextLabel.set_text("Press CTRL to begin player " + str(game_data.scene_counter))
	
	
func populate_boxes():
	## POPULATE BOXES ------------------------------
	## making sure all boxes know their box ID number
	var box_counter = 0
	for n in game_data.all_boxes:
			n.box_ID = box_counter
			box_counter += 1
	
	if game_data.scene_counter == 1:
		var selected_box
		var item_count = 0
	
		## populate items dict, populate boxes
		for i in range(game_data.all_boxes.size()):
			game_data.items_dict[i] = [-1, -1, 0]
		
		while item_count < items_max:
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
	player.translation = instance_pos_dict[instance_counter]
	player.rotation_degrees.y += instance_rot_mod
	add_child(player)
	instance_counter += 1
	return

func increment_player():
	if game_data.scene_counter < 4: 
		game_data.scene_counter += 1
		get_tree().reload_current_scene()
		game_data.all_boxes.clear()
		game_data.items_found_counter = 0
