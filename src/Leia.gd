extends KinematicBody

## movement code adapted from GDQuest demo,
## github repo here: https://github.com/GDQuest/godot-demos/tree/master/2019/03-23-z-axis-in-2d


const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)

export var speed := 11.0
export var gravity := 30.0
export var jump_force := 12.0

var velocity_y := 0.0

var ROTATION_SPEED = 0.1
var new_rot

func _ready():
	new_rot = rotation_degrees.y
	
func _physics_process(delta):
	## MOVEMENT ## --------------------------------
	var direction_ground = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	direction_ground = direction_ground.normalized()
	if not is_on_floor():
		velocity_y -= gravity * delta
	var velocity = Vector3()
	## modifying input so movement is relative to the player
	var my_global_xform = get_global_transform()
	velocity += my_global_xform.basis.z * direction_ground.y * speed
	velocity += my_global_xform.basis.x * direction_ground.x * speed
	velocity.y = velocity_y
	move_and_slide(velocity, FLOOR_NORMAL)
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0
	## -----------------------------------------------
	
	## ROTATION ## -----------------------------------
	if Input.is_action_just_pressed("rotate_left"):
		new_rot -= 90
	if Input.is_action_just_pressed("rotate_right"):
		new_rot += 90
	if new_rot != rotation_degrees.y:
		var new_rad = deg2rad(new_rot)
		rotation.y = lerp_angle(rotation.y, new_rad, ROTATION_SPEED)
	## -----------------------------------------------
	
	## QUIT ## ---------------------------------------
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		velocity_y = jump_force

