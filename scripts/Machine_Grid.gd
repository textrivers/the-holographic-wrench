extends Node2D

var box_grid = []
var x_size = 4
var y_size = 4

func _ready():
	for x in range(x_size):
		box_grid.append([])
		for y in range(y_size):
			box_grid[x].append(0)
	var boxes = get_children()
	for box in boxes:
		if box.is_in_group("box"):
			var x = int(abs(round(box.position.x / 64)))
			var y = int(abs(round(box.position.y / 64)))
			box_grid[x][y] = box
	
	game_data.machine_grid = box_grid

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
