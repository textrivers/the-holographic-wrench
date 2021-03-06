extends Spatial

var can_be_opened = false
var box_ID = -1
var game_underway = false
var current_frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	game_data.all_boxes.append(self)
	Signals.connect("initiate_fun", self, "mark_game_start")


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
				$FrontSide.hide()
				game_data.items_dict[box_ID][0] = current_frame
			else:
				if self.has_node("Item"):
					if $Item.visible == true:
						$Item.hide()
						game_data.items_dict[box_ID][1] = current_frame
						## game_data.items_found_counter += 1


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
