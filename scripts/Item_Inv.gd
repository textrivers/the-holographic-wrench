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
export var connectors = [0, 0, 0, 0]
export var lit = false

func _ready():
	target_rot = 0
	parent = get_node("..")
	drop_targets.append(parent)
	drop_target = drop_targets.back()
	update_my_grid_pos()
	if lit == false:
		$Sprite.self_modulate = Color(0.5, 0.5, 0.5, 1)

func _process(_delta):
	## ROTATE PIECES ------------------------------------
	if rotation_degrees != target_rot:
		var curret_rad = deg2rad(rotation_degrees)
		var target_rad = deg2rad(target_rot)
		rotation = lerp_angle(curret_rad, target_rad, 0.2)
	
	## CLICK -------------------------------------------
	if can_click == true:
		if Input.is_action_just_pressed("interact"):
			## print("click")
			drop_target.highlight()
			dragging = true
			drag_offset = position - get_viewport().get_mouse_position()
	
	## DRAG ---------------------------------------------
	if dragging == true:
		$Sprite.modulate = Color(1, 1, 1, 0.5)
		$CollisionShape2D.scale = Vector2(0.5, 0.5)
		drag_dest = get_viewport().get_mouse_position() + drag_offset
		position = lerp(position, drag_dest, 0.5)
		
		## DROP --------------------------------------------
		if Input.is_action_just_released("interact"):
			## breakpoint
			dragging = false
			drag_offset = Vector2()
			if can_drop == true:
				## item swap
				var target_children = drop_target.get_children()
				for child in target_children:
					if child.is_in_group("item"):
						drop_target.remove_child(child)
						parent.add_child(child)
						child.drop_targets.clear()
						child.drop_targets.append(parent)
						child.parent = parent
						child.drop_target = parent
						update_my_grid_pos()
						if parent.machine_box == true:
							if child.check_connectivity() == true:
								child.lit = true
								$Sprite.self_modulate = Color(1, 1, 1, 1)
							else:
								child.lit = false
								$Sprite.self_modulate = Color(0.5, 0.5, 0.5, 1)
						
				## item drop
				## first line necessary bc Area2D exit signal on reparent
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
				if check_connectivity() == true:
					lit = true
					$Sprite.self_modulate = Color(1, 1, 1, 1)
				else:
					lit = false
					$Sprite.self_modulate = Color(0.5, 0.5, 0.5, 1)
		
		## GET ROTATION and ROTATE CONNECTORS
		if Input.is_action_just_pressed("rotate_left"):
			target_rot -= 90
			connectors.push_back(connectors.front())
			connectors.pop_front()
		if Input.is_action_just_pressed("rotate_right"):
			target_rot += 90
			connectors.push_front(connectors.back())
			connectors.pop_back()
	
	## AS YOU WERE ----------------------------------------------
	else:
		$Sprite.modulate = Color(1, 1, 1, 1)
		$CollisionShape2D.scale = Vector2(1, 1)

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

func check_connectivity():
	var neighbor
	var neighbor_item
	## breakpoint
	if connectors[0] == 1:
		if my_grid_pos.y != 0:
			neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y - 1)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					neighbor_item = item
					if neighbor_item.lit == true:
						return true
	if connectors[1] == 1:
		if my_grid_pos.x < game_data.machine_grid.size() - 1:
			neighbor = game_data.machine_grid[my_grid_pos.x + 1][(my_grid_pos.y)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					neighbor_item = item
					if neighbor_item.lit == true:
						return true
	if connectors[2] == 1:
		if my_grid_pos.y < game_data.machine_grid[my_grid_pos.x].size() - 1:
			neighbor = game_data.machine_grid[my_grid_pos.x][(my_grid_pos.y + 1)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					neighbor_item = item
					if neighbor_item.lit == true:
						return true
	if connectors[3] == 1:
		## if game_data.machine_grid[my_grid_pos.x - 1][(my_grid_pos.y)] != null:
		if my_grid_pos.x != 0:
			neighbor = game_data.machine_grid[my_grid_pos.x - 1][(my_grid_pos.y)]
			for item in neighbor.get_children():
				if item.is_in_group("item"):
					neighbor_item = item
					if neighbor_item.lit == true:
						return true
	## else:
	return false
		
func update_my_grid_pos():
		my_grid_pos.x = abs(int(round(parent.position.x / 64)))
		my_grid_pos.y = abs(int(round(parent.position.y / 64)))
