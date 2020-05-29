extends Area2D

var dragging = false
var drag_offset = Vector2()
var drag_dest = Vector2()

var can_click = false
var can_drop = false
var drop_target
var drop_targets = []

var parent

func _ready():
	parent = get_node("..")
	drop_targets.append(parent)
	drop_target = drop_targets.back()

func _process(_delta):
	if can_click == true:
		if Input.is_action_just_pressed("interact"):
			## print("click")
			drop_target.highlight()
			dragging = true
			drag_offset = position - get_viewport().get_mouse_position()
	
	if dragging == true:
		$LeiaSprite.modulate = Color(1, 1, 1, 0.5)
		$CollisionShape2D.scale = Vector2(0.5, 0.5)
		drag_dest = get_viewport().get_mouse_position() + drag_offset
		position = lerp(position, drag_dest, 0.5)
		
		if Input.is_action_just_released("interact"):
			## print("unclick")
			## breakpoint
			dragging = false
			drag_offset = Vector2()
			if can_drop == true:
				## so the drop_target doesn't get reset to null when
				## the Area_exited signals fire
				var drop_target_transitional = drop_target
				## print("dropped")
				parent.remove_child(self)
				drop_target_transitional.add_child(self)
				parent = drop_target_transitional
				drop_targets.clear()
				drop_targets.append(parent)
				drop_target = parent
			position = Vector2(0, 0)
			drop_target.unhighlight()
	
	else:
		$LeiaSprite.modulate = Color(1, 1, 1, 1)
		$CollisionShape2D.scale = Vector2(1, 1)

func _on_Area2D_mouse_entered():
	can_click = true

func _on_Area2D_mouse_exited():
	can_click = false

func _on_LeiaArea2D_area_entered(area):
	if area.is_in_group("box"):
		can_drop = true
		drop_targets.append(area)
		drop_target.unhighlight()
		drop_target = area
		if dragging == true:
			drop_target.highlight()

func _on_LeiaArea2D_area_exited(area):
	if area.is_in_group("box"):
		area.unhighlight()
		drop_targets.erase(area)
		if area == drop_target:
			drop_target = drop_targets.back()
			if dragging == true:
				drop_target.highlight()
		## else:
			## drop_target = parent
			## drop_target.highlight()
