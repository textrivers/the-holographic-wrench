extends KinematicBody

## movement code adapted from GDQuest demo,
## github repo here: https://github.com/GDQuest/godot-demos/tree/master/2019/03-23-z-axis-in-2d
## and from official Godot 3D FPS tutorial

const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)

var game_in_progress = false
var world

var velocity = Vector3()
var dir = Vector3()
var speed = 12
var ACCEL = 5
var DEACCEL = 10
var gravity = 30.0
var jump_force = 12.0

var velocity_y := 0.0

export var rotation_snap = false

var feeler
var rot_offset
var ROTATION_SPEED = 0.1
export var MOUSE_SENSITIVITY = 0.1
var new_rot

var ghost_pos_dict = {}
var current_frame

func _ready():
	feeler = -90
	new_rot = rotation_degrees.y
	
	Signals.connect("initiate_fun", self, "begin_playing")
	Signals.connect("cease_and_desist_fun", self, "stop_playing")
	
	current_frame = 0
	
	world = get_node("/root/Reactor_Test")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	
	## CAPTURING/FREEING CURSOR -------------------
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if game_in_progress == true:
		
		## RECORD POSITION FOR GHOST ## ---------------
		ghost_pos_dict[current_frame] = [translation, rotation_degrees]
		current_frame += 1
		
		## MOVEMENT ## --------------------------------
		dir = Vector3()
		var direction_ground = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
		
		if not is_on_floor():
			velocity_y -= gravity * delta
		
		## moved velocity declaration to top level from here
		
		velocity.y = velocity_y
		## modifying input so movement is relative to the player
		var my_global_xform = get_global_transform()
		## velocity += my_global_xform.basis.z * direction_ground.y * speed 
		## velocity += my_global_xform.basis.x * direction_ground.x * speed 
		dir += my_global_xform.basis.z * direction_ground.y
		dir += my_global_xform.basis.x * direction_ground.x
		dir.y = 0
		dir = dir.normalized()
		
		var hvel = velocity
		hvel.y = 0
		
		var target = dir
		target *= speed
		
		var accel
		if dir.dot(hvel) > 0:
			accel = ACCEL
		else:
			accel = DEACCEL
		
		hvel = hvel.linear_interpolate(target, accel * delta)
		velocity.x = hvel.x
		velocity.z = hvel.z
		
		velocity = move_and_slide(velocity, FLOOR_NORMAL)
		if is_on_floor() or is_on_ceiling():
			velocity_y = 0.0
		
		## JUMPING ## -----------------------------------
		if Input.is_action_pressed("jump"):
			velocity_y = jump_force
		
		## ROTATION ## -----------------------------------
		## if Input.is_action_just_pressed("rotate_left"):
		## 	new_rot -= 90
		## if Input.is_action_just_pressed("rotate_right"):
		## 	new_rot += 90
		
		## snap RotationHelper's y-rotation to 90-degree intervals
		if rotation_snap == true:
			new_rot = round(feeler / 90)
			new_rot *= 90
		else: 
			new_rot = feeler
		
		if new_rot != rotation_degrees.y:
			var new_rad = deg2rad(new_rot)
			rotation.y = lerp_angle(rotation.y, new_rad, ROTATION_SPEED)
	
	## QUIT ## ---------------------------------------
	## if Input.is_action_pressed("ui_cancel"):
	## 	get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		feeler += (event.relative.x * MOUSE_SENSITIVITY * -1)

func begin_playing():
	game_in_progress = true

func stop_playing():
	game_in_progress = false
	game_data.ghost_pos_dict[game_data.scene_counter] = ghost_pos_dict
	if game_data.scene_counter < 4:
		world.increment_player()
		get_tree().call_group("ghost", "deactivate_ghost_playback")
