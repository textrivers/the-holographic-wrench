extends Area2D

var dragging = false
var drag_offset = Vector2()
var drag_dest = Vector2()

var can_click = false
var can_drop = false
var drop_target
var drop_targets = []

var target_rot

var parent

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
var upstream_neighbor = null
var already_propagated = false

func _ready():
	randomize()
	target_rot = 0
	parent = get_node("..")
	drop_targets.append(parent)
	drop_target = drop_targets.back()
	update_my_grid_pos()
	$CollisionShape2D.scale = Vector2(0.9, 0.9)
	if lit == false:
		$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	
	if self.name == "Item_Inv_1":
		connectors = [1, 0, 0, 0]
	
	if self.name == "Item_Inv_2a":
		connectors = [1, 1, 0, 0]
	
	if self.name == "Item_Inv_2b":
		connectors = [1, 0, 1, 0]
	
	if self.name == "Item_Inv_3":
		connectors = [1, 1, 1, 0]
	
	if self.name == "Item_Inv_4":
		connectors = [1, 1, 1, 1]
	
	for _x in range(randi() % 4):
		rotate_left()

func _process(_delta):
	## CLEAR PROPAGATION
	if already_propagated == true:
		already_propagated = false
		
	## ROTATE PIECES ------------------------------------
	if rotation_degrees != target_rot:
		var curret_rad = deg2rad(rotation_degrees)
		var target_rad = deg2rad(target_rot)
		rotation = lerp_angle(curret_rad, target_rad, 0.2)
	
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
					if child.is_in_group("item") && !child.is_in_group("source"):
						if parent.machine_box == true:
							child.break_connectivity()
						drop_target.remove_child(child)
						parent.add_child(child)
						child.drop_targets.clear()
						child.drop_targets.append(parent)
						child.parent = parent
						child.drop_target = parent
						child.update_my_grid_pos()
						if parent.machine_box == true:
							child.make_connectivity()
						
				## item drop
				## transitional necessary bc Area2D exit signal on reparent
				var drop_target_transitional = drop_target 
				parent.remove_child(self)
				drop_target_transitional.add_child(self)
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
	can_click = true

func _on_Item_Inv_mouse_exited():
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
	var neighbor
	var counter = 0
	var lit_counter = 0
	var opposite = (counter + 2) % 4
	
	if already_propagated == false:
		
		already_propagated = true
		
		for connector in connectors:
			if connector == 1:
				var target_pos = my_grid_pos + four_directions[counter]
				if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
					if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid.size() - 1:
						neighbor = game_data.machine_grid[target_pos.x][target_pos.y]
						for item in neighbor.get_children():
							if item.is_in_group("item"):
								if item.connectors[opposite] == 1:
									## dropping (or dropped), setting upstream neighbor
									if item.lit == true:
										lit_counter += 1
										upstream_neighbor = item
									else:
										downstream_neighbors.append(item)
			counter += 1
			opposite = (counter + 2) % 4
		
		if lit_counter == 0:
			lit = false
			$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
			for item in downstream_neighbors:
				item.make_connectivity()
			downstream_neighbors.clear()
		elif lit_counter == 1:
			lit = true
			$Sprite.modulate = Color(1, 1, 1, 1)
			for item in downstream_neighbors:
				item.make_connectivity()
			downstream_neighbors.clear()
		else: ## too many connections
			upstream_neighbor = null
			downstream_neighbors.clear()
			lit = false
			$Sprite.modulate = Color(0.5, 0, 0, 1)

func break_connectivity():
	var neighbor
	var counter = 0
	var opposite = (counter + 2) % 4
	
	if already_propagated == false:
		
		already_propagated = true
		
		for connector in connectors:
			if connector == 1:
				var target_pos = my_grid_pos + four_directions[counter]
				if target_pos.x >= 0 && target_pos.x <= game_data.machine_grid.size() - 1:
					if target_pos.y >= 0 && target_pos.y <= game_data.machine_grid.size() - 1:
						neighbor = game_data.machine_grid[target_pos.x][target_pos.y]
						for item in neighbor.get_children():
							if item.is_in_group("item"):
								if item.connectors[opposite] == 1:
									## dragging, breaking connectivity except with "upstream_neighbor"
									if upstream_neighbor != null:
										if item != upstream_neighbor:
											downstream_neighbors.append(item)
			counter += 1
			opposite = (counter + 2) % 4
		
		lit = false
		$Sprite.modulate = Color(0.5, 0.5, 0.5, 1)
		for item in downstream_neighbors:
			item.break_connectivity()
		downstream_neighbors.clear()
		upstream_neighbor = null

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
