extends Position3D

## adapts code from GDQuest here: https://www.youtube.com/watch?v=lNNO-Gh5j78

var grid_size = Vector3()
var grid_position = Vector3()
var LERP_SPEED = 0.1

onready var parent = get_parent()

export var grid_snap = false

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_size = Vector3(12, 1, 12)
	set_as_toplevel(true) ## so camera crane doesn't inherit parent position
	update_grid_position()

func _physics_process(delta):
	if grid_snap == true:
		update_grid_position()
	
	update_rotation()
	
	## MOVE CAMERA ## ------------------
	if grid_snap == true:
		translation = lerp(translation, grid_position * grid_size, LERP_SPEED)
	else: 
		translation = lerp(translation, parent.translation, LERP_SPEED)

func update_grid_position():
	var x = round(parent.translation.x / grid_size.x)
	## var y = round(parent.translation.y / grid_size.y)
	var y = parent.translation.y
	var z = round(parent.translation.z / grid_size.z)
	var new_grid_position = Vector3(x, y, z)
	if grid_position == new_grid_position:
		return
	
	grid_position = new_grid_position

func update_rotation():
	rotation_degrees.y = parent.rotation_degrees.y
	rotation_degrees.x = parent.x_rot
