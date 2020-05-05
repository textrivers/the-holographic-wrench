extends Position3D

var grid_size = Vector3()
var grid_position = Vector3()
var LERP_SPEED = 0.1

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_size = Vector3(12, 4, 12)
	set_as_toplevel(true)
	update_grid_position()

func _physics_process(delta):
	update_grid_position()
	update_rotation()
	
	## MOVE CAMERA ## ------------------
	translation = lerp(translation, grid_position * grid_size, LERP_SPEED)

func update_grid_position():
	var x = round(parent.translation.x / grid_size.x)
	var y = round(parent.translation.y / grid_size.y)
	var z = round(parent.translation.z / grid_size.z)
	var new_grid_position = Vector3(x, y, z)
	if grid_position == new_grid_position:
		return
	
	grid_position = new_grid_position

func update_rotation():
	rotation_degrees.y = parent.rotation_degrees.y
