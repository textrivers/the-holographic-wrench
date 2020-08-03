extends Spatial

## for each different configuration or size of terminal, do the following:
## - new inherited scene from TERMINAL.tscn, save
## - new inherited scene from GRID.tscn, save
## - copy path of new grid, paste into TERMINAL.my_grid, SAVE!!
## - in terminal inherited scene, Extend script
## - in extended script _ready(), paste contents of grid if any

## for tutorial terminal:
## XX one new scene that inherits TERMINAL (TERMINAL_tut)
## XX several new GRIDS (GRID_tut_#)
## XX copy path of GRID_tut_1 into TERMINAL_tut.my_grid, SAVE!!
## XX on GRID_tut_1, extend GRID.gd, make sure all GRID_tuts get it
## XX in each GRID, put path of next grid in the on-commit function, 
## 		set TERMINAL_tut.my_grid to that if Commit successful,
## 		load TERMINAL_tut.my_grid, free self (eventually smooth transition)
## XX also in each GRID_tut, put the contents of terminal and inventory,
## 		making sure they're not overwritten by GRID


var can_be_opened = false
var box_ID = -1
var game_underway = false
var current_frame = 0
export var my_grid = ""
var terminal_contents = [
]

var signal_chains 

# Called when the node enters the scene tree for the first time.
func _ready():
	## game_data.all_boxes.append(self)
	Signals.connect("initiate_fun", self, "mark_game_start")
	game_data.player_inventory = []

func _physics_process(delta):
	if game_underway == true:
		if game_data.items_dict.has(box_ID):
			if game_data.items_dict[box_ID][0] == current_frame:
				$FrontSide.hide()
			if game_data.items_dict[box_ID][1] == current_frame:
				$Item.hide()
				game_data.items_found_counter += 1
				Signals.emit_signal("item_found")
		current_frame += 1

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		can_be_opened = true
		$FrontSide/Sprite.show()

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		can_be_opened = false
		$FrontSide/Sprite.hide()

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if can_be_opened == true:
			if $FrontSide.visible == true:
				open_terminal()

func open_terminal():
	can_be_opened = false

	signal_chains = []
	
	var machine_system = load(my_grid).instance()
	add_child(machine_system)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Signals.emit_signal("open_terminal")

func mark_game_start():
	game_underway = true

func has_item():
	if self.has_node("Item"):
		return true
	else:
		return false

func add_item():
	var added_item = load("res://scenes/Item.tscn").instance()
	add_child(added_item)
