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



