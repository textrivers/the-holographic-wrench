extends Spatial

var boxes = []

func _ready():
	randomize()
	
	get_box_children(self)
	populate_boxes(boxes)


func get_box_children(node):
	
	for child in node.get_children():
		if child.is_in_group("box"):
			boxes.append(child)
			continue
		if child.get_child_count() > 0:
			get_box_children(child)
		else:
			continue


func populate_boxes(boxes_to_populate):
	var selected_box
	var item_count = 0
	while item_count < 4:
		selected_box = randi() % boxes.size()
		if boxes_to_populate[selected_box].machine_part_visible() == true:
			continue
		else:
			boxes[selected_box].show_machine_part()
			item_count += 1
