extends Area2D

var dragging = false
var drag_offset = Vector2()
var drag_dest = Vector2()

export var moveable = true
var can_click = false
var can_drop = false
var drop_target
var drop_targets = []

var target_rot = 0

var parent
var terminal

var my_grid_pos = Vector2()
var connectors = [0, 0, 0, 0]
var downstream_neighbors = []
var four_directions = [
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(-1, 0)
]
export var lit = false
export var pre_rot_left = 0
export var description = "Component"
var description_label

var upstream_neighbor = null

var signal_on_commit = [
	"",
	""
]

export var connect_config = 0
var config_sprites = [
	preload("res://assets/item_connect_1.png"),
	preload("res://assets/item_connect_2a.png"),
	preload("res://assets/item_connect_2b.png"),
	preload("res://assets/item_connect_3.png"),
	preload("res://assets/item_connect_4.png")
	]
var connector_array = [
		[1, 0, 0, 0], 
		[1, 1, 0, 0], 
		[1, 0, 1, 0],
		[1, 1, 1, 0],
		[1, 1, 1, 1]
	]


func _ready():
	randomize()
	var new_tex = config_sprites[connect_config]
	$Sprite.set_texture(new_tex)
	connectors = connector_array[connect_config]
	
	parent = get_parent()
	terminal = get_parent().get_parent().get_parent().get_parent()
	description_label = parent.get_parent().get_parent().get_node("ItemDescription")
	drop_targets.append(parent)
	drop_target = drop_targets.back()
	update_my_grid_pos()
	$CollisionShape2D.scale = Vector2(0.9, 0.9)
	if lit == false:
		$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	
	if parent.machine_box == true:
		## call_deferred("pre_rotate")
		if is_in_group("source"):
			call_deferred("make_connectivity")

func pre_rotate():
	## calls to pre_rotate() are found in inheriting scripts
	for _x in range(pre_rot_left):
		rotate_left()
	var target_rad = deg2rad(target_rot)
	rotation = target_rad
	if has_node("Sprite/ID_Sprite"):
		$Sprite/ID_Sprite.rotation = -rotation

func _process(_delta):
		
	## ROTATE PIECES ------------------------------------
	if rotation_degrees != target_rot:
		var curret_rad = deg2rad(rotation_degrees)
		var target_rad = deg2rad(target_rot)
		rotation = lerp_angle(curret_rad, target_rad, 0.2)
		if has_node("Sprite/ID_Sprite"):
			$Sprite/ID_Sprite.rotation = -rotation
	
	## CLICK -------------------------------------------
	if can_click == true:
		if Input.is_action_just_pressed("interact"):
			drop_target.highlight()
			dragging = true
			drag_offset = position - get_viewport().get_mouse_position()
			
			## BREAK CONNECTIVITY
			lit = false
			$Sprite.modulate = Color(0.5, 0.5, 0.5)
			if parent.machine_box == true:
				break_connectivity()

	## DRAG ---------------------------------------------
	if dragging == true:
		$Sprite.modulate = Color(1, 1, 1, 0.5)
		$CollisionShape2D.scale = Vector2(0.5, 0.5)
		drag_dest = get_viewport().get_mouse_position() + drag_offset
		position = lerp(position, drag_dest, 0.5)
		
		## GET ROTATION and ROTATE CONNECTORS
		if Input.is_action_just_pressed("rotate_left"):
			rotate_left()
		if Input.is_action_just_pressed("rotate_right"):
			rotate_right()
			
		## DROP --------------------------------------------
		if Input.is_action_just_released("interact"):
			## breakpoint
			dragging = false
			drag_offset = Vector2()
			if can_drop == true:
				## item swap
				var target_children = drop_target.get_children()
				for child in target_children:
					if child != self:
						if child.is_in_group("component") && child.moveable == true:
							## breakpoint
							if parent.machine_box == true:
								child.break_connectivity()
							drop_target.remove_child(child)
							parent.add_child(child)
							## child.set_owner(parent)
							child.drop_targets.clear()
							child.drop_targets.append(parent)
							child.parent = parent
							child.drop_target = parent
							child.update_my_grid_pos()
							if parent.machine_box == true:
								child.make_connectivity()
							else:
								child.lit = false
								$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
						
				## item drop
				## transitional necessary bc Area2D exit signal on reparent
				var drop_target_transitional = drop_target 
				parent.remove_child(self)
				drop_target_transitional.add_child(self)
				## self.set_owner(drop_target_transitional)
				parent = drop_target_transitional
				drop_targets.clear()
				drop_targets.append(parent)
				drop_target = parent
			position = Vector2(0, 0)
			drop_target.unhighlight()
			update_my_grid_pos()
			if parent.machine_box == true:
				make_connectivity()
			else:
				$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
			
	## AS YOU WERE ----------------------------------------------
	else:
		## $Sprite.modulate = Color(1, 1, 1, 1)
		$CollisionShape2D.scale = Vector2(0.9, 0.9)

func _on_Item_Inv_mouse_entered():
	## description
	description_label.set_text(description)
	## if !is_in_group("source"):
	if moveable:
		can_click = true

func _on_Item_Inv_mouse_exited():
	description_label.set_text("")
	can_click = false

func _on_Item_Inv_area_entered(area):
	if area.is_in_group("box"):
		can_drop = true
		drop_targets.append(area)
		drop_target.unhighlight()
		drop_target = area
		if dragging == true:
			drop_target.highlight()

func _on_Item_Inv_area_exited(area):
	if area.is_in_group("box"):
		area.unhighlight()
		drop_targets.erase(area)
		if area == drop_target:
			drop_target = drop_targets.back()
			if dragging == true:
				drop_target.highlight()

func make_connectivity():
	## breakpoint
	var neighbor
	var counter = 0
	var lit_counter = 0
	var opposite = (counter + 2) % 4
		
	for connector in connectors:
		if connector == 1:
			var target_pos = my_grid_pos + four_directions[counter]
			if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
				if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid.size() - 1:
					neighbor = game_data.machine_grid[target_pos.x][target_pos.y]
					for item in neighbor.get_children():
						if item.is_in_group("component"):
							if item.connectors[opposite] == 1:
								## dropping (or dropped), setting upstream neighbor
								if item.lit == true && !is_in_group("source"):
									lit_counter += 1
									upstream_neighbor = item
								else:
									downstream_neighbors.append(item)
		counter += 1
		opposite = (counter + 2) % 4
	## hacky cheat to make source always on
	if is_in_group("source"):
		lit_counter = 1
	
	if lit_counter == 0:
		lit = false
		$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	elif lit_counter == 1:
		lit = true
		$Sprite.modulate = Color(1, 1, 1, 1)
		for item in downstream_neighbors:
			if !item.is_in_group("source"):
				item.make_connectivity()
	else: ## too many connections
		upstream_neighbor = null
		lit = false
		$Sprite.modulate = Color(0.5, 0, 0, 1)
	downstream_neighbors.clear()

func break_connectivity():
	var neighbor
	var counter = 0
	var opposite = (counter + 2) % 4
	
	for connector in connectors:
		if connector == 1:
			var target_pos = my_grid_pos + four_directions[counter]
			if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
				if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid.size() - 1:
					neighbor = game_data.machine_grid[target_pos.x][target_pos.y]
					for item in neighbor.get_children():
						if item.is_in_group("component"):
							if item.connectors[opposite] == 1:
								## dragging, breaking connectivity except with "upstream_neighbor"
								if upstream_neighbor != null || is_in_group("source"):
									if item != upstream_neighbor:
										downstream_neighbors.append(item)
		counter += 1
		opposite = (counter + 2) % 4
	
	lit = false
	$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	for item in downstream_neighbors:
		if !item.is_in_group("source"):
			item.break_connectivity()
	downstream_neighbors.clear()
	upstream_neighbor = null

func record_signal_chain(chain_array, chain_key):
	var neighbor
	var counter = 0
	var opposite = (counter + 2) % 4
	var lit_counter = 0
	
	for connector in connectors:
		if connector == 1:
			var target_pos = my_grid_pos + four_directions[counter]
			if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
				if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid.size() - 1:
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

func update_my_grid_pos():
		my_grid_pos.x = abs(int(round(parent.position.x / 64)))
		my_grid_pos.y = abs(int(round(parent.position.y / 64)))

func rotate_left():
	target_rot -= 90
	connectors.push_back(connectors.front())
	connectors.pop_front()

func rotate_right():
	target_rot += 90
	connectors.push_front(connectors.back())
	connectors.pop_back()
