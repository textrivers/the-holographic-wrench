extends Node

var connectors
var sources
var my_grid_pos
var neighbor
var lit
var already_propagated



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	
	if connectors[0] == 1:
		if my_grid_pos.y != 0:
			neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y - 1)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					if item.connectors[2] == 1 && item.lit == true && item.sources[2] == 0:
						sources[0] = 1
	if connectors[1] == 1:
		if my_grid_pos.x < game_data.machine_grid.size() - 1:
			neighbor = game_data.machine_grid[my_grid_pos.x + 1][(my_grid_pos.y)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					if item.connectors[3] == 1 && item.lit == true && item.sources[3] == 0:
						sources[1] = 1
	if connectors[2] == 1:
		if my_grid_pos.y < game_data.machine_grid[my_grid_pos.x].size() - 1:
			neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y + 1)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					if item.connectors[0] == 1 && item.lit == true && item.sources[0] == 0:
						sources[2] = 1
	if connectors[3] == 1:
		## if game_data.machine_grid[my_grid_pos.x - 1][(my_grid_pos.y)] != null:
		if my_grid_pos.x != 0:
			neighbor = game_data.machine_grid[my_grid_pos.x - 1][(my_grid_pos.y)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					if item.connectors[1] == 1 && item.lit == true && item.sources[1] == 0:
						sources[3] = 1
	if sources.has(1):
		lit = true
		$Sprite.self_modulate = Color(1, 1, 1, 1)
	else:
		lit = false
		$Sprite.self_modulate = Color(0.5, 0.5, 0.5, 1)

func propagate_connectivity():
	if already_propagated == false:
		
		var neighbor
		if connectors[0] == 1 && my_grid_pos.y != 0:
			if sources[0] != 1:
				neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y - 1)]
				for item in neighbor.get_children():
					if item.is_in_group("item"):
						already_propagated = true
						if lit == true:
							item.lit = true
							item.sources[2] = 1
							item.get_node("Sprite").self_modulate = Color(1, 1, 1, 1)
						if lit == false:
							if item.sources[2] == 1:
								item.lit = false
								item.sources[2] = 0
								item.get_node("Sprite").self_modulate = Color(0.5, 0.5, 0.5, 1)
						item.propagate_connectivity()
		if connectors[1] == 1 && my_grid_pos.x < game_data.machine_grid.size() - 1:
			if sources[1] != 1:
				neighbor = game_data.machine_grid[my_grid_pos.x + 1][(my_grid_pos.y)]
				for item in neighbor.get_children():
					if item.is_in_group("item"):
						already_propagated = true
						if lit == true:
							item.lit = true
							item.sources[3] = 1
							item.get_node("Sprite").self_modulate = Color(1, 1, 1, 1)
						if lit == false:
							if item.sources[3] == 1:
								item.lit = false
								item.sources[3] = 0
								item.get_node("Sprite").self_modulate = Color(0.5, 0.5, 0.5, 1)
						item.propagate_connectivity()
		if connectors[2] == 1 && my_grid_pos.y < game_data.machine_grid[my_grid_pos.x].size() - 1:
			if sources[2] != 1:
				neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y + 1)]
				for item in neighbor.get_children():
					if item.is_in_group("item"):
						already_propagated = true
						if lit == true:
							item.lit = true
							item.sources[0] = 1
							item.get_node("Sprite").self_modulate = Color(1, 1, 1, 1)
						if lit == false:
							if item.sources[0] == 1:
								item.lit = false
								item.sources[0] = 0
								item.get_node("Sprite").self_modulate = Color(0.5, 0.5, 0.5, 1)
						item.propagate_connectivity()
		if connectors[3] == 1 && my_grid_pos.x != 0:
			if sources[3] != 1:
				neighbor = game_data.machine_grid[my_grid_pos.x - 1][(my_grid_pos.y)]
				for item in neighbor.get_children():
					if item.is_in_group("item"):
						already_propagated = true
						if lit == true:
							item.lit = true
							item.sources[1] = 1
							item.get_node("Sprite").self_modulate = Color(1, 1, 1, 1)
						if lit == false:
							if item.sources[1] == 1:
								item.lit = false
								item.sources[1] = 0
								item.get_node("Sprite").self_modulate = Color(0.5, 0.5, 0.5, 1)
						item.propagate_connectivity()


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



func set_children_owner(_passed_child):
	for child in get_children():
		child.owner = self
		set_children_owner(child)

func has_item():
	if self.has_node("Item"):
		return true
	else:
		return false

func add_item():
	var added_item = load("res://scenes/Item.tscn").instance()
	add_child(added_item)
	
	
func record_signal_chain(chain_array, chain_key):
	var neighbor
	var counter = 0
	var opposite = (counter + 2) % 4
	var lit_counter = 0
	
	for connector in connectors:
		if connector == 1:
			var target_pos = my_grid_pos + four_directions[counter]
			if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
				if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid[0].size() - 1:
					if typeof(game_data.machine_grid[target_pos.x][target_pos.y]) == TYPE_OBJECT:
						neighbor = game_data.machine_grid[target_pos.x][target_pos.y]
						for item in neighbor.get_children():
							if item.is_in_group("component"):
								if item.connectors[opposite] == 1 && item.lit == true:
									if item != upstream_neighbor:
										## keep track of how many lit connections there are
										lit_counter += 1
										## contingency for branching
										if lit_counter > 1:
											chain_key += 1
											## remove last item
											chain_array.pop_back()
										## add item to ongoing signal chain array
										chain_array.append(item.my_grid_pos)
										## propagate downstream
										var temp_array = chain_array.duplicate(true)
										item.record_signal_chain(temp_array, chain_key)
		counter += 1
		opposite = (counter + 2) % 4
	
	if lit_counter == 0:
		for x in range(20):
			if terminal.signal_chains.has(chain_key):
				chain_key += 1
			else:
				terminal.signal_chains[chain_key] = chain_array
				break
